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
        
        tableView.registerNib(UINib(nibName: "AccountHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "accountHeader")
        
        tableView.tableFooterView = UIView()
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
        return accountViewModel?.getParentAccountCount() ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountViewModel?.getChildAccountCount(section) ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let tuple = accountViewModel?.objectAt(indexPath) {
            cell.textLabel?.text = tuple.0
            cell.detailTextLabel?.text = "\(tuple.1)"
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
        headerView.data = accountViewModel?.parentAccountWidthAmountAt(section)
        
        return headerView
    }
}
