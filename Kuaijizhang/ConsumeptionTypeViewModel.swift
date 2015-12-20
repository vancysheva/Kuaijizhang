//
//  ConsumeptionTypePickerViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class ConsumeptionTypeViewModel: ViewModelBase<ConsumeptionTypeModel> {
    
    let billType: BillType
    
    init(billType: BillType) {
        self.billType = billType
        super.init(model: ConsumeptionTypeModel(billType: billType.rawValue))
    }
    
    func parentConsumeptionTypeAtIndex(parentIndex: Int) -> (parentName: String?, iconName: String?) {
        
        if let parentConsumeptionType = model.parentConsumeptionTypeAtIndex(parentIndex) {
            return  (parentConsumeptionType.name, parentConsumeptionType.iconName)
        }
        return (nil, nil)
    }
    
    func childConsumeptionTypeAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) -> (childName: String?, iconName: String?) {
        
        if let childConsumeptionType = model.childConsumeptionTypeAtParentIndex(parentIndex, withChildIndex: childIndex) {
            return (childConsumeptionType.name, childConsumeptionType.iconName)
        }
        return (nil, nil)
    }
    
    func numberOfParentConsumeptionTypes() -> Int {
        return model.numberOfObjects
    }
    
    func numberOfChildConsumeptionTypesAtParentIndex(parentIndex: Int) -> Int {
        return model.numberOfChildConsumeptionTypesAtParentIndex(parentIndex)
    }
    
    func deleteChildConsumeptionTypeAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) {
        model.deleteChildConsumeptionTypeAtParentIndex(parentIndex, withChildIndex: childIndex)
    }
    
    func deleteParentConsumeptionTypeAt(parentIndex: Int) {
        model.deleteParentConsumeptionTypeAt(parentIndex)
    }
    
    func deleteChildConsumeptionTypeAt(childIndex: Int, withParentIndex parentIndex: Int) {
        // 删除指定的二级类别及账单
        model.deleteChildConsumeptionTypeAt(childIndex, withParentIndex: parentIndex)
    }
    
    func saveParentConsumeptionTypeName(name: String, iconName: String) {
        model.saveParentConsumeptionTypeWithName(name, type: "\(billType.rawValue)", iconName: iconName)
    }
    
    func saveChildConsumeptionTypeWithName(name: String, iconName: String, withParentIndex parentIndex: Int) {
        model.saveChildConsumeptionTypeWithName(name, type: "\(billType.rawValue)", iconName: iconName, withParentIndex: parentIndex)
    }
    
    func updateChildConsumeptionTypeWithName(name: String, iconName: String, atParentIndex parentIndex: Int, withChildIndex childIndex: Int) {
        
        if let childConsumeptionType = model.objectAtIndex(parentIndex)?.consumeptionTypes[childIndex] {
            model.updateObjectWithIndex(childIndex, inSection: parentIndex) { () -> Void in
                childConsumeptionType.name = name
                childConsumeptionType.iconName = iconName
            }
        }
    }
    
    func updateParentConsumeptionTypeWith(name: String, iconName: String, withParentIndex parentIndex: Int) {
        
        if let parentConsumeptionType = model.objectList?[parentIndex] {
            model.updateObjectWithIndex(parentIndex) {
                parentConsumeptionType.name = name
                parentConsumeptionType.iconName = iconName
            }
        }
    }
    
    func moveoObjectFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        model.moveObjectFromIndex(fromIndexPath.row, toIndex: toIndexPath.row, inSection: 0, userInfo: nil)
    }
    
    func parentConsumeptionTypeHasChildConsumeptionTypes(parentIndex: Int) -> Bool {
        return (model.objectList?[parentIndex].consumeptionTypes.count ?? 0) > 0 ? true : false
    }
    
    func parentConsumeptionTypeHasBillsInChildConsumeptionType(parentIndex: Int) -> Bool {
        
        let billCount = model.objectList?[parentIndex].consumeptionTypes.reduce(0) {
            $0 + $1.bills.count
        }
        return billCount > 0
    }
    
    func childConsumeptionTypeHasBills(childIndex: Int, withParentIndex parentIndex: Int) -> Bool {
        
        if let childConsumeptionType = model.objectList?[parentIndex].consumeptionTypes[childIndex] {
            return childConsumeptionType.bills.count > 0
        }
        return false
    }
}
