//
//  LabelTableViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class LabelTableViewModel {
    
    let labelTableModel: LabelTableModel
    
    init() {
        self.labelTableModel = LabelTableModel()
    }
    
    func getCount() -> Int {
        if let count = self.labelTableModel.objectList?.count {
            return count
        }
        return 0
    }
    
    func objectAt(indexPath: NSIndexPath) -> String? {
        return labelTableModel.objectAt(indexPath)?.name
    }
    
    func saveObject(name: String) {
        labelTableModel.addObjectWith(name)
    }
    
    func subjectIsExist(name: String) -> Bool {
        return labelTableModel.subjectIsExist(name)
    }
    
}

extension LabelTableViewModel: ViewModelNotifiable {
    
    func addNotification(notificationHandler: ViewModelNotificationHandler) {
        labelTableModel.notificationHandler = notificationHandler
    }
}