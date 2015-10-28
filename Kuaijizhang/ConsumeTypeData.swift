//
//  ConsumeType.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/20.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

struct ConsumeTypeData {
    
    private let data: NSDictionary
    
    init(billType: BillType) {
        var filename: String
        switch billType {
        case .Expense:
            filename = "ExpenseConsumeTypeList"
        case .Income:
            filename = "IncomeConsumeTypeList"
        }
        
        if let dic = NSDictionary(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "plist")!)) {
            data = dic
        } else {
            data = [String: String]()
        }
    }
    
    var parentDataList: [String] {
        
        if let d = data.allKeys as? [String] {
            return d
        }
        return []
    }
    
    func childDataListForID(parentID: String) -> [String] {
        
        if let d = data.valueForKey(parentID) as? NSDictionary {
            return d.allKeys as! [String]
        }
        return []
    }
    
    func description(indexForParentDataList: Int, indexForChildDataList: Int) -> String? {
        
        if (!parentDataList.isEmpty && indexForParentDataList < parentDataList.count) {
            let childs = childDataListForID(parentDataList[0])
            if !childs.isEmpty && indexForChildDataList < childs.count {
                return "\(parentDataList[indexForParentDataList])>\(childs[indexForChildDataList])"
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    var firstDescription: String? {
        return description(0, indexForChildDataList: 0)
    }

}
