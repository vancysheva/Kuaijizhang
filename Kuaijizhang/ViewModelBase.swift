
//
//  ViewModelBase.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/29.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class ViewModelBase<T: ModelBase>: ViewModelNotifiable {
    
    let model: T
    
    init(model: T) {
        self.model = model
    }
    
    func addNotification(notificationHandler: ViewModelNotificationHandler) {
        model.notificationHandlers.append(notificationHandler)
    }
    
    func dataContentWillChange(beginUpdates: () -> Void) {
        model.beginUpdates = beginUpdates
    }
    
    func dataContentDidChange(endUpdates: () -> Void) {
        model.endUpdates = endUpdates
    }
}