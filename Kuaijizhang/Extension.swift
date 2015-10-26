//
//  Extension.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

extension CALayer {
    //
    /**
    *  可在User Defined Runtime Attribute
    **/
    var borderUIColor: UIColor {
        get {
            return UIColor(CGColor: self.borderColor!)
        }
        set {
            self.borderColor = newValue.CGColor
        }
    }
}

extension String {
    /**
     * 去掉字符串空字符和换行符
    **/
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}