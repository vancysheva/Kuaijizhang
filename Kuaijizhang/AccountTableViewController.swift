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

    @IBOutlet weak var netAssetLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var liabilityLabel: UILabel!
    
    var accountViewModel: AccountViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "AccountHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "accountHeader")
        
        accountViewModel?.addNotification({ (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
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
        })
        
    }
    
    @IBAction func tapEditAccountButton(sender: UIBarButtonItem) {
        if !tableView.editing {
            sender.title = "完成"
            tableView.setEditing(true, animated: true)
        } else {
            sender.title = "编辑"
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
            cell.detailTextLabel?.text = "\(tuple.childAmount!)"
            
            let rightButtons = NSMutableArray()
            rightButtons.sw_addUtilityButtonWithColor(UIColor.blueColor(), title: "编辑")
            rightButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: "删除")
            cell.rightUtilityButtons = rightButtons as [AnyObject]
            cell.delegate = self
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
        accountViewModel?.moveoObjectFromIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}

// MARK: - SWTableViewCellDelegate

extension AccountTableViewController: SWTableViewCellDelegate {
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        
        let indexPath = tableView.indexPathForCell(cell)
        switch index {
        case 0:
            if let addVC = storyboard?.instantiateViewControllerWithIdentifier("AddAccountTableViewController") as? AddAccountTableViewController {
                addVC.accountViewModel = accountViewModel
                addVC.indexPathForUpdate = indexPath
                navigationController?.pushViewController(addVC, animated: true)
            }
        case 1:
            if let ip = indexPath {
                accountViewModel?.deleteAccountAtParentIndex(ip.section, withChildIndex: ip.row)
            }
        default:
            break
        }
    }

}
