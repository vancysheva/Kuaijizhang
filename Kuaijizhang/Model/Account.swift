 //
//  Account.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {

    /**
     * 账户名称
     **/
    dynamic var name = ""
    
    dynamic var iconName = ""
    
    dynamic var accountBook: AccountBook?
    
    let accounts = List<Account>()
    
    let bills = List<Bill>()
}