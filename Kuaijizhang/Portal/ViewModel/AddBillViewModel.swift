//
//  AddBillViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AddBillViewModel: ViewModelBase<AddBillModel> {
    
    var money: Double = 0.0
    var parentConsumpetionType: ConsumeptionType?
    var childConsumpetionType: ConsumeptionType?
    var parentAccount: Account?
    var childAccount: Account?
    var date: String?
    var subject: Subject?
    var image: NSData?
    var comment: String?
    
    var billForUpdate: Bill? {
        didSet {
            if let b = billForUpdate {
                money = b.money
                parentConsumpetionType = b.consumeType
                childConsumpetionType = b.consumeType?.subConsumeptionType
                parentAccount = b.account
                childAccount = b.account?.subAccount
                if let d = b.occurDate {
                    date = DateHelper.getStringFromDate(d, dateFormat: DateHelper.dateFormatForCurrentTime)
                }
                subject = b.subject
                image = b.image
                comment = b.comment
            }
        }
    }
    
    init() {
        super.init(model: AddBillModel())
    }
    
    func getConsumeptionTypeDescription(billType: BillType) -> String {
        
        let raw = billType.rawValue
        if let parentConsumpetionType = model.getFirstConsumpetionType(raw), childConsumpetionType = parentConsumpetionType.consumeptionTypes.first {
            
            self.parentConsumpetionType = parentConsumpetionType
            self.childConsumpetionType = childConsumpetionType
            
            return "\(parentConsumpetionType.name)>\(childConsumpetionType.name)"
        }
        return ""
    }
    
    func getAccountDescription() -> String {
        if let parentAccount = model.getFirstAccount(), childAccount = parentAccount.accounts.first {
            
            self.parentAccount = parentAccount
            self.childAccount = childAccount
            
            return "\(childAccount.name)"
        }
        return ""
    }
    
    func getCurrentTime() -> String {
        date = DateHelper.getCurrentTime()
        return date!
    }
    
    func saveBill(comment: String?) {
        
        if let d = date {
            let occurDate = DateHelper.dateFromString(d, formatter: DateHelper.dateFormatForCurrentTime)
            model.saveBill(money, parentConsumpetionType: parentConsumpetionType, childConsumeptionType: childConsumpetionType, parentAccount: parentAccount, childAccount: childAccount, date: occurDate, subject: subject, comment: comment, image: image)
        }
    }
}