//
//  User.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/8.
//  Copyright © 2015年 范伟. All rights reserved.
//
import Foundation
import RealmSwift

class User: Object {
    
    dynamic var id = ""
    
    dynamic var username = ""
    
    dynamic var password = ""
    
    let accountBooks = List<AccountBook>()
}
