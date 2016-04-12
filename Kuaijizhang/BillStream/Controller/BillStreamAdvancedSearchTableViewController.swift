//
//  BillStreamAdvancedSearchTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/26.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class BillStreamAdvancedSearchTableViewController: UITableViewController {

    
    // MARK: - Property
    
    var startDate = DateHelper.getStartTimeFromCurrentYear()
    var overDate = DateHelper.getOverTimeFromCurrentYear()
    let textAgent = TextFieldAgent()
    @IBOutlet weak var commentTextField: UITextField!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = textAgent
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
    }
    
    // MARK: - Method
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destTitle: String?
        
        switch segue.identifier {
        case .Some("toTimeOptionSegue"):
            if let vc = segue.destinationViewController as? TimeOptionTableViewController, ip = tableView.indexPathForSelectedRow, text = tableView.cellForRowAtIndexPath(ip)?.detailTextLabel?.text {
                vc.selectedText = text
                vc.startDate = DateHelper.getStringFromDate(startDate, dateFormat: DateHelper.dateFormatForDate1)
                vc.overDate = DateHelper.getStringFromDate(overDate, dateFormat: DateHelper.dateFormatForDate1)
            }
        case .Some("consumeptionTypeToTimeOptionSegue"):
            destTitle = "类别筛选"
            initViewController(segue, title: destTitle)
        case .Some("accountToTimeOptionSegue"):
            destTitle = "账户筛选"
            initViewController(segue, title: destTitle)
        case .Some("labelToTimeOptionSegue"):
            destTitle = "标签筛选"
            initViewController(segue, title: destTitle)
        default:
            break
        }
    }
    
    @IBAction func unwindToBillstreamAdvancedSearch(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier {
        case .Some("unwindToBillstreamAdvancedSearchSegue"):
            if let ip = tableView.indexPathForSelectedRow, vc = segue.sourceViewController as? TimeOptionTableViewController, selectedText = vc.selectedText, sd = vc.startDate, od = vc.overDate, sdd = DateHelper.dateFromString(sd, formatter: DateHelper.dateFormatForDate1), odd = DateHelper.dateFromString(od, formatter: DateHelper.dateFormatForDate1) {
                tableView.cellForRowAtIndexPath(ip)?.detailTextLabel?.text = selectedText
                startDate = sdd
                overDate = odd
            }
        default:
            break
        }
    }

    @IBAction func tapCancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func initViewController(segue: UIStoryboardSegue, title: String?) {
        
        if let vc = segue.destinationViewController as? OtherOptionTableViewController {
            vc.title = title
            
        }
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