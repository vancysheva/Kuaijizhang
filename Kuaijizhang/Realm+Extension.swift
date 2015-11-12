//
//  DataAccesser.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/12.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift


extension Realm {
    
    class func getRealmInstance() -> Realm? {
        
        do {
            return try Realm()
        } catch {
            NSLog("初始化数据库实例发生错误！")
            return nil
        }
    }
    
    func writeTransaction(block: () -> Void) {
        do {
            try write(block)
        } catch let error as NSError {
            NSLog("写入事务发生错误！错误如下：％@ ％@", error, error.userInfo)
        }

    }
    
    func commitTransaction() {
        do {
            try commitWrite()
        } catch let error as NSError {
            NSLog("提交事务发生错误！错误如下：％@ ％@", error, error.userInfo)
        }
    }

}
