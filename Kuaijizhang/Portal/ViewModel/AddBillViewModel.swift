//
//  AddBillViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AddBillViewModel {
    
    let addBillModel: AddBillModel
    var parentConsumpetionType: ConsumeptionType?
    var childConsumpetionType: ConsumeptionType?
    var parentAccount: Account?
    var childAccount: Account?
    
    init() {
        self.addBillModel = AddBillModel()
    }
    
    
    func getConsumeptionTypeDescription(billType: BillType) -> String {
        
        let raw = billType.rawValue
        if let parentConsumpetionType = addBillModel.getFirstConsumpetionType(raw), childConsumpetionType = parentConsumpetionType.consumeptionTypes.first {
            
            self.parentConsumpetionType = parentConsumpetionType
            self.childConsumpetionType = childConsumpetionType
            
            return "\(parentConsumpetionType.name)>\(childConsumpetionType.name)"
        }
        return ""
    }
    
    func getAccountDescription() -> String {
        if let parentAccount = addBillModel.getFirstAccount(), childAccount = parentAccount.accounts.first {
            
            self.parentAccount = parentAccount
            self.childAccount = childAccount
            
            return "\(childAccount.name)"
        }
        return ""
    }
    
    func setParentConsumeptionTypeFromName(typeName: String) {
        
        parentConsumpetionType = addBillModel.parentConsumeptionTypeFromName(typeName)
    }
    
    func setChildConsumeptionTypeFromName(parentConsumeptionTypeName parentName: String, childConsumeptionTypeName childName: String) {
        childConsumpetionType = addBillModel.childConsumeptionTypeFromName(parentConsumeptionTypeName: parentName, childConsumeptionTypeName: childName)
    }
}