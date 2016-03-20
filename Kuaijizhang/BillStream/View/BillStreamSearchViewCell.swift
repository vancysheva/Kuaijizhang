//
//  BillStreamSearchViewCell.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/19.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class BillStreamSearchViewCell: UITableViewCell {

    @IBOutlet weak var consumpeTypeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var consumeTypeImageView: UIImageView!
    @IBOutlet weak var billImageView: UIImageView!
    
    var data: SearchBillTuple? {
        didSet {
            if let d = data {
                consumpeTypeLabel.text = d.consumeName
                if commentLabel != nil {
                    commentLabel.text = d.comment
                }
                moneyLabel.text = "\(d.money)"
                moneyLabel.textColor = d.billType.color
                consumeTypeImageView.image = UIImage(named: d.iconName ?? "")
                billImageView.hidden = !d.haveBillImage
            }
        }
    }
}
