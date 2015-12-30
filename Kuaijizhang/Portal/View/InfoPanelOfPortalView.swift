//
//  InfoPanelOfPortalView.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/20.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

@IBDesignable
class InfoPanelOfPortalView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        
        path.moveToPoint(CGPoint(x: center.x, y: 20))
        path.addLineToPoint(CGPoint(x: center.x, y: bounds.size.height - 30))
        
        path.moveToPoint(CGPoint(x: 10, y: bounds.size.height/2))
        path.addLineToPoint(CGPoint(x: bounds.size.width - 10, y: bounds.size.height/2))

        UIColor.lightGrayColor().setStroke()
        
        path.stroke()
    }

}
