//
//  ViewModelNotifiable.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

enum ModelDataChangedType {
    case Insert, Delete, Update, Query
}

enum TransactionState {
    case Success
    case Failure(errorMsg: String)
}

typealias ViewModelNotificationHandler = (transactionState: TransactionState, dataChangedType: ModelDataChangedType, indexPath: NSIndexPath) -> Void

protocol ViewModelNotifiable {
    
    func addNotification(notificationHandler: ViewModelNotificationHandler)
}