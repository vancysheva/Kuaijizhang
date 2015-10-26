//
//  BillStreamViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

struct BillStreamViewModel {
    
    typealias bill = (date: Int, money: Double, type: BillType, label: String, consumeName: String, comment: String)
    typealias bills = [bill]
    typealias month = Int
    
    var data = [month : bills]()
    
    init() {
        for month in 1...12 {
            data[month] = []
            for day in 0..<50 {
                let tuple = (day, 432.0+Double(day), BillType.Expense, "测试", "测试支出\(day)", "测试\(day)")
                data[month]?.append(tuple)
            }
        }
    }
}
