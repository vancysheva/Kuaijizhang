//
//  CountingLabel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/1/23.
//  Copyright © 2016年 范伟. All rights reserved.
//

import Foundation
import UICountingLabel

class CountingLabel: UICountingLabel {
    
    var digitString: String? {
        didSet {
            if let txt = digitString, digit = Float(txt) where digit != 0.0 {
                animationDuration = 1
                countFromZeroTo(digit)
            }
        }
    }
    
}