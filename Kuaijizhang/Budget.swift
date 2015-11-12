//
//  Budget.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class Budget: Object {
    
    /**
     * 月均预算
     **/
    dynamic var monthAmount = 0.00
    
    dynamic var consumeptionType: ConsumeptionType?
}