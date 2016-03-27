//
//  BillStreamAdvancedSearchTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/26.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class BillStreamAdvancedSearchTableViewController: UITableViewController {

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
    }
    
    // MARK: - Method
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier {
        case .Some("toTimeOptionSegue"):
            if let vc = segue.destinationViewController as? TimeOptionTableViewController, ip = tableView.indexPathForSelectedRow, text = tableView.cellForRowAtIndexPath(ip)?.detailTextLabel?.text {
                vc.selectedText = text
            }
        default:
            break
        }
    }
    
    @IBAction func unwindToBillstreamAdvancedSearch(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier {
        case .Some("unwindToBillstreamAdvancedSearchSegue"):
            if let ip = tableView.indexPathForSelectedRow, vc = segue.sourceViewController as? TimeOptionTableViewController, selectedText = vc.selectedText {
                tableView.cellForRowAtIndexPath(ip)?.detailTextLabel?.text = selectedText
            }
        default:
            break
        }
    }

    @IBAction func tapCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Data source and delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsetsZero
    }
}
