//
//  BudgetViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/6.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class BudgetViewModel: ViewModelBase<BudgetModel> {
    
    init() {
        super.init(model: BudgetModel())
    }
    
    func getParentConsumeptionTypeCount() -> Int {
        return model.numberOfObjects
    }
    
    func getChildConsumeptionTypeCount(parentIndex index: Int) -> Int {
        return model.objectList?[index].consumeptionTypes.count ?? 0
    }
    
    func parentConsumeptionTypeAt(parentIndex index: Int) -> (iconName: String, name: String, budget: Double, surplus: Double) {
        
        if let parentComsumeptionType = model.objectAtIndex(index) {
            let amount = parentComsumeptionType.consumeptionTypes.reduce(0) {
                $0 + $1.bills.reduce(0) {
                    $0 + $1.money
                }
            }
            return (parentComsumeptionType.iconName, parentComsumeptionType.name, parentComsumeptionType.budget?.monthAmount ?? 0, parentComsumeptionType.budget?.monthAmount ?? 0 - amount)
        }
        return ("", "", 0.0, 0.0)
    }
    
    func childConsumeptionTypeAt(childIndex: Int, withParentIndex parentIndex: Int) -> (iconName: String, name: String, budget: Double, surplus: Double) {
        
        if let parentConsumeptionType = model.objectAtIndex(parentIndex) {
            let childConsumeptionType = parentConsumeptionType.consumeptionTypes[childIndex]
            let amount = childConsumeptionType.bills.reduce(0) {
                $0 + $1.money
            }
            return (childConsumeptionType.iconName, childConsumeptionType.name, childConsumeptionType.budget?.monthAmount ?? 0, childConsumeptionType.budget?.monthAmount ?? 0 - amount)
        }
        return ("", "", 0.0, 0.0)
    }
}
