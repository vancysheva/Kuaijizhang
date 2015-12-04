//
//  TestTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {

    @IBOutlet var billTableView: UITableView!
    var billStreamViewModel = BillStreamViewModel()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return billStreamViewModel.data.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = billStreamViewModel.data[section] {
            return arr.count
        }
       return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = billTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let day = cell.viewWithTag(1) as! UILabel
        let consumeName = cell.viewWithTag(2) as! UILabel
        let comment = cell.viewWithTag(3) as! UILabel
        let money = cell.viewWithTag(4) as! UILabel
        
        let t = billStreamViewModel.data[indexPath.section]![indexPath.row]
        day.text = "\(t.date)"
        consumeName.text = t.consumeName
        comment.text = t.comment
        money.text = "\(t.money)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let nibs = NSBundle.mainBundle().loadNibNamed("BillStreamHeaderView", owner: self, options: nil)
        
        let headerView =  nibs[0] as! BillStreamHeaderView
        return headerView
    }

}
