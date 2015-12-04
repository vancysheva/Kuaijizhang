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
        print("test")
    }
    
    func parentAccountWithAmountAt(parentIndex: Int) -> (parentName: String?, parentAmount: String?, iconNmae: String?) {
        
        var amount = 0.0
        
        if let parentAccount = model.parentAccountAtIndex(parentIndex) {
            
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
        
        if let childAccount = model.childAccountAtParentIndex(parentIndex, withChildIndex: childIndex) {
            return (childAccount.name, "\(childAccount.bills.reduce(0) { $0 + $1.money })")
        }
        return (nil, nil)
    }
    
    func numberOfParentAccounts() -> Int {
        
        return model.numberOfParentAccounts()
    }
    
    func numberOfChildAccountsAtParentIndex(parentIndex: Int) -> Int {
        
        return model.numberOfChildAccountsAtParentIndex(parentIndex)
    }
    
    func saveAccountWidthChildName(name: String, parentAccountIndex index: Int) {
        model.saveAccountWithChildName(name, withParentAccountIndex: index)
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
    
    func moveoObjectFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let state = model.realm.writeTransaction {
            if let parentAccount = self.model.objectList?[fromIndexPath.section] {
                parentAccount.accounts.move(from: fromIndexPath.row, to: toIndexPath.row)
            }
        }
        model.sendNotificationsFeedBack(state, changedType: .Move(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row), indexPath: fromIndexPath, userInfo: nil)
    }
}
