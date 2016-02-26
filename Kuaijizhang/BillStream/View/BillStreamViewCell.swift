//
//  BillStreamViewCell.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BillStreamViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var week: UILabel!
    @IBOutlet weak var consumeType: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var consumeptionTypeImage: UIImageView!
    @IBOutlet weak var billImage: UIImageView!
    
    var data: BillTuple? {
        didSet {
            if let d = data {
                day.text = "\(d.day)"
                week.text = d.week
                consumeType.text = d.consumeName
                if comment != nil {
                    comment.text = d.conmment
                }
                money.text = "\(d.money)"
                money.textColor = d.billType.color
                consumeptionTypeImage.image = UIImage(named: d.iconName)
                billImage.hidden = !d.haveBillImage
                
            }
        }
    }
}
