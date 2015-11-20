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
     添加默认账本。
    */
    class func createDefaultAccountBook(id: String = "", username: String = "", password: String = "") {

        do {
            let realm = try Realm()
            if let account = getDefaultAccountBook() {
                realm.writeTransaction {
                    let user = User(value: [id, username, password, [account]])
                    realm.add(user)
                }
            }
        } catch {
            NSLog("初始化数据库实例发生错误！")
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
        
        if let userDic = NSUserDefaults.standardUserDefaults().dictionaryForKey(Identifier.User) {
            let queryUser = User(value: userDic)
            if let user = realm.objects(User.self).filter("id == %@ AND username == %@ AND password == %@", queryUser.id, queryUser.username, queryUser.password).first {
                return user
            }
            return nil
        }
        return nil
    }
    
    class func baseInit() {
    
        let obj = NSUserDefaults.standardUserDefaults()
        if obj.dictionaryForKey(Identifier.User) == nil {
            obj.setObject(["id": "", "username": "", "password": ""], forKey: Identifier.User)
            createDefaultAccountBook()
        } else if getCurrentUser() == nil {
            //let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            //!NSFileManager.defaultManager().fileExistsAtPath("\(paths[0])/default.realm")
            if let dic = obj.dictionaryForKey(Identifier.User) {
                createDefaultAccountBook(dic["id"] as! String, username: dic["username"] as! String, password: dic["password"] as! String)
            }
        }
    }
}