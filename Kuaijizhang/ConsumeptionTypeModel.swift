//
//  ConsumpetionTypePickerModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class ConsumeptionTypeModel: RealmModel<ConsumeptionType> {
    
    
    init(billType: Int) {
        super.init()
        objectList = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first?.consumeptionTypes.filter("type = %@", "\(billType)").toList()
    }
    
    func parentConsumeptionTypeAtIndex(index: Int) -> ConsumeptionType? {
        return objectAtIndex(index)
    }
    
    func childConsumeptionTypeAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) -> ConsumeptionType? {
        return objectAtIndex(parentIndex)?.consumeptionTypes[childIndex]
    }
    
    func numberOfChildConsumeptionTypesAtParentIndex(parentIndex: Int) -> Int {
        return objectAtIndex(parentIndex)?.consumeptionTypes.count ?? 0
    }
    
    func childConsumeptionType(indexPath: NSIndexPath) -> ConsumeptionType? {
        return objectAtIndex(indexPath.section)?.consumeptionTypes[indexPath.row]
    }
    
    func deleteChildConsumeptionTypeAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let childConsumeptionType = parentConsumeptionTypeAtIndex(parentIndex)?.consumeptionTypes[childIndex] {
            delete(childConsumeptionType, indexPath: NSIndexPath(forRow: childIndex, inSection: parentIndex))
        }
    }
    
    func saveParentConsumeptionTypeWithName(name: String, type: String, iconName: String) {
        
        let consumeptionType = ConsumeptionType()
        consumeptionType.name = name
        consumeptionType.type = type
        consumeptionType.iconName = iconName
        if let book = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first {
            consumeptionType.accountBook = book
        }
        appendObject(consumeptionType)
    }
    
    func saveChildConsumeptionTypeWithName(name: String, type: String, iconName: String, withParentIndex parentIndex: Int) {
        
        let consumeptionType = ConsumeptionType()
        consumeptionType.name = name
        consumeptionType.type = type
        consumeptionType.iconName = iconName
        if let book = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first {
            consumeptionType.accountBook = book
        }
        if let parentConsumeptionType = objectList?[parentIndex] {
            appendObject(consumeptionType, inList: parentConsumeptionType.consumeptionTypes)
        }
    }
    
    func updateConsumeptionTypeAtParentIndexWithName(name: String, widthParentIndex parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let childConsumeptionType = childConsumeptionTypeAtParentIndex(parentIndex, withChildIndex: childIndex) {
            updateObjectWithIndex(childIndex, inSection: parentIndex, userInfo: nil) {
                childConsumeptionType.name = name
            }
        }
    }
    
    func deleteParentConsumeptionTypeAt(parentIndex: Int) {
        //删除二级类别以及其账单，并删除一级类别
        if let parentConsumeptionType = objectList?[parentIndex] {
            let state = realm.writeTransaction {
                parentConsumeptionType.consumeptionTypes.forEach {
                    self.realm.delete($0.bills)
                }
                self.realm.delete(parentConsumeptionType.consumeptionTypes)
                self.realm.delete(parentConsumeptionType)
            }
            let indexPath = NSIndexPath(forRow: parentIndex, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
    
    func deleteChildConsumeptionTypeAt(childIndex: Int, withParentIndex parentIndex: Int) {
        // 删除指定的二级类别及账单
        if let parentConsumeptionType = objectList?[parentIndex] {
            let childConsumeptionType = parentConsumeptionType.consumeptionTypes[childIndex]
            let state = realm.writeTransaction {
                self.realm.delete(childConsumeptionType.bills)
                self.realm.delete(childConsumeptionType)
            }
            let indexPath = NSIndexPath(forRow: childIndex, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
}