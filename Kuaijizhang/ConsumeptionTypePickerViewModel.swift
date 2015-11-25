//
//  ConsumeptionTypePickerViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class ConsumeptionTypePickerViewModel {
    
    let consumeptionTypePickerModel: ConsumeptionTypePickerModel
    
    init(billType: BillType) {
        self.consumeptionTypePickerModel = ConsumeptionTypePickerModel(billType: billType.rawValue)
    }
    
    func parentConsumeptionTypeAt(index: Int) -> String? {
        
        return consumeptionTypePickerModel.parentConsumeptionTypeAt(index)?.name
    }
    
    func childConsumeptionTypeAt(parentConsumeptionTypeName name: String, index: Int) -> String? {
        
        return consumeptionTypePickerModel.childConsumeptionTypeAt(parentConsumeptionTypeName: name, index: index)?.name
    }
    
    func getParentConsumeptionTypeCount() -> Int {
        
        return consumeptionTypePickerModel.getParentConsumeptionTypeCount()
    }
    
    func getChildConsumeptionTypeCount(consumeptionTypeName name: String) -> Int {
        
        return consumeptionTypePickerModel.getChildConsumeptionTypeCount(parentConsumeptionTypeName: name)
    }
}
