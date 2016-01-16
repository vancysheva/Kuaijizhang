//
//  TestTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BillStreamTableViewController: UITableViewController {

    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
   
    @IBOutlet var billTableView: UITableView!
    
    var billStreamViewModel = BillStreamViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderWithExpense", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerWithExpense")
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderWithIncome", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerWithIncome")
        billTableView.registerNib(UINib(nibName: "BillStreamHeaderWithOut", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerWithOut")
        
        updateUI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let navi = segue.destinationViewController as? UINavigationController, vc = navi.visibleViewController as? AddBillViewController where segue.identifier == "modifyToAddBill" {
          
            
        }
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
        return 12
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billStreamViewModel.getBillCountForMonth(12 - section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let t = billStreamViewModel.getBillAtIndex(indexPath.row, withMonth: 12 - indexPath.section)
        
        let cell = billTableView.dequeueReusableCellWithIdentifier(t.conmment != "" ? "cell" : "cell2", forIndexPath: indexPath)
        
        let day = cell.viewWithTag(1) as! UILabel
        let consumeName = cell.viewWithTag(2) as! UILabel
        let money = cell.viewWithTag(4) as! UILabel
        let imageView = cell.viewWithTag(5) as! UIImageView
        let week = cell.viewWithTag(6) as! UILabel
        
        
        day.text = "\(t.day)"
        consumeName.text = t.consumeName
        if t.conmment != "" {
            let comment = cell.viewWithTag(3) as! UILabel
            comment.text = t.conmment
            //consumeName.removeConstraints(consumeName.constraintsAffectingLayoutForAxis(.Vertical))
            //cell.addConstraint(NSLayoutConstraint(item: consumeName, attribute: .CenterY, relatedBy: .Equal, toItem: cell, attribute: .CenterY, multiplier: 1, constant: 0))
        }
        money.text = "\(t.money)"
        imageView.image = UIImage(named: t.iconName)
        week.text = t.week
        money.textColor = t.billType.color
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let data = billStreamViewModel.getHeaderDataWithMonth(12 - section)
        var identifier = "";
        if data.inconme == 0.0 && data.expense != 0 {
            identifier = "headerWithExpense"
        } else if data.expense == 0.0 && data.inconme != 0 {
            identifier = "headerWithExpense"
        } else if data.expense != 0 && data.inconme != 0 {
            identifier = "header"
        } else {
            identifier = "headerWithOut"
        }
        let headerView = billTableView.dequeueReusableHeaderFooterViewWithIdentifier(identifier) as! BillStreamHeaderView
        headerView.data = data
        
        return headerView
    }

}
