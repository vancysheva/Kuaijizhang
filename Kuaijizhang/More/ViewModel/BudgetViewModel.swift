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
    
    func numberOfParentConsumeptionTypes() -> Int {
        return model.numberOfObjects
    }
    
    func numberOfChildConsumeptionTypes(parentIndex index: Int) -> Int {
        return model.objectList?[index].consumeptionTypes.count ?? 0
    }
    
    func parentConsumeptionTypeAt(parentIndex index: Int) -> (iconName: String, name: String, budget: Double, surplus: Double) {
        
        if let parentComsumeptionType = model.objectAtIndex(index) {
            let cost = parentComsumeptionType.consumeptionTypes.reduce(0) {
                $0 + $1.bills.reduce(0) {
                    $0 + $1.money
                }
            }
            
            let budget = parentComsumeptionType.budget?.monthAmount ?? 0
            
            return (parentComsumeptionType.iconName, parentComsumeptionType.name, budget, budget - cost)
        }
        return ("", "", 0.0, 0.0)
    }
    
    func childConsumeptionTypeAt(childIndex: Int, withParentIndex parentIndex: Int) -> (iconName: String, name: String, budget: Double, surplus: Double) {
        
        if let parentConsumeptionType = model.objectAtIndex(parentIndex) {
            let childConsumeptionType = parentConsumeptionType.consumeptionTypes[childIndex]
            let cost = childConsumeptionType.bills.reduce(0) {
                $0 + $1.money
            }
            let budget = childConsumeptionType.budget?.monthAmount ?? 0
            
            return (childConsumeptionType.iconName, childConsumeptionType.name, budget, budget - cost)
        }
        return ("", "", 0.0, 0.0)
    }
    
    func parentConsumeptionTypeBudgetIsLessThanChildConsumeptionTypeBudget(budget: Double, atParentIndex parentIndex: Int) -> Bool {
        
        if let parentConsumeptionType = model.objectList?[parentIndex] {
            let childsBudget = parentConsumeptionType.consumeptionTypes.reduce(0.0) {
                if let b = $1.budget?.monthAmount {
                    return $0 + b
                } else {
                    return $0
                }
            }
            
            return budget < childsBudget ? true : false
        }
        return false
    }
    
    func saveParentConsumeptionTypeBudget(budget: Double, atParentIndex parentIndex: Int) {
        
        model.updateObjectWithIndex(parentIndex) {
            if self.model.objectList?[parentIndex].budget == nil {
                self.model.objectList?[parentIndex].budget = Budget(value: ["monthAmount": budget])
            } else {
                self.model.objectList?[parentIndex].budget?.monthAmount = budget
            }
        }
    }
    
    func saveChildConsumeptionTypeBudget(budget: Double, atChildIndex childIndex: Int, withParentIndex parentIndex: Int) {
        
        // 保存二级预算预算，且更新一级预算
        
        if let parentConsumeptionType = model.objectList?[parentIndex] {
            let childConsumeptionType = parentConsumeptionType.consumeptionTypes[childIndex]
            model.updateObjectWithIndex(childIndex, inSection: parentIndex) {
                if childConsumeptionType.budget == nil {
                    childConsumeptionType.budget = Budget(value: ["monthAmount": budget])
                } else {
                    childConsumeptionType.budget?.monthAmount = budget
                }
                
                
                let childsBudget = parentConsumeptionType.consumeptionTypes.reduce(0.0) {
                    if let b = $1.budget?.monthAmount {
                        return $0 + b
                    } else {
                        return $0
                    }
                }
                
                //let newChildsBudget = childsBudget - (parentConsumeptionType.consumeptionTypes[childIndex].budget?.monthAmount ?? 0) + budget
                if parentConsumeptionType.budget?.monthAmount ?? 0 < childsBudget {
                    if parentConsumeptionType.budget == nil {
                        parentConsumeptionType.budget = Budget(value: ["monthAmount": childsBudget])
                    } else {
                        parentConsumeptionType.budget?.monthAmount = childsBudget
                    }
                }
            }
        }
    }
    
    func allParentConsumeptionTypesBudget() -> Double {
        
        if let parentConsumeptionTypes = model.objectList {
            return parentConsumeptionTypes.reduce(0.0) {
                if let budget = $1.budget?.monthAmount {
                    return $0 + budget
                } else {
                    return $0
                }
            }
        }
        return 0.0
    }
    
    func allCost() -> Double {
        
        if let parentConsumeptionType = model.objectList {
            return parentConsumeptionType.reduce(0.0) {
                $0 + $1.consumeptionTypes.reduce(0.0) {
                    $0 + $1.bills.reduce(0.0) {
                        $0 + $1.money
                    }
                }
            }
        } else {
            return 0.0
        }
    }
}
