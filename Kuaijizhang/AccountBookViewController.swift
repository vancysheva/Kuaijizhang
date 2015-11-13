//
//  AccountBookViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AccountBookViewController: UIViewController {
    
    // MARK: - Properties
    
    let accountBookViewModel = AccountBookViewModel()
    
    @IBOutlet weak var accountTableView: UITableView!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.tableFooterView = UIView()
        
        accountBookViewModel.addObserver { [unowned self] (dataChangedType, indexPath) -> Void in
            if dataChangedType == .Delete {
                self.accountTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            } else if dataChangedType == .Insert {
                self.accountTableView.reloadData()
            }
        }

    }
    
    
    
    // MARK: - Methods

    @IBAction func tapDone(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
        if let sourceVC = segue.sourceViewController as? AddAccountBookViewController, coverImageName = sourceVC.coverImageName, title = sourceVC.nameTextField.text {
            accountBookViewModel.saveAccountBookWithTitle(title, coverImageName: coverImageName)
        }
    }
    
    func confirmDelete(indexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "提示", message: "确定要删除该账本吗？", preferredStyle: .Alert)
        let sure = UIAlertAction(title: "确定", style: .Default) {  [unowned self] action in
            if let isUsing = self.accountBookViewModel.objectAt(indexPath).1 where isUsing == true {
                let messageAlert = UIAlertController(title: "", message: "删除失败，不能删除正在使用的账本。", preferredStyle: .Alert)
                messageAlert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                self.presentViewController(messageAlert, animated: true, completion: nil)
            } else {
                self.accountBookViewModel.delete(indexPath)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alert.addAction(sure)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }

}

// MARK: - Delegate and Datasource
extension AccountBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountBookViewModel.getCount()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = accountTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let titleLabel = cell.viewWithTag(2) as! UILabel
        let isUsingLabel = cell.viewWithTag(3) as! UILabel
        
        var name: String?
        var b: Bool?
        (titleLabel.text, b, name) = accountBookViewModel.objectAt(indexPath)
        imageView.image = UIImage(named: name ?? "")
        isUsingLabel.hidden = b == nil ? false : !(b!)
        cell.accessoryType = isUsingLabel.hidden == false ? .Checkmark : .None
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
            
            accountBookViewModel.setCurrentUsingAt(indexPath)
        }
    }
}

