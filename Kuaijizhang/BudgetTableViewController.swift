//
//  BudgetTableViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/6.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BudgetTableViewController: UITableViewController {

    @IBOutlet weak var budgetMonthLabel: UILabel!
    @IBOutlet weak var budgetUsedLabel: UILabel!
    @IBOutlet weak var budgetAvailabelLabel: UILabel!
    
    let budgetViewModel = BudgetViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? BudgetSubTableViewController {
            vc.budgetViewModel = budgetViewModel
            vc.parentIndex = tableView.indexPathForCell(sender as! UITableViewCell)?.row ?? 0
        }
    }
}

// MARK: - UITableViewControllerDatasource

extension BudgetTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetViewModel.getParentConsumeptionTypeCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BudgetTableViewCell
        cell.data = budgetViewModel.parentConsumeptionTypeAt(parentIndex: indexPath.row)
        return cell
    }
}
