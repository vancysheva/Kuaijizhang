//
//  LabelTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/31.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class LabelTableViewController: UITableViewController {
    
    weak var delegate: ComponentViewControllerDelegate?
    
    var labels = ["label1", "label2", "label3", "label4"]

    @IBAction func cancelLabel(sender: UIButton) {
        if let parentVC = parentViewController as? AddBillViewController {
            parentVC.tagLabel.text = nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == labels.count {
            return tableView.dequeueReusableCellWithIdentifier("addLabelButton", forIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("label", forIndexPath: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = labels[indexPath.row]
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == labels.count {
            return
        }
        
        let value = (tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(1) as! UILabel).text
        if let v = value {
            setValue(v)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func unwindToLabelList(segue: UIStoryboardSegue) {
        
        if let sourceController = segue.sourceViewController as? AddLabelViewController {
            let text = sourceController.labelTextField.text!
            labels.append(text)
            tableView.reloadData()
            
            setValue(text)
            
            delegate?.hideComponetViewController(self)
        }
    }
    
    func setValue(value: String) {
        delegate?.valueForLabel(value)
    }
}
