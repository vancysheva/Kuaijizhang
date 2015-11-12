//
//  AccountBookModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/10.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class AccountBookModel {
    
    private var realm: Realm?
    private let user: User?
    
    init() {
        self.realm = Realm.getRealmInstance()
        self.user = System.getCurrentUser()
    }
    
    func getCount() -> Int {
        return user?.accountBooks.count ?? 0
    }
    
    func deleteAt(index: Int) {
        realm?.writeTransaction { [unowned self] in
            self.user?.accountBooks.removeAtIndex(index)
        }
    }
    
    func objectAt(index: Int) -> AccountBook? {
        return user?.accountBooks[index]
    }
    
    func setCurrentUsingAt(index: Int) {
        
        if let currentUser = System.getCurrentUser() {
            realm?.writeTransaction {
                let books = currentUser.accountBooks
                    books.forEach {
                    $0.isUsing = false
                }
                books[index].isUsing = true
            }
        }
    }
    
    func addAccountBookWithTitle(title: String, coverImageName: String) {
        
        if let currentUser = user, defaultAccountBook = System.getDefaultAccountBook() {
            realm?.writeTransaction {
                currentUser.accountBooks.forEach {
                    $0.isUsing = false
                }
                defaultAccountBook.title = title
                defaultAccountBook.coverImageName = coverImageName
                currentUser.accountBooks.append(defaultAccountBook)
            }
        }
    }
}