//
//  Statisticable.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol Statisticable {
    
    /**
     * 名称
    **/
    var title: String { get set }
    
    /**
     * 支出
     **/
    var expense: Double { get set }
    
    /**
     * 收入
     **/
    var income: Double { get set }
    
    /**
     * 结余
     **/
    var surplus: Double { get }
    
    /**
     * 限额
     **/
    var expenseLimit: Double { get set }
    
    /**
     * 开始日期，也可以作为创建日期用
     **/
    var beginDate: NSDate { get set }
    
    /**
     * 结束日期
     **/
    var endDate: NSDate { get set }
}
