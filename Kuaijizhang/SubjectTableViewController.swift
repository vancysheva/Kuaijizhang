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
    
    let subjectViewModel = LabelTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectViewModel.addNotification { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            switch dataChangedType {
            case .Insert:
                self.navigationController?.popToViewController(self, animated: true)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Update:
                self.navigationController?.popToViewController(self, animated: true)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            default:
                break
            }
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
}




// MARK: - UITableViewDataSource

extension SubjectTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        subjectViewModel.moveoObjectFromIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

// MARK: - UITableViewDelegate

extension SubjectTableViewController {
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}


// MARK: - SWTableViewCellDelegate

extension SubjectTableViewController: SWTableViewCellDelegate {
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
        let indexPath = tableView.indexPathForCell(cell)
        switch index {
        case 0:
            if let addVC = storyboard?.instantiateViewControllerWithIdentifier("AddLabelViewController") as? AddLabelViewController{
                addVC.labelTableViewModel = subjectViewModel
                addVC.indexPathForUpdate = indexPath
                navigationController?.pushViewController(addVC, animated: true)
            }
        case 1:
            if let ip = indexPath {
                subjectViewModel.deleteObject(ip)
            }
        default:
            break
        }
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
}
