//
//  AccountBookViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AccountBookViewController: UIViewController {
    
    var accountBookViewModel = AccountBookViewModel()
    
    var currentAccountBook: String?
    
    // MARK: - IBOutlet and IBAction

    @IBAction func tapDone(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var accountTableView: UITableView!
        
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.tableFooterView = UIView()
        accountTableView.tableHeaderView = UIView()
        
        setAccountBookIsUsing()
    }

}

// MARK: - Internal method

extension AccountBookViewController {
    
    func confirmDelete(indexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "提示", message: "确定要删除该账本吗？", preferredStyle: .Alert)
        let sure = UIAlertAction(title: "确定", style: .Default) { action in
            self.accountBookViewModel.data.removeAtIndex(indexPath.row)
            self.accountTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        let cancel = UIAlertAction(title: "取消", style: .Cancel) { action in
            print("cancel button tapped")
        }
        alert.addAction(sure)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func setAccountBookIsUsing() {
        if let cell = accountTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) {
            cell.accessoryType = .Checkmark
            (cell.viewWithTag(3) as! UILabel).hidden = false
        }
    }
}

// MARK: - Delegate and Datasource
extension AccountBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = accountTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: "")
        
        let label = cell.viewWithTag(2) as! UILabel
        label.text = accountBookViewModel.data[indexPath.row]
        
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
            accountTableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            currentAccountBook = accountBookViewModel.data[indexPath.row]
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountBookViewModel.data.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}

