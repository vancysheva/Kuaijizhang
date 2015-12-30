//
//  AccountTypeTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/26.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AccountTypeTableViewController: UITableViewController {
    
    var accountViewModel: AccountViewModel?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AddAccountTableViewController, touchCell = sender as? UITableViewCell {
            vc.accountViewModel = accountViewModel
            vc.parentAccountIndex = tableView.indexPathForCell(touchCell)?.row
        }
    }

    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel?.numberOfParentAccounts() ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let (name, _, iconName) = accountViewModel?.parentAccountWithAmountAt(indexPath.row), icon = iconName {
            cell.textLabel?.text = name
            cell.imageView?.image = UIImage(named: icon)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "选择一个账户类型。"
    }
}
