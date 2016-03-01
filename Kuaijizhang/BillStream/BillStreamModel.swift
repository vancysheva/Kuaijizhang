//
//  BillStreamModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/1/16.
//  Copyright © 2016年 范伟. All rights reserved.
//

import Foundation

class BillStreamModel: RealmModel<Bill> {
    
    init(startTime: NSDate, endTime: NSDate) {
        super.init()
        objectList = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first?.bills.filter("occurDate BETWEEN %@", [startTime, endTime]).sorted("occurDate", ascending: false).toList()
        
    }
    
    func refreshData(startTime: NSDate, _ endTime: NSDate) {
        objectList = System.getCurrentUser()?.accountBooks.filter("isUsing = true").first?.bills.filter("occurDate BETWEEN %@", [startTime, endTime]).sorted("occurDate", ascending: false).toList()
    }
    
    func getIncome() -> [Bill] {
        return objectList?.filter { return $0.consumeType?.type ?? "1" == "1" } ?? []
    }
    
    func getExpense() -> [Bill] {
        return objectList?.filter { return $0.consumeType?.type ?? "0" == "0" } ?? []
    }
    
    let calendar = NSCalendar.currentCalendar()
    
    func getBillsWithMonth(month: Int) -> [Bill] {
        
        if let list = objectList {
            return list.filter {
                if let date = $0.occurDate {
                    let comp = self.calendar.components(.Month, fromDate: date)
                    return  comp.month == month
                }
                return false
            }
        }
        return []
    }
}