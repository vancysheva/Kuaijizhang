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
    
    func parentAccountAt(index: Int) -> String? {
        
        return accountModel.parentAccountAt(index)?.name
    }
    
    func parentAccountWidthAmountAt(section: Int) -> (String?, String?) {
        
        var amount = 0.0
        
        if let parentAccount = accountModel.parentAccountAt(section) {
            parentAccount.accounts.forEach {
                $0.bills.forEach {
                    amount += $0.money
                }
            }
            return  (parentAccount.name, "\(amount)")
        }
        return (nil, nil)
    }
    
    func childAccountAt(parentAccountName name: String, index: Int) -> String? {
        
        return accountModel.childAccountAt(parentAccountName: name, index: index)?.name
    }
    
    func getParentAccountCount() -> Int {
        
        return accountModel.getParentAccountCount()
    }
    
    func getChildAccountCount(parentAccountName name: String) -> Int {
        
        return accountModel.getChildAccountCount(parentAccountName: name)
    }
    
    func getChildAccountCount(section: Int) -> Int {
        
        return accountModel.getChildAccountCount(section)
    }
    
    func objectAt(indexPath: NSIndexPath) -> (String, Double)? {
        
        if let account = accountModel.objectAt(indexPath) {
            return (account.name, account.bills.reduce(0){$0 + $1.money})
        }
        return nil
    }
    
    func saveAccountWidthChildName(name: String, parentAccountIndex index: Int) {
        accountModel.saveAccountWidthChildName(name, parentAccountIndex: index)
    }
}

extension AccountViewModel: ViewModelNotifiable {
    
    func addNotification(notificationHandler: ViewModelNotificationHandler) {
        accountModel.notificationHandler = notificationHandler
    }
}
