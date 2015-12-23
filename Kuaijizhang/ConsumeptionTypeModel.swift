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
    
    let billType: Int
    var currentAccountBook: AccountBook?
    
    init(billType: Int) {
        self.billType = billType
        self.currentAccountBook = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first
        super.init()
        objectList = self.currentAccountBook?.consumeptionTypes.filter("type = %@", "\(billType)").toList()
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
    
    func saveParentConsumeptionTypeWithName(name: String, type: String, iconName: String) {
        
        if let lastConsumeptionType = lastObject, index  = currentAccountBook?.consumeptionTypes.indexOf(lastConsumeptionType) {
            
            let consumeptionType = ConsumeptionType()
            consumeptionType.name = name
            consumeptionType.type = type
            consumeptionType.iconName = iconName
            if let book = currentAccountBook {
                consumeptionType.accountBook = book
            }
            
            let state = realm.writeTransaction {
                self.currentAccountBook?.consumeptionTypes.insert(consumeptionType, atIndex: index + 1)
            }
            
            objectList = currentAccountBook?.consumeptionTypes.filter("type = %@", "\(billType)").toList()
            let indexPath = NSIndexPath(forRow: (objectList?.count ?? 1) - 1, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: ["save": "saveParent"])
        }
    }
    
    func saveChildConsumeptionTypeWithName(name: String, type: String, iconName: String, withParentIndex parentIndex: Int) {
        
        let consumeptionType = ConsumeptionType()
        consumeptionType.name = name
        consumeptionType.type = type
        consumeptionType.iconName = iconName
        if let book = currentAccountBook {
            consumeptionType.accountBook = book
        }
        if let parentConsumeptionType = objectList?[parentIndex] {
            appendObject(consumeptionType, inList: parentConsumeptionType.consumeptionTypes, inSection: 0, userInfo: ["save": "saveChild"])
        }
    }
    
    func deleteParentConsumeptionTypeAt(parentIndex: Int) {
        //删除二级类别以及其账单，并删除一级类别
        if let parentConsumeptionType = objectList?[parentIndex] {
            deleteObjectWithIndex(parentIndex, inSection: 0, userInfo: ["delete": "deleteParent"]) {
                parentConsumeptionType.consumeptionTypes.forEach {
                    self.realm.delete($0.bills)
                }
                self.realm.delete(parentConsumeptionType.consumeptionTypes)
                self.realm.delete(parentConsumeptionType)
                //self.objectList?.removeLast()
                self.objectList = self.currentAccountBook?.consumeptionTypes.filter("type = %@", "\(self.billType)").toList()
            }
        }
    }
    
    func deleteChildConsumeptionTypeAt(childIndex: Int, withParentIndex parentIndex: Int) {
        // 删除指定的二级类别及账单
        if let parentConsumeptionType = objectList?[parentIndex] {
            let childConsumeptionType = parentConsumeptionType.consumeptionTypes[childIndex]
            deleteObjectWithIndex(childIndex, inSection: 0, userInfo: ["delete": "deleteChild"]) {
                self.realm.delete(childConsumeptionType.bills)
                self.realm.delete(childConsumeptionType)
            }
        }
    }
    
    func moveParentConsumeptionTypeFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        // objectList是通过查询结果Reslut的toList方法获得，通过对objectList对象进行各种操作并不会影响到数据库中的对象，
        // 所以要objectList中和数据库中的数据进行操作.
        if let list = objectList, result = currentAccountBook?.consumeptionTypes {
            list.move(from: fromIndexPath.row, to: toIndexPath.row)
            
            let fromObj = list[fromIndexPath.row]
            let toObj = list[toIndexPath.row]
            let fromIndex = result.indexOf(fromObj)
            let toIndex = result.indexOf(toObj)
            
            let state = realm.writeTransaction {
                result.move(from: fromIndex!, to: toIndex!)
            }
            sendNotificationsFeedBack(state, changedType: .Move(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row), indexPath: fromIndexPath, userInfo: ["move": "moveParent"])
        }
    }
}