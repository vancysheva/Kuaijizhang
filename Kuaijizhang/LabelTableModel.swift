//
//  LabelTableModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class LabelTableModel: RealmModel<Subject> {
    
    override init() {
        super.init()
        objectList = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first?.subjects
    }
    
    func objectAt(indexPath: NSIndexPath) -> Subject? {
        return objectList?[indexPath.row]
    }
    
    func addObjectWith(name: String) {
        
        let subject = Subject()
        subject.name = name
        
        let state = realm.writeTransaction {
            self.objectList?.insert(subject, atIndex: 0)
        }
        
        notificationHandler?(transactionState: state, dataChangedType: .Insert, indexPath: NSIndexPath(forRow: (objectList?.count ?? 1)-1, inSection: 0))
    }
    
    func subjectIsExist(name: String) -> Bool {
        
        let count = objectList?.filter("name = %@", name).count
        return count < 1 ? false : true
    }
}
