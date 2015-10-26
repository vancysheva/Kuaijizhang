//
//  AccountBook.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol AccountBook: Statisticable {
    
    /**
     * 所含的账单
     **/
    var bills: [Bill] { get set }
    
    /**
     * 账本类型
     **/
    var bookType: (id: Int, name: String) { get set }
    
    /**
     * 创建日期
     **/
    var buildDate: NSDate { get }
    
    
    /**
     * 封面图片
     **/
    var cover: UIImage { get set }
    
    /**
     * 是否同步
     **/
    var isSync: Bool { get set }
    
    /**
     * 是否为当前正在使用的账本
     **/
    var isUsing: Bool { get set }
}

