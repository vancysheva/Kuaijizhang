//
//  AccountBook.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//
import Foundation
import RealmSwift

class AccountBook: Object {
    
    /**
    账本名称
    */
    dynamic var title = ""
    
    /**
     * 封面图片
     **/
    dynamic var coverImageName = ""
    
    /**
    是否是同步账本，默认是本地账本
    */
    dynamic var isSync = false
    
    /**
     * 是否为当前正在使用的账本
     **/
    dynamic var isUsing = false
    
    /**
     * 创建日期
     **/
    dynamic var buildDate: NSDate?
    
    /**
     * 所含的账单
     **/
    let bills = List<Bill>()
    
    let accounts = List<Account>()
    
    let consumeptionTypes = List<ConsumeptionType>()
    
    let subjects = List<Subject>()
    
    let instalments = List<Instalment>()
}

