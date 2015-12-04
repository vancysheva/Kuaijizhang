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
    
    func addObjectWith(name: String) {
        
        let subject = Subject()
        subject.name = name
        
        insertObject(subject, atIndex: 0)
    }
    
    func subjectIsExist(name: String) -> Bool {
        
        let count = objectList?.filter("name = %@", name).count
        return count < 1 ? false : true
    }
}
