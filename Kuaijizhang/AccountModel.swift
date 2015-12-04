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
    
    func parentAccountAtIndex(index: Int) -> Account? {
        return objectAtIndex(index)
    }
    
    func childAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) -> Account? {
        return objectAtIndex(parentIndex)?.accounts[childIndex]
    }
    
    func numberOfParentAccounts() -> Int {
        return objectCount
    }
    
    func numberOfChildAccountsAtParentIndex(parentIndex: Int) -> Int {
        return objectAtIndex(parentIndex)?.accounts.count ?? 0
    }
    
    func childAccount(indexPath: NSIndexPath) -> Account? {
        return objectAtIndex(indexPath.section)?.accounts[indexPath.row]
    }
    
    func saveAccountWithChildName(name: String, withParentAccountIndex index: Int) {
        
        let child = Account()
        child.name = name
        if let parentAccount = self.parentAccountAtIndex(index) {
            appendObject(child, inList: parentAccount.accounts, inSection: index)
        }
    }
    
    func deleteAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let childAccount = parentAccountAtIndex(parentIndex)?.accounts[childIndex] {
            delete(childAccount, indexPath: NSIndexPath(forRow: childIndex, inSection: parentIndex))
        }
    }
    
    func updateAccountAtParentIndexWithName(name: String, widthParentIndex parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let childAccount = childAccountAtParentIndex(parentIndex, withChildIndex: childIndex) {
            let state = realm.writeTransaction {
                childAccount.name = name
            }
            let indexPath = NSIndexPath(forRow: childIndex, inSection: parentIndex)
            sendNotificationsFeedBack(state, changedType: .Update, indexPath: indexPath, userInfo: nil)
        }
    }
    
}