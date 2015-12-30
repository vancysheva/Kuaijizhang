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
    
    func saveAccountWithChildName(name: String, parentAccountName: String, parentIconName: String) {
        
        let child = Account()
        child.name = name
        if let parentIndex = objectList?.indexOf("name='\(parentAccountName)'"), parentAccount = objectList?[parentIndex] {
            appendObject(child, inList: parentAccount.accounts, inSection: parentIndex, userInfo: ["type": "insertChild"])
        } else {
            let parent = Account()
            parent.name = parentAccountName
            parent.iconName = parentIconName
            
            let state = realm.writeTransaction {
                parent.accounts.append(child)
                self.objectList?.append(parent)
            }
            let indexPath = NSIndexPath(forRow: (objectList?.count ?? 1) - 1, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: ["type": "insertParent"])
            
        }
    }
    
    func deleteAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let parentAccount = objectAtIndex(parentIndex) {
            
            var lastOneDelete = false
            if parentAccount.accounts.count == 1 {
                lastOneDelete = true
            }
            deleteObjectWithIndex(childIndex, inSection: parentIndex, userInfo: ["lastOneDelete": lastOneDelete]) {
                self.realm.delete(parentAccount.accounts[childIndex])
                if lastOneDelete {
                    self.realm.delete(parentAccount)
                }
            }
         }
    }
    
    func moveObjectFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let state = realm.writeTransaction {
            if let parentAccount = self.objectList?[fromIndexPath.section] {
                parentAccount.accounts.move(from: fromIndexPath.row, to: toIndexPath.row)
            }
        }
        sendNotificationsFeedBack(state, changedType: .Move(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row), indexPath: fromIndexPath, userInfo: nil)
    }
    
    func allIncome() -> Double {
        
        if let parentAccounts = objectList {
            return parentAccounts.reduce(0.0) {
                $0 + $1.accounts.reduce(0.0) {
                    $0 + $1.bills.filter("consumeType.type == '0'").reduce(0.0) {
                        $0 + $1.money
                    }
                }
            }
        }
        return 0.0
    }
    
    func allExpense() -> Double {
        
        if let parentAccounts = objectList {
            return parentAccounts.reduce(0.0) {
                $0 + $1.accounts.reduce(0.0) {
                    $0 + $1.bills.filter("consumeType.type == '1'").reduce(0.0) {
                        $0 + $1.money
                    }
                }
            }
        }
        return 0.0
    }
    
    
    
    func readParentAccount() -> [(String, String)] {
        
        var types = [(String, String)]()
        System.getDefaultAccountBook()?.accounts.forEach {
            types.append(($0.iconName, $0.name))
        }
        
        return types
    }
}