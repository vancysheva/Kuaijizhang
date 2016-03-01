//
//  TestTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import MJRefresh

internal enum ImageType: String {
    case Option = "bill stream more icon"
    case Remark = "remark icon"
}

internal class ToggleUIButton: UIButton {
    
    var imageType: ImageType = .Option
}

class BillStreamTableViewController: UITableViewController {

    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
   
    @IBOutlet weak var optionButton: ToggleUIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addBillButton: UIButton!
    
    @IBOutlet var billTableView: UITableView!
    
    var billStreamViewModel = BillStreamViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderWithExpense", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerWithExpense")
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderWithIncome", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerWithIncome")
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderWithOut", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerWithOut")
        
        updateUI()
        initRefresh()
        
        billTableView.tableFooterView = UIView()
        
        billStreamViewModel.addNotification("BillStreamTableViewController") { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            if case .Delete = dataChangedType {
                let cnt = self.billStreamViewModel.getBillCountForMonth(self.billStreamViewModel.months[indexPath.section])
                if cnt == 0 {
                    self.billTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                } else {
                    self.billTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            } else if case .Update = dataChangedType {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.billTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
            
            if let headerView = self.billTableView.headerViewForSection(indexPath.section) as? BillStreamHeaderView {
                headerView.data = self.billStreamViewModel.getHeaderDataWithMonth(self.billStreamViewModel.months[indexPath.section])
            }
            self.updateUI()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let navi = segue.destinationViewController as? UINavigationController,
            vc = navi.visibleViewController as? AddBillViewController,
            cell = sender as? UITableViewCell,
            indexPath = billTableView.indexPathForCell(cell) {
            vc.addBillViewModel.billForUpdate = billStreamViewModel.getBillByIndex(billIndex: indexPath.row, withMonth: billStreamViewModel.months[indexPath.section])
            billStreamViewModel.updateBillCurrying = billStreamViewModel.updateBill(billIndex: indexPath.row, withSection: indexPath.section)
            vc.billStreamViewModel = billStreamViewModel
                
        } else if segue.identifier == "stream2AddBill" {
            let navi = segue.destinationViewController as! UINavigationController
            let addBillVC = navi.visibleViewController as! AddBillViewController
            addBillVC.addBillViewModel.addNotification("BillStreamTableViewController", notificationHandler: { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
                if case .Insert = dataChangedType {
                    self.billStreamViewModel.refreshData()
                    self.billTableView.reloadData()
                    self.updateUI()
                }
            })
        }
    }
    
    @IBAction func tapOptionButton(sender: ToggleUIButton) {
        
        if optionButton.imageType == .Remark {
            toggleButtonForEditingStyleWidthAnimation()
        } else {
            popoverOptionMenu()
        }
    }
    @IBAction func unwindToBillStream(segue: UIStoryboardSegue) {
    
    }
    
    func initRefresh() {
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("loadNextYearBills"))
        header.setTitle("下拉加载下一年流水", forState: .Idle)
        header.setTitle("放开加载", forState: .Pulling)
        header.setTitle("正在加载...", forState: .Refreshing)
        header.lastUpdatedTimeLabel?.hidden = true
        
        billTableView.mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: Selector("loadPreviousYearBills"))
        footer.setTitle("上拉加载前一年流水", forState: .Idle)
        footer.setTitle("放开加载", forState: .Pulling)
        footer.setTitle("正在加载...", forState: .Refreshing)

        billTableView.mj_footer = footer
    }
    
    func loadNextYearBills() {
        
        let year = billStreamViewModel.currentYear + 1
        billStreamViewModel = BillStreamViewModel(year: year)
        billTableView.reloadData()
        updateUI()
        billTableView.mj_header.endRefreshing()
        setBackItemButtonTitle(year)
    }
    
    func loadPreviousYearBills() {
        
        let year = billStreamViewModel.currentYear - 1
        billStreamViewModel = BillStreamViewModel(year: year)
        billTableView.reloadData()
        updateUI()
        billTableView.mj_footer.endRefreshing()
        setBackItemButtonTitle(year)
    }
    
    func setBillTableEditable() {
        
        setEditing(true, animated: true)
        toggleButtonForEditingStyleWidthAnimation()
    }
    
    func toggleButtonForEditingStyleWidthAnimation() {
        
        let moveDistance = CGFloat(100)//addBillButton.frame.origin.x - optionButton.frame.origin.x

        if optionButton.imageType == .Option {
            
            optionButton.imageType = .Remark
            optionButton.setImage(UIImage(named: ImageType.Remark.rawValue), forState: .Normal)
            
            billTableView.setEditing(true, animated: true)
            addBillButton.hidden = true
            searchButton.hidden = true
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                let affine = self.optionButton.transform
                self.optionButton.transform = CGAffineTransformTranslate(affine, moveDistance, 0)
                }, completion: nil)
        } else {
            optionButton.imageType = .Option
            optionButton.setImage(UIImage(named: ImageType.Option.rawValue), forState: .Normal)
            
            billTableView.setEditing(false, animated: true)
            addBillButton.hidden = false
            searchButton.hidden = false
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                let affine = self.optionButton.transform
                self.optionButton.transform = CGAffineTransformTranslate(affine, -moveDistance, 0)
                }, completion: nil)
        }
    }
    
    func popoverOptionMenu() {
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("BillStreamOptionViewController") as? BillStreamOptionViewController {
            vc.modalPresentationStyle = .Popover
            vc.billStremViewController = self
            if let pvc = vc.popoverPresentationController {
                pvc.permittedArrowDirections = .Up
                pvc.delegate = self
                pvc.sourceView = optionButton
                pvc.backgroundColor = UIColor.darkGrayColor()
                
                presentViewController(vc, animated: true, completion: nil)
                
            }
        }
    }
    
    func setBackItemButtonTitle(year: Int) {
        navigationController?.navigationBar.items?[0].backBarButtonItem = UIBarButtonItem(title: "\(year)年流水", style: .Plain, target: nil, action: nil)
    }
    
    func updateUI() {
        
        let income = billStreamViewModel.getIncome()
        let expense = billStreamViewModel.getExpense()
        incomeLabel.text = "\(income)"
        expenseLabel.text = "\(expense)"
        surplusLabel.text = "\(income - expense)"
    }
}

//MARK: - Datasource and Delegate

extension BillStreamTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return billStreamViewModel.months.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = billStreamViewModel.getCountForSection(billStreamViewModel.months[section])
        return cnt
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cnt = billStreamViewModel.getBillCountForMonth(billStreamViewModel.months[indexPath.section])
        if cnt == 0 {
            return billTableView.dequeueReusableCellWithIdentifier("cellWithoutBills", forIndexPath: indexPath)
        }
        
        let data = billStreamViewModel.getBillAtIndex(billIndex: indexPath.row, withMonth: billStreamViewModel.months[indexPath.section])
        
        let cell = billTableView.dequeueReusableCellWithIdentifier(data.conmment != "" ? "cellWithComment" : "cellWithoutComment", forIndexPath: indexPath) as! BillStreamViewCell
        cell.data = data

        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let month = billStreamViewModel.months[section]
        let data = billStreamViewModel.getHeaderDataWithMonth(month)
        var identifier = "";
        if data.income == 0.0 && data.expense != 0.0 {
            identifier = "headerWithExpense"
        } else if data.expense == 0.0 && data.income != 0.0 {
            identifier = "headerWithIncome"
        } else if data.expense != 0 && data.income != 0.0 {
            identifier = "header"
        } else {
            identifier = "headerWithOut"
        }
        
        let headerView = billTableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) as! BillStreamHeaderView
        headerView.data = data
        headerView.section = section
        headerView.month = month
        

        headerView.tapGestureHandler = {(m, s)->Void in
            if let expandMonth = self.billStreamViewModel.getExpandMonth() where expandMonth != m {
                self.billStreamViewModel.toggleBillsHiddenInMonth(expandMonth)
                for index in 0..<self.billTableView.numberOfSections {
                    if let headerView = self.billTableView.headerViewForSection(index) as? BillStreamHeaderView, ss = headerView.section, mm = headerView.month where mm == expandMonth {
                        self.billTableView.reloadSections(NSIndexSet(index: ss), withRowAnimation: .Automatic)

                    }
                }
            }
            self.billStreamViewModel.toggleBillsHiddenInMonth(m)
            self.billTableView.reloadSections(NSIndexSet(index: s), withRowAnimation: .Automatic)
        }

        return headerView
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cnt = self.billStreamViewModel.getBillCountForMonth(self.billStreamViewModel.months[indexPath.section])
        if cnt == 0 {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if case .Delete = editingStyle {
            billStreamViewModel.deleteBillAtIndex(indexPath.row, withSection: indexPath.section)
        }
    }
}

extension BillStreamTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
