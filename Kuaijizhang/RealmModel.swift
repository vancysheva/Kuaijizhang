//
//  RealmModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel<T: Object> {
    
    let realm: Realm
    
    init() {
        self.realm = Realm.getRealmInstance()
    }
    
    var notificationHandler: ViewModelNotificationHandler?
    var objectList: List<T>?
    var object: T?
}
