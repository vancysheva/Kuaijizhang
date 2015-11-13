//
//  Realm+Extension.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/12.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    
    class func getRealmInstance() -> Realm {
        return try! Realm()
    }
    
    func writeTransaction(block: () -> Void) -> TransactionState {
        do {
            try write(block)
            return .Success
        } catch let error as NSError {
            NSLog("写入事务发生错误！错误如下：％@ ％@", error, error.userInfo)
            return .Failure(errorMsg: "写入事务发生错误！")
        }
    }
    
    func commitTransaction() -> TransactionState {
        do {
            try commitWrite()
            return .Success
        } catch let error as NSError {
            NSLog("提交事务发生错误！错误如下：％@ ％@", error, error.userInfo)
            return .Failure(errorMsg: "提交事务发生错误！")
        }
    }

}
