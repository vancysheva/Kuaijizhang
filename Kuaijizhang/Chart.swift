//
//  Chart.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/21.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

protocol Chart: Statisticable {
    
    /**
     * 图表类别
     **/
    var chartType: (id: Int, name: String) { get set }
    
    /**
     * 数据
     **/
    var data: Statisticable { get }
}