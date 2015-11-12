//
//  System.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/9.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift


class System {
    
    struct Identifier {
        static let User = "\(NSBundle.mainBundle().bundleIdentifier!).user"
    }
    
    /**
     创建默认Realm数据库,并添加默认账本
    */
    class func createDefaultRealmAndAccountBook(id: String = "", username: String = "", password: String = "") {

        let realm = Realm.getRealmInstance()
        
        if let account = getDefaultAccountBook() {
            realm?.writeTransaction {
                let user = User(value: [id, username, password, [account]])
                realm?.add(user)
            }
        }
    }
    
    /**
     获取默认的账本
    */
    class func getDefaultAccountBook() -> AccountBook? {
        
        if let dic = NSDictionary(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("DefaultAccountBook", ofType: "plist")!)) {
            return AccountBook(value: dic)
        }
        return nil
    }
    
    /**
     获取当前用户
    */
    class func getCurrentUser() -> User? {
        
        let realm = Realm.getRealmInstance()
        
        if let userDic = NSUserDefaults.standardUserDefaults().dictionaryForKey(System.Identifier.User) {
            let queryUser = User(value: userDic)
            if let user = realm?.objects(User.self).filter("id == %@ AND username == %@ AND password == %@", queryUser.id, queryUser.username, queryUser.password).first {
                return user
            }
            return nil
        }
        return nil
    }
}