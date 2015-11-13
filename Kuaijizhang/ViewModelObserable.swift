//
//  ViewModelObserable.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

public enum ModelDataChangedType {
    case Insert, Delete, Update, Query
}

typealias ViewModelNotificationBlock = (dataChangedtype: ModelDataChangedType, indexPath: NSIndexPath) -> Void

protocol ViewModelObservable {
    
    func addObserver(notificationHandler: ViewModelNotificationBlock)
}