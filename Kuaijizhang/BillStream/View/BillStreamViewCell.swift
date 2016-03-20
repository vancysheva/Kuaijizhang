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
        layoutMargins = UIEdgeInsetsZero
        
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
                day.hidden = !d.displayDay
                week.hidden = !d.displayDay
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

                separatorInset.left = d.displayLongSeparatorLine ? 0 : sx
            }
        }
    }
    
    var sx: CGFloat {
        return consumeptionTypeImage.frame.origin.x - 5
    }
    
    let sy = CGFloat(0)
    
    var startPoint: CGPoint {
        return CGPoint(x: sx, y: sy)
    }
    
    var ex: CGFloat {
        return sx
    }
    
    var ey: CGFloat {
        return sy + frame.size.height
    }
    
    var endPoint: CGPoint {
        return CGPoint(x: ex, y: ey)
    }

    
    override func drawRect(rect: CGRect) {

        let path = UIBezierPath()
        path.lineWidth = 0.4
        UIColor.lightGrayColor().setStroke()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        path.stroke()
    }
}
