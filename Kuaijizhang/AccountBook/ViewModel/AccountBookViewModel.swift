//
//  AccountBookData.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AccountBookViewModel: ViewModelBase<AccountBookModel> {
    
    init() {
        super.init(model: AccountBookModel())
    }
    
    func getCount() -> Int {
        return model.numberOfObjects
    }

    func delete(indexPath: NSIndexPath) {
        model.deleteAt(indexPath)
    }
    
    func objectAt(indexPath: NSIndexPath) -> (title: String, isUsing: Bool, coverImageName: String) {
        
        if let accountBook = model.objectAtIndex(indexPath.row) {
            return (accountBook.title, accountBook.isUsing, accountBook.coverImageName)
        }
        return ("", false, "")
    }
    
    func setCurrentUsingAt(indexPath: NSIndexPath) {
        model.setCurrentUsingAt(indexPath)
    }
    
    func saveAccountBookWithTitle(title: String, coverImageName: String) {
        
        let str = title.trim()
        model.addAccountBookWithTitle(str, coverImageName: coverImageName)
    }
    
    func updateAccountBookWithTitle(title: String, coverImageName: String, atIndex index: Int) {
        
        if let accountBook = model.objectAtIndex(index) {
            model.updateObjectWithIndex(index) {
                accountBook.title = title
                accountBook.coverImageName = coverImageName
            }
        }
    }
}