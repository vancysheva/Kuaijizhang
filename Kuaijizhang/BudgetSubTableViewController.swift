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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "BudgetHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        
    }
    
    func addContentController(content: UIViewController) {
        
        addChildViewController(content)
        content.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height*0.4)
        view.addSubview(content.view)
        content.didMoveToParentViewController(self)
        
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            content.view.frame.origin.y = self.view.frame.height - content.view.frame.height - self.tableView.sectionHeaderHeight - self.numberPadOffSetY
            }, completion: nil)
        
    }
    
    func removeCotentControllerWidthAnimation(content: UIViewController) {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            content.view.frame.origin.y += content.view.frame.height
            }) { bo in
                content.willMoveToParentViewController(nil)
                content.view.removeFromSuperview()
                content.removeFromParentViewController()
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
        if let indexPath = tableView.indexPathForSelectedRow, cell = tableView.cellForRowAtIndexPath(indexPath) as? BudgetTableViewCell {
            cell.budgetLabel.text = value
        }
    }
    
    func hideComponetViewController(content: UIViewController) {
        removeCotentControllerWidthAnimation(content)
    }
}
