//
//  BillStreamOptionViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/1.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class BillStreamOptionViewController: UITableViewController {
    
    var billStremViewController: BillStreamTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 125, height: 132)
        }
        
        set {
            super.preferredContentSize = newValue
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 0:
            self.billStremViewController?.loadPreviousYearBills()
        case 1:
            self.billStremViewController?.loadNextYearBills()
        case 2:
            self.billStremViewController?.setBillTableEditable()
        default: break
        }
        dismissViewControllerAnimated(false, completion: nil)
    }
}
