//
//  AccountBookModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/10.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AccountBookModel: RealmModel<AccountBook> {

    override init() {
        super.init()
        objectList = System.getCurrentUser()?.accountBooks
    }
    
    func deleteAt(indexPath: NSIndexPath) {
        //// 删除账本并且删除账本下相关的所有对象
        if let book = objectAtIndex(indexPath.row) {
            realm.beginWrite()
            
            realm.delete(book.bills)
            let accounts = book.accounts
            accounts.forEach {
                if $0.accounts.count > 0 {
                    realm.delete($0.accounts)
                }
            }
            realm.delete(accounts)
            let types = book.consumeptionTypes
            types.forEach {
                if $0.consumeptionTypes.count > 0 {
                    realm.delete($0.consumeptionTypes)
                }
            }
            realm.delete(types)
            realm.delete(book.subjects)
            realm.delete(book.instalments)
            realm.delete(book)
            let state = realm.commitTransaction()

            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }

    func setCurrentUsingAt(indexPath: NSIndexPath) {
        
        realm.writeTransaction {
            self.objectList?.forEach {
                $0.isUsing = false
            }
            self.objectList?[indexPath.row].isUsing = true
        }
    }
    
    func addAccountBookWithTitle(title: String, coverImageName: String) {

        if let defaultAccountBook = System.getDefaultAccountBook() {
            defaultAccountBook.title = title
            defaultAccountBook.coverImageName = coverImageName
            realm.writeTransaction {
                self.objectList?.forEach {
                    $0.isUsing = false
                }
            
            }
            appendObject(defaultAccountBook)
        }
    }
}