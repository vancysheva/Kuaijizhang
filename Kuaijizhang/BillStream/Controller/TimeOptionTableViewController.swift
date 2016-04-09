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
    
    let heightForcontainerView = CGFloat(200)
    let animationTimeInterval = 0.25
    
    var selectedText: String?
    var switchOnState = true
    var checkmarkIndexPath: NSIndexPath?
    var tappedButton: UIButton?
    var startDate: String?
    var overDate: String?
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var overDateButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switchButton: UISwitch!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.timeZone = NSTimeZone(abbreviation: "GMT")!
        datePicker.locale = NSLocale.currentLocale()
        initButtonTitle()
        addContainerView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setCellHidden()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setCellPosition()
        
        if switchOnState {
            switchButton.on = switchOnState
            startDateButton.setTitle(startDate, forState: .Normal)
            overDateButton.setTitle(overDate, forState: .Normal)
            `switch`(switchButton)
        }
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
            setButtonTitleWithIndexPath(indexPath)
            switchOnState = false
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
            
            animate({ 
                cell?.transform = CGAffineTransformIdentity
            })
            
            resetButtonColor()
            setSelectedTextFromButtons()
        } else {
            if let ip = checkmarkIndexPath, cell = tableView.cellForRowAtIndexPath(ip) {
                cell.accessoryType = .Checkmark
            } else {
                let firstCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))!
                firstCell.accessoryType = .Checkmark
                selectedText = firstCell.textLabel?.text
            }
            
            animate({ 
                cell?.transform = CGAffineTransformMakeTranslation(0, -cell!.frame.size.height)
            })
            
            hideDatePicker()
        }
    }
    
    @IBAction func tapStartDateButton(sender: UIButton) {
        
        tappedButton = startDateButton
        setButtonColor(colorButton: startDateButton, whiteButton: overDateButton)
        
        showDatePicker()
        setDateWithDateString(startDateButton.titleForState(.Normal)!)
    }
    
    @IBAction func tapOverDateButton(sender: UIButton) {
        
        tappedButton = overDateButton
        setButtonColor(colorButton: overDateButton, whiteButton: startDateButton)
        
        showDatePicker()
        setDateWithDateString(overDateButton.titleForState(.Normal)!)
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        
        let text = DateHelper.getStringFromDate(datePicker.date, dateFormat: DateHelper.dateFormatForDate1)
        tappedButton?.setTitle(text, forState: .Normal)
        setSelectedTextFromButtons()
    }
    
    @IBAction func tapDismissButton(sender: UIButton) {
        hideDatePicker()
    }
    
    private func showDatePicker() {
        
        animate { 
            self.containerView.transform = CGAffineTransformMakeTranslation(0, -self.containerView.bounds.size.height)
        }
    }
    
    private func hideDatePicker() {
        
        animate { 
            self.containerView.transform = CGAffineTransformIdentity
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
    
    private func addContainerView() {
    
        let keyWindow = UIApplication.sharedApplication().keyWindow
        if !keyWindow!.isDescendantOfView(containerView) {
            keyWindow?.addSubview(containerView)
        }
        
        containerView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: heightForcontainerView)
    }
    
    private func removeContainerView() {
        
        let keyWindow = UIApplication.sharedApplication().keyWindow!
        if keyWindow.isDescendantOfView(containerView) {
            containerView.removeFromSuperview()
        }
    }
    
    private func setCellPosition() {
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))!
        cell.transform = CGAffineTransformMakeTranslation(0, -cell.frame.size.height)
        cell.hidden = false
    }
    
    private func setCellHidden() {
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0))!
        cell.hidden = true
    }
    
    private func initButtonTitle() {
    
        let startDate = DateHelper.getStringFromDate(DateHelper.getStartTimeFromCurrentYear(), dateFormat: DateHelper.dateFormatForDate1)
        let overDate = DateHelper.getStringFromDate(DateHelper.getOverTimeFromCurrentYear(), dateFormat: DateHelper.dateFormatForDate1)
        setButtonTitle(startButtonTitle: startDate, overButtonTitle: overDate)
    }
    
    private func setButtonTitle(startButtonTitle s1: String, overButtonTitle s2: String) {
        
        startDateButton.setTitle(s1, forState: .Normal)
        overDateButton.setTitle(s2, forState: .Normal)
    }
    
    private func setButtonTitleWithIndexPath(indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 1:
            startDate = DateHelper.getStringFromDate(NSDate(), dateFormat: DateHelper.dateFormatForDate1)
            overDate = startDate
        case 2:
            startDate = DateHelper.getStringFromDate(DateHelper.getStartTimeFromCurrentWeek(), dateFormat: DateHelper.dateFormatForDate1)
            overDate = DateHelper.getStringFromDate(DateHelper.getOverTimeFromCurrentWeek(), dateFormat: DateHelper.dateFormatForDate1)
        case 3:
            startDate = DateHelper.getStringFromDate(DateHelper.getStartTimeFromCurrentMonth(), dateFormat: DateHelper.dateFormatForDate1)
            overDate = DateHelper.getStringFromDate(DateHelper.getOverTimeFromCurrentMonth(), dateFormat: DateHelper.dateFormatForDate1)
        case 4: fallthrough
        default:
            startDate = DateHelper.getStringFromDate(DateHelper.getStartTimeFromCurrentYear(), dateFormat: DateHelper.dateFormatForDate1)
            overDate = DateHelper.getStringFromDate(DateHelper.getOverTimeFromCurrentYear(), dateFormat: DateHelper.dateFormatForDate1)
            break
        }
        
        setButtonTitle(startButtonTitle: startDate!, overButtonTitle: overDate!)
    }
    
    private func setDateWithDateString(date: String) {
        
        if let text = DateHelper.dateFromString(date, formatter: DateHelper.dateFormatForDate1) {
            datePicker.date = text
        }
    }
    
    private func scrollTableUpward() {
        tableView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    private func scrollTableDownward() {
    
    }
    
    private func setSelectedTextFromButtons() {
        
        var hasCheckmark = false
        loopTableView { cell in
            hasCheckmark = (cell.accessoryType == .Checkmark)
        }
        
        if !hasCheckmark {
            selectedText = "\(startDateButton.titleForState(.Normal)!)-\(overDateButton.titleForState(.Normal)!)"
        } else {
            selectedText = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))?.textLabel?.text
        }
        
        if let vc = navigationController?.viewControllers[(navigationController?.viewControllers.count)!-2] as? BillStreamAdvancedSearchTableViewController, ip = vc.tableView.indexPathForSelectedRow {
            vc.tableView.cellForRowAtIndexPath(ip)?.detailTextLabel?.text = selectedText
        }
    }
    
    private func animate(animationHandler: () -> Void) {
        
        UIView.animateWithDuration(animationTimeInterval) { 
            animationHandler()
        }
    }
    
}
