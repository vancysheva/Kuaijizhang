//
//  ModelBase.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/29.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class ModelBase {
    
    var notificationIdentifiers = [String]()
    var notificationHandlers = [ViewModelNotificationHandler]()
    var beginUpdates: (()->Void)?
    var endUpdates: (()->Void)?
    
    func sendNotificationsFeedBack(state: TransactionState, changedType: ModelDataChangedType, indexPath: NSIndexPath, userInfo: [String: Any]?) {
        
        notificationHandlers.reverse().forEach {
            $0(transactionState: state, dataChangedType: changedType, indexPath: indexPath, userInfo: userInfo)
        }
    }
    
    var observerIdentifiers = [String]()
    var observerHandlers = [ViewModelObserverHandler]()
    
    func sendObserverFeedBack(indexPath: NSIndexPath?, userInfo: [String: Any]? = nil) {
        
        observerHandlers.reverse().forEach {
            $0(indexPath: indexPath, userInfo: userInfo)
        }
    }
}