//
//  AccountTabelViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/24.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    @IBOutlet weak var netAssetLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var liabilityLabel: UILabel!
    
    var accountViewModel: AccountViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "AccountHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "accountHeader")
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            //accountViewModel
            print("")
        case .Insert:
            print("")
        default:
            break
        }
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return accountViewModel?.numberOfParentAccounts() ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel?.numberOfChildAccountsAtParentIndex(section) ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let tuple = accountViewModel?.childAccountAtParentIndex(indexPath.section, withChildIndex: indexPath.row) {
            cell.textLabel?.text = tuple.childName
            cell.detailTextLabel?.text = "\(tuple.childAmount!)"
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
}
