//
//  Subject.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class Subject: Object {
    
    dynamic var name = ""
    
    dynamic var accountBook: AccountBook?
    
    let bills = List<Bill>()
}