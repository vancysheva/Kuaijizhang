


//
//  CALayer+Extension.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/12.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import UIKit

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