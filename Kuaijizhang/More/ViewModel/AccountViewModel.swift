//
//  AccountViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/23.
//  Copyright © 2015年 范伟. All rights reserved.
//


import Foundation

class AccountViewModel: ViewModelBase<AccountModel> {
    
    init() {
        super.init(model: AccountModel())
    }
    
    func parentAccountWithAmountAt(parentIndex: Int) -> (parentName: String, parentAmount: String, iconName: String) {
        
        var amount = 0.0
        
        if let parentAccount = model.objectAtIndex(parentIndex) {
            
            parentAccount.accounts.forEach {
                $0.bills.forEach {
                    amount += $0.money
                }
            }
            return  (parentAccount.name, "\(amount)", parentAccount.iconName)
        }
        return ("", "", "")
    }
    
    func childAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) -> (childName: String, childAmount: String) {
        
        if let childAccount = model.objectAtIndex(parentIndex)?.accounts[childIndex] {
            return (childAccount.name, "\(childAccount.bills.reduce(0) { $0 + $1.money })")
        }
        return ("", "")
    }
    
    func numberOfParentAccounts() -> Int {
        return model.numberOfObjects
    }
    
    func numberOfChildAccountsAtParentIndex(parentIndex: Int) -> Int {
        
        if model.numberOfObjects != 0 {
            return model.objectAtIndex(parentIndex)?.accounts.count ?? 0
        } else {
            return 0
        }
    }
    
    func saveAccountWithChildName(name: String, parentAccountName: String, parentIconName: String) {
        model.saveAccountWithChildName(name, parentAccountName: parentAccountName, parentIconName: parentIconName)
    }
    
    func deleteAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) {
        model.deleteAccountAtParentIndex(parentIndex, withChildIndex: childIndex)
    }
    
    func updateChildAccountWithName(name: String, atParentIndex parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let childAccount = model.objectAtIndex(parentIndex)?.accounts[childIndex] {
            model.updateObjectWithIndex(childIndex, inSection: parentIndex) { () -> Void in
                childAccount.name = name
            }
        }
    }
    
    func moveObjectFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        model.moveObjectFromIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
    
    func allIncome() -> Double {
        return model.allIncome()
    }
    
    func allExpense() -> Double {
        return model.allExpense()
    }
    
    
    func readParentAccount() -> [(String, String)] {
        return model.readParentAccount()
    }
}
