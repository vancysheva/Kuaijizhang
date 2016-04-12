//
//  AdvanceSearchModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/4/9.
//  Copyright © 2016年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class ConsumeptionTypeOptionModel: RealmModel<ConsumeptionType> {
    
    override init() {
        super.init()
        let book = (System.getCurrentUser()?.accountBooks.filter("isUsing = true").first)
        self.objectList = book?.consumeptionTypes
    }
}

class AccountOptionModel: RealmModel<Account> {
    
    override init() {
        super.init()
        let book = (System.getCurrentUser()?.accountBooks.filter("isUsing = true").first)
        self.objectList = book?.accounts
    }
}

class SubjectOptionModel: RealmModel<Subject> {
    
    override init() {
        super.init()
        let book = (System.getCurrentUser()?.accountBooks.filter("isUsing = true").first)!
        self.objectList = book.subjects
    }
}