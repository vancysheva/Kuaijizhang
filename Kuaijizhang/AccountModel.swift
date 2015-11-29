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
        return objectList?[index]
    }
    
    func childAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) -> Account? {
        return objectList?[parentIndex].accounts[childIndex]
    }
    
    func numberOfParentAccounts() -> Int {
        return objectList?.count ?? 0
    }
    
    func numberOfChildAccountsAtParentIndex(parentIndex: Int) -> Int {
        return objectList?[parentIndex].accounts.count ?? 0
    }
    
    func childAccount(indexPath: NSIndexPath) -> Account? {
        return objectList?[indexPath.section].accounts[indexPath.row]
    }
    
    func saveAccountWithChildName(name: String, withParentAccountIndex index: Int) {
        
        let child = Account()
        child.name = name
        if let parentAccount = self.parentAccountAtIndex(index) {
            let state = realm.writeTransaction {
                parentAccount.accounts.append(child)
            }
            let indexPath = NSIndexPath(forRow: parentAccount.accounts.count - 1, inSection: index)
            notificationHandler?(transactionState: state, dataChangedType: .Insert, indexPath: indexPath, userInfo: nil)
        }
    }
    
    func deleteAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let parentAccount = parentAccountAtIndex(parentIndex) {
            let state = realm.writeTransaction {
                parentAccount.accounts.removeAtIndex(childIndex)
            }
            let indexPath = NSIndexPath(forRow: childIndex, inSection: parentIndex)
            notificationHandler?(transactionState: state, dataChangedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
    
    func updateAccountAtParentIndexWithName(name: String, widthParentIndex parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let childAccount = childAccountAtParentIndex(parentIndex, withChildIndex: childIndex) {
            let state = realm.writeTransaction {
                childAccount.name = name
            }
            let indexPath = NSIndexPath(forRow: childIndex, inSection: parentIndex)
            notificationHandler?(transactionState: state, dataChangedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
    
}