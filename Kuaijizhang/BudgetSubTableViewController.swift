//
//  BudgetSubTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/6.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BudgetSubTableViewController: UITableViewController {
    
    var budgetViewModel: BudgetViewModel?
    var parentIndex: Int?
    var numberPadViewController: NumberPadViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "BudgetHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? NumberPadViewController where segue.identifier == "showNumberPad"{
            numberPadViewController = vc
            numberPadViewController?.delegate = self
            
            
            numberPadViewController!.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height*0.4)
            view.addSubview(numberPadViewController!.view)
        }
    }
}


// MARK: - UITableViewDatasource

extension BudgetSubTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let index = parentIndex, number = budgetViewModel?.getChildConsumeptionTypeCount(parentIndex: index) {
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
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}


// MARK: - UITableViewDelegate

extension BudgetSubTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.numberPadViewController!.view.frame.origin.y = self.view.frame.height - self.numberPadViewController!.view.frame.height
            }, completion: nil)
    }
}


// MARK: - ComponentViewControllerDelegate 

extension BudgetSubTableViewController: ComponentViewControllerDelegate {
    
    func valueForLabel(value: String) {
        if let indexPath = tableView.indexPathForSelectedRow, cell = tableView.cellForRowAtIndexPath(indexPath) as? BudgetTableViewCell {
            cell.budgetLabel.text = value
        }
    }
    
    func hideComponetViewController(content: UIViewController) {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            content.view.frame.origin.y += content.view.frame.height
            }) { bo in
                self.numberPadViewController?.view.removeFromSuperview()
        }
    }
}
