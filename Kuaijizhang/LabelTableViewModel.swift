//
//  LabelTableViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class LabelTableViewModel: ViewModelBase<LabelTableModel> {
    
    init() {
        super.init(model: LabelTableModel())
    }
    
    func getCount() -> Int {
        return model.numberOfObjects
    }
    
    func objectAt(indexPath: NSIndexPath) -> (labelName: String?, amount: Double?) {
        
        let label = model.objectAtIndex(indexPath.row)
        return (label?.name, label?.bills.reduce(0) { return $0! + $1.money })
    }
    
    func saveObject(name: String) {
        model.addObjectWith(name)
    }
    
    func subjectIsExist(name: String) -> Bool {
        return model.subjectIsExist(name)
    }
    
    func deleteObject(indexPath: NSIndexPath) {
        model.deleteObjecctAtIndex(indexPath.row)
    }
    
    func moveoObjectFromIndexPath(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        model.moveObjectFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
    }
    
    func updateObjectWithName(name: String, indexPath: NSIndexPath) {
        
        if let obj = model.objectAtIndex(indexPath.row) {
            model.updateObjectWithIndex(indexPath.row, inSection: indexPath.section, handler: { () -> Void in
                obj.name = name
            })
        }
    }
    
}
