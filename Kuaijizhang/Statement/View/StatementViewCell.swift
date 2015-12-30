//
//  StatementViewCell.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/29.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class StatementViewCell: UITableViewCell {
    
    var data: (day: String, value: Double)? {
        didSet {
            typeNameLabel.text = data!.day
            percentLabel.text = "\(data!.value)%"
            moneyLabel.text = "\(data!.value)"
        }
    }

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    
    func drawBar(lineStartPoint lineStartPoint: CGPoint, lineOverPoint: CGPoint, lineWidth: CGFloat, color: UIColor) {
        
        let columnPath = UIBezierPath()
        columnPath.moveToPoint(lineStartPoint)
        columnPath.addLineToPoint(lineOverPoint)
        
        let pathlayer = CAShapeLayer()
        pathlayer.frame = bounds
        pathlayer.path = columnPath.CGPath
        pathlayer.strokeColor = color.CGColor
        pathlayer.fillColor = nil
        pathlayer.lineWidth = lineWidth
        pathlayer.lineJoin = kCALineJoinBevel
        layer.addSublayer(pathlayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        
        pathlayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        
    }
    
    override func drawRect(rect: CGRect) {
        
        if let value = data?.value {
            let lineWidth = barView.frame.height
            let startPoint = CGPoint(x: barView.frame.origin.x, y: barView.frame.origin.y + (lineWidth/2))
            let overPoint = CGPoint(x: startPoint.x + (barView.frame.width * CGFloat(value/100)) , y: startPoint.y)
            let color = UIColor.blueColor()
            drawBar(lineStartPoint: startPoint, lineOverPoint: overPoint, lineWidth: lineWidth, color: color)
        }
    }
}
