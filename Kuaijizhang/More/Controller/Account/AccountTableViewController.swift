//
//  AccountTabelViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/24.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import SWTableViewCell

class AccountTableViewController: UITableViewController {

    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    @IBOutlet weak var addAccountBarItem: UIBarButtonItem!
    
    var swipeCellAgent = TableViewCellSlideAgent()
    
    var accountViewModel: AccountViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "AccountHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "accountHeader")
        
        updateUI()
        
        accountViewModel?.addNotification("AccountTableViewController") { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            switch dataChangedType {
            case .Insert:
                self.navigationController?.popToViewController(self, animated: true)
                if let info = userInfo?["type"] as? String where info == "insertChild" {
                    self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                } else {
                    self.tableView.insertSections(NSIndexSet(index: indexPath.row), withRowAnimation: .Automatic)
                }
            case .Delete:
                if let lastOneDelete = userInfo?["lastOneDelete"] as? Bool where lastOneDelete == true {
                    self.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                } else {
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            case .Update:
                self.navigationController?.popToViewController(self, animated: true)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.updateUI()
            default:
                break
            }
        }
        
        swipeCellAgent.addTriggerRightUtilityButtonHandler { [unowned self] (cell, didTriggerRightUtilityButtonWithIndex) -> Void in
            
            let indexPath = self.tableView.indexPathForCell(cell)
            switch didTriggerRightUtilityButtonWithIndex {
            case 0:
                if let addVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddAccountTableViewController") as? AddAccountTableViewController {
                    addVC.accountViewModel = self.accountViewModel
                    addVC.indexPathForUpdate = indexPath
                    self.navigationController?.pushViewController(addVC, animated: true)
                    cell.hideUtilityButtonsAnimated(true)
                }
            case 1:
                if let ip = indexPath {
                    self.accountViewModel?.deleteAccountAtParentIndex(ip.section, withChildIndex: ip.row)
                }
            default:
                break
            }
        }
        
        swipeCellAgent.addSwipeableTableViewCellShouldHideUtilityButtonsOnSwipe { (cell) -> Bool in
            return true
        }
        
    }
    
    @IBAction func tapEditAccountButton(sender: UIBarButtonItem) {
        if !tableView.editing {
            sender.title = "完成"
            addAccountBarItem.enabled = false
            tableView.setEditing(true, animated: true)
        } else {
            sender.title = "编辑"
            addAccountBarItem.enabled = true
            tableView.setEditing(false, animated: true)
        }
    }
    
    @IBAction func unWindToAccountList(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let accountTypeTable = segue.destinationViewController as? AccountTypeTableViewController {
            accountTypeTable.accountViewModel = accountViewModel
        }
    }
    
    func updateUI() {
        
        let allIncome = accountViewModel?.allIncome() ?? 0
        let allExpense = accountViewModel?.allExpense() ?? 0
        surplusLabel.text = "\(allIncome - allExpense)"
        incomeLabel.text = "\(allIncome)"
        expenseLabel.text = "\(allExpense)"
    }

}


// MARK: - UITableViewControllerDatasource

extension AccountTableViewController {
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return accountViewModel?.numberOfParentAccounts() ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel?.numberOfChildAccountsAtParentIndex(section) ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SWTableViewCell
        
        if let tuple = accountViewModel?.childAccountAtParentIndex(indexPath.section, withChildIndex: indexPath.row) {
            cell.textLabel?.text = tuple.childName
            cell.detailTextLabel?.text = "\(tuple.childAmount)"
            
            let rightButtons = NSMutableArray()
            rightButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "编辑")
            rightButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "删除")
            cell.rightUtilityButtons = rightButtons as [AnyObject]
            cell.delegate = swipeCellAgent
        }

        return cell
    }
}

// MARK: - UITableViewControllerDelegate

extension AccountTableViewController {
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("accountHeader") as! AccountHeaderView
        headerView.data = accountViewModel?.parentAccountWithAmountAt(section)
        return headerView
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        accountViewModel?.moveObjectFromIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = tableView.numberOfRowsInSection(sourceIndexPath.section) - 1
            }
            return NSIndexPath(forRow: row, inSection: sourceIndexPath.section)
        }
        return  proposedDestinationIndexPath
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        accountViewModel?.model.sendObserverFeedBack(indexPath)
    }
}