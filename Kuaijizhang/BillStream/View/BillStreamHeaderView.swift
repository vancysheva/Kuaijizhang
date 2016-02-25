//
//  BillStreamHeaderView.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import Tactile

class BillStreamHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var consumeLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var surplusLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    var data: (month: Int, income: Double, expense: Double, surplus: Double)? {
        didSet {
            if let d = data {
                if let label = consumeLabel{
                    label.text = "\(d.expense)"
                }
                if let label = incomeLabel{
                    label.text = "\(d.income)"
                }
                surplusLabel.text = "\(d.surplus)"
                monthLabel.text = "\(d.month)"
                
                contentView.backgroundColor = UIColor.yellowColor()
                
                let tapGestureRecognizer = UITapGestureRecognizer()
                tapGestureRecognizer.numberOfTapsRequired = 1
                tapGestureRecognizer.numberOfTouchesRequired = 1
                self.addGestureRecognizer(tapGestureRecognizer)
                
                self.on(tapGestureRecognizer, tapHeader)
            }
        }
    }
    
    var section: Int?
    var month: Int?
    var tapGestureHandler: ((month: Int, section: Int)->Void)?
    
    func tapHeader(gesture: UITapGestureRecognizer) {
        
        if let m = month, s = section {
            tapGestureHandler?(month: m, section: s)
        }
    }
    
    deinit {
        self.off()
    }
}
