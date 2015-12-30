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

    var types: [(String, String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        types = accountViewModel?.readParentAccount()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AddAccountTableViewController, touchCell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(touchCell) {
            vc.accountViewModel = accountViewModel
            vc.parentAccount = types?[indexPath.row]
        }
    }

    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = types?[indexPath.row].1
        cell.imageView?.image = UIImage(named: types?[indexPath.row].0 ?? "")
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "选择一个账户类型。"
    }
}
