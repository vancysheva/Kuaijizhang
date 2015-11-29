//
//  ViewModelNotifiable.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

enum ModelDataChangedType {
    case Insert
    case Delete
    case Update
    case Query
    case Replace
    case Swap(index1: Int, index2: Int)
    case Move(fromIndex: Int, toIndex: Int)
}

enum TransactionState {
    case Success
    case Failure(errorMsg: String)
}

typealias ViewModelNotificationHandler = (transactionState: TransactionState, dataChangedType: ModelDataChangedType, indexPath: NSIndexPath, userInfo: [String: Any]?) -> Void

protocol ViewModelNotifiable {
    
    func addNotification(notificationHandler: ViewModelNotificationHandler)
}