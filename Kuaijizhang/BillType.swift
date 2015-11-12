//
//  BillType.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/20.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import UIKit

enum BillType: Int {
    case Expense, Income
    
    var color: UIColor {
        return self == .Expense ? UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0) : UIColor(red: 203/255, green: 55/255, blue: 66/255, alpha: 1.0)
    }
    
    var title: String {
        return self == .Expense ? "支出" : "收入"
    }
    
    mutating func toggle() -> BillType {
        self = (self == .Expense ? Income : Expense)
        return self
    }
}
