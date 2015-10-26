//
//  Bill.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import MapKit

protocol Bill: Statisticable {
    
    /**
     * 所属账户
     **/
    var account: Account { get set }
    
    /**
     * 账单类型 支出或者收入等
     **/
    var billType: BillType { get }
    
    /**
     * 消费类型 具体属账单类别的子类
     **/
    var consumeType: ConsumeptionType { get set }
    
    /**
     * 所属账本
     **/
    var accountBook: AccountBook { get }
    
    /**
     * 拍摄的图片
     **/
    var image: UIImage? { get set }
    
    /**
     * 发生日期
     **/
    var occurDate: NSDate { get set }
    
    var occurPlace: CLLocation { get }
}