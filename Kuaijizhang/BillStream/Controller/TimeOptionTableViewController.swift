//
//  TimeOptionTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/26.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class TimeOptionTableViewController: UITableViewController {
    
    // MARK: - Property
    
    let heightForcontainerView = CGFloat(205)
    
    var selectedText: String?
    var checkmarkIndexPath: NSIndexPath?
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var overDateButton: UIButton!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        
        containerView.frame = CGRect(x: 0, y: view.bounds.size.height, width: view.bounds.width, height: heightForcontainerView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))!
        cell.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))!
        cell.transform = CGAffineTransformMakeTranslation(0, -cell.frame.size.height)
        cell.hidden = false
    }
    
    // MARK: - Data source and delegate
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.layoutMargins = UIEdgeInsetsZero
        
        if cell.textLabel?.text == selectedText {
            cell.accessoryType = .Checkmark
            checkmarkIndexPath = indexPath
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row > 5 {
            return
        }
        
        loopTableView { cell in
            cell.accessoryType = .None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        if indexPath.row < 6 {
            selectedText = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
            performSegueWithIdentifier("unwindToBillstreamAdvancedSearchSegue", sender: cell?.textLabel?.text)
        }
    }
    
    // MARK: - Method

    @IBAction func `switch`(sender: UISwitch) {
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))
        if sender.on {
            loopTableView({ cell in
                if cell.accessoryType == .Checkmark {
                    cell.accessoryType = .None
                }
            })
            
            UIView.animateWithDuration(0.25, animations: {
                cell?.transform = CGAffineTransformIdentity
            })
            
            resetButtonColor()
        } else {
            if let ip = checkmarkIndexPath, cell = tableView.cellForRowAtIndexPath(ip) {
                cell.accessoryType = .Checkmark
            }
        
            UIView.animateWithDuration(0.25, animations: {
                cell?.transform = CGAffineTransformMakeTranslation(0, -cell!.frame.size.height)
            })
        }
    }
    
    @IBAction func tapStartDateButton(sender: UIButton) {
        
        setButtonColor(colorButton: startDateButton, whiteButton: overDateButton)
        showDatePicker()
    }
    
    @IBAction func tapOverDateButton(sender: UIButton) {
        
        setButtonColor(colorButton: overDateButton, whiteButton: startDateButton)
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        
    }
    
    @IBAction func tapDismissButton(sender: UIButton) {
        
    }
    
    private func showDatePicker() {
        print(containerView.frame)
        UIView.animateWithDuration(0.5) { 
            self.containerView.transform = CGAffineTransformMakeTranslation(0, 0)
        }
    }
    
    private func loopTableView(handler: (cell: UITableViewCell) -> Void) {
        
        for row in 0..<6 {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) {
                handler(cell: cell)
            }
        }
    }
    
    private func setButtonColor(colorButton btn1: UIButton, whiteButton btn2: UIButton) {
    
        btn1.backgroundColor = UIColor.lightGrayColor()
        btn2.backgroundColor = UIColor.whiteColor()
    }
    
    private func resetButtonColor() {
    
        startDateButton.backgroundColor = UIColor.whiteColor()
        overDateButton.backgroundColor = UIColor.whiteColor()
    }
}
