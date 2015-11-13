//
//  AccountBookData.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AccountBookViewModel {
    
    let accountBookModel: AccountBookModel
    
    init() {
        accountBookModel = AccountBookModel()
    }
    
    func getCount() -> Int {
        return accountBookModel.getCount()
    }

    func delete(indexPath: NSIndexPath) {
        accountBookModel.deleteAt(indexPath)
    }
    
    func objectAt(indexPath: NSIndexPath) -> (String?, Bool?, String?) {
        
        let accountBook = accountBookModel.objectAt(indexPath)
        return (accountBook?.title, accountBook?.isUsing, accountBook?.coverImageName)
    }
    
    func setCurrentUsingAt(indexPath: NSIndexPath) {
        accountBookModel.setCurrentUsingAt(indexPath)
    }
    
    func saveAccountBookWithTitle(title: String, coverImageName: String) {
        
        let str = title.trim()
        accountBookModel.addAccountBookWithTitle(str, coverImageName: coverImageName)
    }
}

// MARK:; - Obserable

extension AccountBookViewModel: ViewModelNotifiable {
    
    func addNotification(notificationHandler: ViewModelNotificationHandler) {
        accountBookModel.notificationHandler = notificationHandler

    }
}