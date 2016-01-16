//
//  AddBillModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AddBillModel: RealmModel<Bill> {
    
    var currentAccountBook: AccountBook?
    
    override init() {
        super.init()

        currentAccountBook = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first
    }
    
    func getFirstConsumpetionType(type: Int) -> ConsumeptionType? {
        return currentAccountBook?.consumeptionTypes.filter("type = %@", "\(type)").first
    }
    
    func parentConsumeptionTypeFromName(typeName: String) -> ConsumeptionType? {
        return currentAccountBook?.consumeptionTypes.filter("name = %@", typeName).first
    }
    
    func childConsumeptionTypeFromName(parentConsumeptionTypeName parentName: String, childConsumeptionTypeName childName: String) -> ConsumeptionType? {
        let parent = parentConsumeptionTypeFromName(parentName)
        return parent?.consumeptionTypes.filter("name = %@", childName).first
    }
    
    func getFirstAccount() -> Account? {
        return currentAccountBook?.accounts.first
    }
    
    func parentAccountFromName(parentAccountName name: String) -> Account? {
        return currentAccountBook?.accounts.filter("name = %@", name).first
    }
    
    func childAccountFromName(parentAccountName parentName: String, childAccountName childName: String) -> Account? {
        let parent = parentAccountFromName(parentAccountName: parentName)
        return parent?.accounts.filter("name = %@", childName).first
    }
    
    func saveBill(money: Double, parentConsumpetionType: ConsumeptionType?, childConsumeptionType: ConsumeptionType?, parentAccount: Account?, childAccount: Account?, date: NSDate?, subject: Subject?, comment: String?, image: NSData?) {
        
        let state = realm.writeTransaction {
            
            if let cc = childConsumeptionType {
                parentConsumpetionType?.subConsumeptionType = cc
            }
            
            if let ca = childAccount {
                parentAccount?.subAccount = ca
            }
            
            let bill = Bill()
            bill.money = money
            bill.accountBook = self.currentAccountBook
            bill.account = parentAccount
            bill.consumeType = parentConsumpetionType
            bill.subject = subject
            bill.image = image
            bill.comment = comment
            bill.occurDate = date
            
            self.currentAccountBook?.bills.append(bill)
            childAccount?.bills.append(bill)
            childConsumeptionType?.bills.append(bill)
            subject?.bills.append(bill)
        }
        let indexPath = NSIndexPath(forItem: (currentAccountBook?.bills.count ?? 1) - 1, inSection: 0)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
 
}
