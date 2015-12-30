//
//  BudgetTableViewCell.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/2.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {

    @IBOutlet weak var consumeImageView: UIImageView!
    @IBOutlet weak var consumeNameLabel: UILabel!
    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var budgetProgress: UIProgressView!
    
    var data: (iconName: String, name: String, budget: Double, surplus: Double)? {
        didSet {
            if let d = data {
                consumeImageView.image = UIImage(named: d.iconName ?? "")
                consumeNameLabel.text = d.name
                surplusLabel.text = "\(d.surplus)"
                budgetLabel.text = "\(d.budget)"
                if d.budget == 0 {
                    budgetProgress.progress = 0
                } else {
                    budgetProgress.progress = Float(d.surplus / d.budget)
                }
                
            }
        }
    }
}
