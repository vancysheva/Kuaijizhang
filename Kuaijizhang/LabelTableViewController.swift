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
    
    var labelTableViewModel = LabelTableViewModel()

    @IBAction func cancelLabel(sender: UIButton) {
        if let parentVC = parentViewController as? AddBillViewController {
            parentVC.tagLabel.text = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTableViewModel.addNotification { (transactionState, dataChangedType, indexPath) -> Void in
            if dataChangedType == .Insert {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AddLabelViewController where segue.identifier == "addLabelIdentifier" {
            vc.labelTabelViewModel = labelTableViewModel
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelTableViewModel.getCount() + 1 // 预留给添加标签按钮
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == labelTableViewModel.getCount() {
            return tableView.dequeueReusableCellWithIdentifier("addLabelButton", forIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("label", forIndexPath: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = labelTableViewModel.objectAt(indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == labelTableViewModel.getCount() {
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
            
            labelTableViewModel.saveObject(text)
            setValue(text)
            
            delegate?.hideComponetViewController(self)
        }
    }
    
    func setValue(value: String) {
        delegate?.valueForLabel(value)
    }
}
