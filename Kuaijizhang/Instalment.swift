//
//  Instalment.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class Instalment: Object {
    
    /**
     * 分期月数
     **/
    dynamic var countMonth = 1
    
    /**
     * 每期金额
     **/
    dynamic var amount = 0.00
    
    dynamic var subject: Subject?

    dynamic var accountBook: AccountBook?
    
    let bills = List<Bill>()
}
