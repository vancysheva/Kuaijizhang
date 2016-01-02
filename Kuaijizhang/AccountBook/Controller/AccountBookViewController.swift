//
//  AccountBookViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import SWTableViewCell

class AccountBookViewController: UIViewController {
    
    // MARK: - Properties
    
    let accountBookViewModel = AccountBookViewModel()
    let swipeCellAgent = TableViewCellSlideAgent()
    
    @IBOutlet weak var accountTableView: UITableView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.tableFooterView = UIView()

        accountBookViewModel.addNotification { [unowned self] (transactionState: TransactionState, dataChangedType: ModelDataChangedType, indexPath: NSIndexPath, _) -> Void in
            
            switch dataChangedType {
            case .Insert:
                self.navigationController?.popToViewController(self, animated: true)
                self.accountTableView.reloadData()
            case .Update:
                self.navigationController?.popToViewController(self, animated: true)
                self.accountTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Delete:
                self.accountTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            default: break
            }
        }
        
        swipeCellAgent.addTriggerRightUtilityButtonHandler { [unowned self] (cell, didTriggerRightUtilityButtonWithIndex) -> Void in
            
            if let indexPath = self.accountTableView.indexPathForCell(cell) {
                switch didTriggerRightUtilityButtonWithIndex {
                case 0:
                    if let addVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddAccountBookViewController") as? AddAccountBookViewController {
                        addVC.indexPathForUpdate = indexPath
                        addVC.accountBookViewModel = self.accountBookViewModel
                        self.navigationController?.pushViewController(addVC, animated: true)
                        cell.hideUtilityButtonsAnimated(true)
                    }
                case 1:
                    self.accountBookViewModel.delete(indexPath)
                default:
                    break
                }
            }
        }
        
        swipeCellAgent.addSwipeableTableViewCellShouldHideUtilityButtonsOnSwipe { (cell) -> Bool in
            return true
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AddAccountBookViewController {
            vc.accountBookViewModel = accountBookViewModel
        }
    }
    
    
    // MARK: - Methods

    @IBAction func tapDone(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func confirmDelete(indexPath indexPath: NSIndexPath) {
    
        let alert = UIAlertHelpler.getAlertController("提示", message: "确定要删除该账本吗？", prefferredStyle: .Alert, actions: ("确定", .Default, {[unowned self] action in
            
                if self.accountBookViewModel.objectAt(indexPath).1  == true {
                    let messageAlert = UIAlertHelpler.getAlertController("", message: "删除失败，不能删除正在使用的账本。", prefferredStyle: .Alert, actions: ("取消", .Cancel, nil))
                    
                    self.presentViewController(messageAlert, animated: true, completion: nil)
                } else {
                    self.accountBookViewModel.delete(indexPath)
                }
            
            }), ("取消", .Cancel, nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDataSource
extension AccountBookViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountBookViewModel.getCount()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = accountTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SWTableViewCell
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let titleLabel = cell.viewWithTag(2) as! UILabel
        let isUsingLabel = cell.viewWithTag(3) as! UILabel
        
        
        let data = accountBookViewModel.objectAt(indexPath)
        imageView.image = UIImage(named: data.coverImageName)
        titleLabel.text = data.title
        isUsingLabel.hidden = !data.isUsing
        cell.accessoryType = data.isUsing == true ? .Checkmark : .None
        
        let rightButtons = NSMutableArray()
        rightButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "编辑")
        rightButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "删除")
        cell.rightUtilityButtons = rightButtons as [AnyObject]
        cell.delegate = swipeCellAgent
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            confirmDelete(indexPath: indexPath)
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate

extension AccountBookViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = accountTableView.cellForRowAtIndexPath(indexPath) where cell.accessoryType == .Checkmark {
            accountTableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        let count = accountTableView.numberOfRowsInSection(0)
        for row in 0..<count {
            if let cell = accountTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) where cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                (cell.viewWithTag(3) as! UILabel).hidden = true
            }
        }
        
        if let cell = accountTableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .Checkmark
            (cell.viewWithTag(3) as! UILabel).hidden = false
            
            accountBookViewModel.setCurrentUsingAt(indexPath)
        }
    }
}

