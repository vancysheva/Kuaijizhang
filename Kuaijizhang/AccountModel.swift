//
//  AccountModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class AccountModel: RealmModel<Account> {
    
    override init() {
        super.init()
        objectList = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first?.accounts
    }
    
    func parentAccountAt(index: Int) -> Account? {
        return objectList?[index]
    }
    
    func childAccountAt(parentAccountName name: String, index: Int) -> Account? {
        return objectList?.filter("name = %@", name).first?.accounts[index]
    }
    
    func getParentAccountCount() -> Int {
        return objectList?.count ?? 0
    }
    
    func getChildAccountCount(parentAccountName name: String) -> Int {
        return objectList?.filter("name = %@", name).first?.accounts.count ?? 0
    }
    
    func getChildAccountCount(section: Int) -> Int {
        return objectList?[section].accounts.count ?? 0
    }
    
    func objectAt(indexPath: NSIndexPath) -> Account? {
        return objectList?[indexPath.section].accounts[indexPath.row]
    }
}