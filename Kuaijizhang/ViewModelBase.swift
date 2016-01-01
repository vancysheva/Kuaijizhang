
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

        model.notificationIdentifiers.append(NSUUID().UUIDString)
        model.notificationHandlers.append(notificationHandler)
    }
    
    func addNotification(identifier: String, notificationHandler: ViewModelNotificationHandler) {
        
        if let index = model.notificationIdentifiers.indexOf(identifier) {
            model.notificationHandlers[index] = notificationHandler
        } else {
            model.notificationIdentifiers.append(identifier)
            model.notificationHandlers.append(notificationHandler)
        }
    }
    
    func dataContentWillChange(beginUpdates: () -> Void) {
        model.beginUpdates = beginUpdates
    }
    
    func dataContentDidChange(endUpdates: () -> Void) {
        model.endUpdates = endUpdates
    }
    
    func addObserver(observerHandler: ViewModelObserverHandler) {
        model.observerIdentifiers.append(NSUUID().UUIDString)
        model.observerHandlers.append(observerHandler)
    }
    
    func addObserver(identifier: String, observerHandler: ViewModelObserverHandler) {
        
        if let index = model.observerIdentifiers.indexOf(identifier) {
            model.observerHandlers[index] = observerHandler
        } else {
            model.observerIdentifiers.append(identifier)
            model.observerHandlers.append(observerHandler)
        }
    }
}