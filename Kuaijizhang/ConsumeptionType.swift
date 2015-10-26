//
//  ConsumeptionType.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol ConsumeptionType: Statisticable {
    
    /**
     * 所属父类别
     **/
    var parentType: ConsumeptionType? { get }
}