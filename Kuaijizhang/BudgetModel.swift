//
//  BudgetModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/6.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class BudgetModel: RealmModel<ConsumeptionType> {
    
    override init() {
        super.init()
        objectList = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first?.consumeptionTypes.filter("type = '0'").toList()
    }

}