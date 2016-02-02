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

typealias ViewModelObserverHandler = (indexPath: NSIndexPath?, userInfo: [String: Any]?) -> Void

protocol ViewModelNotifiable {
    
    // 数据持久事件处理
    func addNotification(notificationHandler: ViewModelNotificationHandler)
    func dataContentWillChange(beginUpdates: ()->Void)
    func dataContentDidChange(endUpdates: ()->Void)
    
    // 观察者事件处理
    func addObserver(observerHandler: ViewModelObserverHandler)
}
