//
//  AccountBookModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/10.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class AccountBookModel: RealmModel<AccountBook> {

    override init() {
        super.init()
        let user = System.getCurrentUser()
        objectList = user?.accountBooks
    }
    
    func getCount() -> Int {
        return objectList?.count ?? 0
    }

    func deleteAt(indexPath: NSIndexPath) {
        let state = realm.writeTransaction { [unowned self] in
            self.objectList?.removeAtIndex(indexPath.row)
        }
        notificationHandler?(transactionState: state, dataChangedType: .Delete, indexPath: indexPath)
    }

    func objectAt(indexPath: NSIndexPath) -> AccountBook? {
        return objectList?[indexPath.row]
    }

    func setCurrentUsingAt(indexPath: NSIndexPath) {
        
        realm.writeTransaction {
            self.objectList?.forEach {
                $0.isUsing = false
            }
            self.objectList?[indexPath.row].isUsing = true
        }
    }
    
    func addAccountBookWithTitle(title: String, coverImageName: String) {

        if let defaultAccountBook = System.getDefaultAccountBook() {
            defaultAccountBook.title = title
            defaultAccountBook.coverImageName = coverImageName
            let state = realm.writeTransaction {
                self.objectList?.forEach {
                    $0.isUsing = false
                }
                self.objectList?.append(defaultAccountBook)
            }
            notificationHandler?(transactionState: state, dataChangedType: .Insert, indexPath: NSIndexPath(forRow: (objectList?.count ?? 1)-1, inSection: 0))
        }
    }
}