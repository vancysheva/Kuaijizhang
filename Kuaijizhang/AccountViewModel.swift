//
//  AccountViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AccountViewModel {
    
    let accountModel: AccountModel
    
    init() {
        self.accountModel = AccountModel()
    }
    
    func parentAccountWithAmountAt(parentIndex: Int) -> (parentName: String?, parentAmount: String?, iconNmae: String?) {
        
        var amount = 0.0
        
        if let parentAccount = accountModel.parentAccountAtIndex(parentIndex) {
            
            parentAccount.accounts.forEach {
                $0.bills.forEach {
                    amount += $0.money
                }
            }
            return  (parentAccount.name, "\(amount)", parentAccount.iconName)
        }
        return (nil, nil, nil)
    }
    
    func childAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) -> (childName: String?, childAmount: String?) {
        
        if let childAccount = accountModel.childAccountAtParentIndex(parentIndex, withChildIndex: childIndex) {
            return (childAccount.name, "\(childAccount.bills.reduce(0) { $0 + $1.money })")
        }
        return (nil, nil)
    }
    
    func numberOfParentAccounts() -> Int {
        
        return accountModel.numberOfParentAccounts()
    }
    
    func numberOfChildAccountsAtParentIndex(parentIndex: Int) -> Int {
        
        return accountModel.numberOfChildAccountsAtParentIndex(parentIndex)
    }
    
    func saveAccountWidthChildName(name: String, parentAccountIndex index: Int) {
        accountModel.saveAccountWithChildName(name, withParentAccountIndex: index)
    }
    
    func deleteAccountAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) {
        //accountModel.deleteAccountAtParentIndex(parentIndex, withChildIndex: childIndex)
        accountModel
    }
}

extension AccountViewModel: ViewModelNotifiable {
    
    func addNotification(notificationHandler: ViewModelNotificationHandler) {
        accountModel.notificationHandler = notificationHandler
    }
}
