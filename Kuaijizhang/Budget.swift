//
//  Budget.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol Budget: Statisticable {
    
    /**
     * 预算类型
     **/
    var type: (Int, String) { get set }
    
    /**
     * 日均预算
     **/
    var dayAmount: Double? { get }
    
    /**
     * 月均预算
     **/
    var monthAmount: Double? { get }
    
    /**
     * 年均预算
     **/
    var yearAmount: Double? { get }
}