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

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel?.getParentAccountCount() ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = accountViewModel?.parentAccountAt(indexPath.row)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AddAccountTableViewController, touchCell = sender as? UITableViewCell {
            vc.accountViewModel = accountViewModel
            vc.parentAccountIndex = tableView.indexPathForCell(touchCell)?.row
        }
    }
}
