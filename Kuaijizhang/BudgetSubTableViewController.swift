//
//  BudgetSubTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/6.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BudgetSubTableViewController: UITableViewController {
    
    let numberPadOffSetY = CGFloat(4)
    var budgetViewModel: BudgetViewModel?
    var parentIndex: Int?
    
    @IBOutlet var numberDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "BudgetHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        
        numberDisplayLabel.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.width, height: numberDisplayLabel.frame.size.height)
        view.addSubview(numberDisplayLabel)
        
        budgetViewModel?.addNotification({ (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            print("notification")
            if case .Update = dataChangedType {
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .Automatic)
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }
        })
        
        
    }
    
    func addContentController(content: UIViewController) {
        
        addChildViewController(content)
        content.view.frame = CGRect(x: 0, y: view.frame.height + numberDisplayLabel.frame.size.height, width: view.frame.width, height: view.frame.height*0.4)
        view.addSubview(content.view)
        content.didMoveToParentViewController(self)
        
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            content.view.frame.origin.y = self.view.frame.height - content.view.frame.height - self.tableView.sectionHeaderHeight - self.numberPadOffSetY
            self.numberDisplayLabel.frame.origin.y = self.view.frame.height - content.view.frame.size.height - self.numberDisplayLabel.frame.size.height - self.tableView.sectionHeaderHeight - self.numberPadOffSetY
            }, completion: nil)
        
    }
    
    func removeCotentControllerWidthAnimation(content: UIViewController) {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            content.view.frame.origin.y += content.view.frame.height
            self.numberDisplayLabel.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.width, height: self.numberDisplayLabel.frame.size.height)
            }) { bo in
                content.willMoveToParentViewController(nil)
                content.view.removeFromSuperview()
                content.removeFromParentViewController()
        }
    }
    
    func tapHeaderView(gesture: UITapGestureRecognizer) {
        
        if childViewControllers.count > 0 {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            childViewControllers.forEach {
                removeCotentControllerWidthAnimation($0)
            }
        } else {
            let numberPadViewController = storyboard?.instantiateViewControllerWithIdentifier("NumberPadViewController") as! NumberPadViewController
            numberPadViewController.delegate = self
            addContentController(numberPadViewController)
        }
    }

}


// MARK: - UITableViewDatasource

extension BudgetSubTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let index = parentIndex, number = budgetViewModel?.numberOfChildConsumeptionTypes(parentIndex: index) {
            return number
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BudgetTableViewCell
        cell.data = budgetViewModel?.childConsumeptionTypeAt(indexPath.row, withParentIndex: parentIndex ?? 0)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as! BudgetTableViewHeaderFooterView
        header.data = budgetViewModel?.parentConsumeptionTypeAt(parentIndex: parentIndex ?? 0)
        header.contentView.backgroundColor = UIColor.lightGrayColor()
        
        header.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapHeaderView:")
        header.addGestureRecognizer(tapGesture)
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}


// MARK: - UITableViewDelegate

extension BudgetSubTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if childViewControllers.count > 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            childViewControllers.forEach {
                removeCotentControllerWidthAnimation($0)
            }
        } else {
            let numberPadViewController = storyboard?.instantiateViewControllerWithIdentifier("NumberPadViewController") as! NumberPadViewController
            numberPadViewController.delegate = self
            addContentController(numberPadViewController)
        }
    }
}


// MARK: - ComponentViewControllerDelegate 

extension BudgetSubTableViewController: ComponentViewControllerDelegate {
    
    func valueForLabel(value: String) {
        numberDisplayLabel.text = value
    }
    
    func hideComponetViewController(content: UIViewController) {
        
        removeCotentControllerWidthAnimation(content)
        
        if numberDisplayLabel.text == "0.0" {
            return
        }
        
        if let indexPath = tableView.indexPathForSelectedRow, cell = tableView.cellForRowAtIndexPath(indexPath) as? BudgetTableViewCell { // 更新二级类别预算
            
            if cell.budgetLabel.text == numberDisplayLabel.text {
                return
            }
            
            cell.budgetLabel.text = numberDisplayLabel.text
            if let amountStr = cell.budgetLabel.text, budget = Double(amountStr), pIndex = parentIndex {
                budgetViewModel?.saveChildConsumeptionTypeBudget(budget, atChildIndex: indexPath.row, withParentIndex: pIndex)
            }
        } else { // 更新一级类别预算
            
            let headerView = tableView.headerViewForSection(0) as! BudgetTableViewHeaderFooterView
            
            if headerView.budgetLabel.text == numberDisplayLabel.text {
                return 
            }
            // 这里要对一级预算的值和他的二级预算总和做判断，如果小于后者则提示不能小于。
            if let newBudgetStr = numberDisplayLabel.text,
                   newBudget = Double(newBudgetStr),
                   pIndex = parentIndex,
                   viewModel = budgetViewModel
                where viewModel.parentConsumeptionTypeBudgetIsLessThanChildConsumeptionTypeBudget(newBudget, atParentIndex: pIndex) {
                    let alert = UIAlertHelpler.getAlertController("提示", message: "一级预算不能小于它的二级预算之和", prefferredStyle: .Alert, actions: ("确定", .Default, nil))
                    presentViewController(alert, animated: true, completion: nil)
            } else {
                headerView.budgetLabel.text = numberDisplayLabel.text
                if let amountStr = headerView.budgetLabel.text, budget = Double(amountStr), pIndex = parentIndex {
                    budgetViewModel?.saveParentConsumeptionTypeBudget(budget, atParentIndex: pIndex)
                }
            }
        }
        numberDisplayLabel.text = "0.0"
    }
}
