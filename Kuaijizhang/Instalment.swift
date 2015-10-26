//
//  Instalment.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol Instalment: Bill {
    
    /**
     * 分期月数
     **/
    var countMonth: Int { get set }
    
    /**
     * 每期金额
     **/
    var amount: Double { get }
    
}
