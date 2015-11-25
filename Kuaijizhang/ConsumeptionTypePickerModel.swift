//
//  ConsumpetionTypePickerModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class ConsumeptionTypePickerModel: RealmModel<ConsumeptionType> {
    
    var currentAccountBook: AccountBook?
    
    var results: Results<ConsumeptionType>?
    
    init(billType: Int) {
        super.init()
        results = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first?.consumeptionTypes.filter("type = %@", "\(billType)")
    }
    
    func parentConsumeptionTypeAt(index: Int) -> ConsumeptionType? {
        return results?[index]
    }
    
    func childConsumeptionTypeAt(parentConsumeptionTypeName name: String, index: Int) -> ConsumeptionType? {
        return results?.filter("name = %@", name).first?.consumeptionTypes[index]
    }
    
    func getParentConsumeptionTypeCount() -> Int {
        return results?.count ?? 0
    }
    
    func getChildConsumeptionTypeCount(parentConsumeptionTypeName name: String) -> Int {
        return results?.filter("name = %@", name).first?.consumeptionTypes.count ?? 0
    }
}