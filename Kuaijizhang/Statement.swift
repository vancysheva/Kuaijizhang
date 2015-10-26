//
//  Statement.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol Statement: Statisticable {
    
    /**
     * 消费地点分析
     **/
    var consumePlaceAnalysis: String { get }
    
    /**
     * 消费建议分析
     **/
    var consumeSuggestAnalysis: String { get }
    
    /**
     * 消费时段分析
     **/
    var consumeTimeAnalysis: String { get }
    
    /**
     * 日均支出
     **/
    var dayExpense: Double { get }
    
    /**
     * 月均支出
     **/
    var monthExpense: Double { get }
}