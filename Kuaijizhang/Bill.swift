//
//  Bill.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class Bill: Object {
    
    dynamic var money = 0.00
    
    /**
    所属账本
    */
    dynamic var accountBook: AccountBook?
    
    /**
     * 所属账户
     **/
    dynamic var account: Account?
    
    /**
     * 消费类型 具体属账单类别的子类
     **/
    dynamic var consumeType: ConsumeptionType?
    
    /**
    所属专题
    */
    dynamic var subject: Subject?
    
    /**
     所属分期账单
    */
    dynamic var instalment: Instalment?
    
    /**
     * 拍摄的图片
     **/
    dynamic var image: NSData?
    
    /**
     * 注释说明
     **/
    dynamic var comment: String?
    
    /**
     * 发生日期
     **/
    dynamic var occurDate: NSDate?
    
    dynamic var occurPlace: String? = nil
    
    override static func indexedProperties() -> [String] {
        return ["occurDate"]
    }
}