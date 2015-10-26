//
//  Account.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol Account: Statisticable {
    
    /**
     * 账户名称
     **/
    var name: (Int, String) { get set }
    
    /**
     * 账户类型
     **/
    var bank: (Int, String) { get set }
}