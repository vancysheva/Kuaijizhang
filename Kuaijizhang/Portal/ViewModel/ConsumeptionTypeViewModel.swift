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
    
    func parentConsumeptionTypeAtIndex(parentIndex: Int) -> (parentName: String, iconName: String) {
        
        if let parentConsumeptionType = model.objectAtIndex(parentIndex) {
            return  (parentConsumeptionType.name, parentConsumeptionType.iconName)
        }
        return ("", "")
    }
    
    func childConsumeptionTypeAtParentIndex(parentIndex: Int, withChildIndex childIndex: Int) -> (childName: String, iconName: String) {
        
        if let parentConsumpetionType = model.objectAtIndex(parentIndex) {
            if parentConsumpetionType.consumeptionTypes.count == 0 {
                return ("", "")
            } else {
                let childConsumeptionType = parentConsumpetionType.consumeptionTypes[childIndex]
                return (childConsumeptionType.name, childConsumeptionType.iconName)
            }
        }
        return ("", "")
    }
    
    func numberOfParentConsumeptionTypes() -> Int {
        return model.numberOfObjects
    }
    
    func numberOfChildConsumeptionTypesAtParentIndex(parentIndex: Int) -> Int {
        
        if model.numberOfObjects != 0 {
            return model.objectAtIndex(parentIndex)?.consumeptionTypes.count ?? 0
        }
        return 0
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
        model.updateChildConsumeptionTypeWithName(name, iconName: iconName, atParentIndex: parentIndex, withChildIndex: childIndex)
    }
    
    func updateParentConsumeptionTypeWith(name: String, iconName: String, withParentIndex parentIndex: Int) {
        model.updateParentConsumeptionTypeWith(name, iconName: iconName, withParentIndex: parentIndex)
    }
    
    func moveParentConsumeptionTypeFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        model.moveParentConsumeptionTypeFromIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
    
    func moveChildConsumeptionTypeFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath, withParentIndex parentIndex: Int) {
        model.moveChildConsumeptionTypeFromIndexPath(fromIndexPath, toIndexPath: toIndexPath, withParentIndex: parentIndex)
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
    
    func getParentConsumeptionTypeIndex(parentConsumeptionType: ConsumeptionType) -> Int? {
        return model.objectList?.indexOf(parentConsumeptionType)
    }
    
    func getChildConsumeptionTypeIndex(childConsumeptionType: ConsumeptionType, withParentConsumeptionType parentConsumeptionType: ConsumeptionType) -> Int? {
        return parentConsumeptionType.consumeptionTypes.indexOf(childConsumeptionType)
    }
}
