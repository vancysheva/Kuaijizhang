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
        
        //notificationIdentifiers = []
        //notificationHandlers = []
    }
}