//
//  SubjectTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/1.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import SWTableViewCell


class SubjectTableViewController: UITableViewController {
    
    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    let subjectViewModel = LabelTableViewModel()
    let swipeCellAgent = TableViewCellSlideAgent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        subjectViewModel.addNotification { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            switch dataChangedType {
            case .Insert:
                self.navigationController?.popToViewController(self, animated: true)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.updateUI()
            case .Update:
                self.navigationController?.popToViewController(self, animated: true)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            default:
                break
            }
        }
        
        swipeCellAgent.addTriggerRightUtilityButtonHandler { (cell, didTriggerRightUtilityButtonWithIndex) -> Void in
            
            let indexPath = self.tableView.indexPathForCell(cell)
            switch didTriggerRightUtilityButtonWithIndex {
            case 0:
                if let addVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddLabelViewController") as? AddLabelViewController{
                    addVC.labelTableViewModel = self.subjectViewModel
                    addVC.indexPathForUpdate = indexPath
                    self.navigationController?.pushViewController(addVC, animated: true)
                    cell.hideUtilityButtonsAnimated(true)
                }
            case 1:
                if let ip = indexPath {
                    self.subjectViewModel.deleteObject(ip)
                }
            default:
                break
            }
        }
        
        swipeCellAgent.addSwipeableTableViewCellShouldHideUtilityButtonsOnSwipe { (cell) -> Bool in
            return true
        }
    }
    
    
    
    @IBAction func tapAddSubjectButton(sender: UIBarButtonItem) {
        
        if let addVC = storyboard?.instantiateViewControllerWithIdentifier("AddLabelViewController") as? AddLabelViewController{
            addVC.labelTableViewModel = subjectViewModel
            navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    
    
    @IBAction func tapEditSubjectButton(sender: UIBarButtonItem) {
        
        if !tableView.editing {
            sender.title = "完成"
            tableView.setEditing(true, animated: true)
        } else {
            sender.title = "编辑"
            tableView.setEditing(false, animated: true)
        }
    }
    
    
    
    func updateUI() {
        
        let allIncome = subjectViewModel.allIncome()
        let allExpense = subjectViewModel.allExpense()
        surplusLabel.text = "\(allIncome - allExpense)"
        incomeLabel.text = "\(allIncome)"
        expenseLabel.text = "\(allExpense)"
    }
}




// MARK: - UITableViewDataSource

extension SubjectTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(subjectViewModel.getCount())
        return subjectViewModel.getCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SWTableViewCell
        let tuple = subjectViewModel.objectAt(indexPath)
        cell.textLabel?.text = tuple.labelName
        cell.detailTextLabel?.text = "\(tuple.amount!)"
        
        let rightButtons = NSMutableArray()
        rightButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "编辑")
        rightButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "删除")
        cell.rightUtilityButtons = rightButtons as [AnyObject]
        cell.delegate = swipeCellAgent
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        subjectViewModel.moveObjectFromIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

// MARK: - UITableViewDelegate

extension SubjectTableViewController {
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}
