//
//  ColorBox.swift
//  IntelligentPark
//
//  Created by 范伟 on 15/6/2.
//  Copyright (c) 2015年 范伟. All rights reserved.
//

import UIKit

class ColorBox {
    static let red = UIColor.redColor()
    static let green = UIColor.greenColor()
    static let yellow = UIColor.yellowColor()
    static let brown = UIColor.brownColor()
    static let gray = UIColor.grayColor()
    static let orange = UIColor.orangeColor()
    static let purple = UIColor.purpleColor()
    static let blue = UIColor.blueColor()
    static let magenta = UIColor.magentaColor()
    static let cyan = UIColor.cyanColor()
    
    static let colorsOfTen = [red, green, yellow, brown, gray, orange, purple, blue, magenta, cyan]
    
    class func randomColors(numberOfColor: Int) -> [UIColor] {
        var colors = [UIColor]()
        
        for _ in 0..<numberOfColor {
            let r = CGFloat(min(max(arc4random()%255, 1), 255))
            let g = CGFloat(min(max(arc4random()%255, 1), 255))
            let b = CGFloat(min(max(arc4random()%255, 1), 255))
            let color = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
            colors.append(color)
        }
        
        return colors
    }
    
    class func colorWithRGB(r r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
    }
}
