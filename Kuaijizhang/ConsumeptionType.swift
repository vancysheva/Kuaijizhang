//
//  ConsumeptionType.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class ConsumeptionType: Object {
    
    dynamic var type = ""
    
    dynamic var name = ""
    
    dynamic var iconName = ""
    
    dynamic var accountBook: AccountBook?
    
    dynamic var budget: Budget?
    
    let consumeptionTypes = List<ConsumeptionType>()
    
    let bills = List<Bill>()
}