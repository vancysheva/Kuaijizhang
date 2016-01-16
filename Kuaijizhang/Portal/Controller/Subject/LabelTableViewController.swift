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
        
        labelTableViewModel.addNotification { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            if case .Insert = dataChangedType {
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                self.tableView.reloadData()
                if let subject = self.labelTableViewModel.model.objectAtIndex(indexPath.row) {
                    self.setValue(subject)
                }
                self.delegate?.hideComponetViewController(self)

            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AddLabelViewController where segue.identifier == "addLabelIdentifier" {
            vc.labelTableViewModel = labelTableViewModel
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
        label.text = labelTableViewModel.objectAt(indexPath).labelName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == labelTableViewModel.getCount() {
            return
        }
        
        if let subject = labelTableViewModel.model.objectAtIndex(indexPath.row) {
            setValue(subject)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
   
    
    func setValue(subject: Subject) {
        delegate?.valueForLabel(subject.name)
        
        if let pcontroller = parentViewController as? AddBillViewController {
            pcontroller.addBillViewModel.subject = subject
        }
    }
}
