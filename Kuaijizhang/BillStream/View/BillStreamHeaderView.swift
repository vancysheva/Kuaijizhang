//
//  BillStreamHeaderView.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BillStreamHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var consumeLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    var data: (month: Int, inconme: Double, expense: Double, surplus: Double)? {
        didSet {
            if let d = data {
                if d.expense != 0 {
                    consumeLabel.text = "\(d.expense)"
                }
                if d.inconme != 0 {
                    incomeLabel.text = "\(d.inconme)"
                }
                surplusLabel.text = "\(d.surplus)"
                monthLabel.text = "\(d.month)"
                
                contentView.backgroundColor = UIColor.yellowColor()
            }
        }
    }
}
