    //
//  PortalViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class PortalViewModel {
    
    let portalModel: PortalModel
    

    init() {
        self.portalModel = PortalModel()
    }
    
    
    
    func getCurrentAccountBookTitle() -> String {
        return portalModel.getCurrentAccountBookTitle()
    }
    
    
    
    func getChartDataByCurrentMonth() -> [(day: String, value: Double)] {
        
        let startDate = DateHelper.getStartTimeFromCurrentMonth()
        let endDate = DateHelper.getOverTimeFromCurrentMonth()
        
        let bills = portalModel.getBills(startDate: startDate, endDate: endDate)
        
        var arr = initArrayWithCurrentMonth()
        
        bills.forEach {
            if let occurDate = $0.occurDate {
                let day = DateHelper.getDayFromDate(occurDate)
                let t = arr[day-1]
                if let type = $0.consumeType?.type where Int(type) == BillType.Expense.rawValue {
                    arr[day-1] = (t.day, t.value + $0.money)
                }
            }
        }
        
        return arr
    }
    
    
    
    func initArrayWithCurrentMonth() -> [(day: String, value: Double)] {
        
        var arr = [(day: String, value: Double)]()
        let currentDayRange = DateHelper.getRangeOfCurrentMonth()
        for day in currentDayRange.location...currentDayRange.length {
            arr.append(("\(day)", 0.0))
        }
    
        return arr
    }
    
    
    
    func getLatestBill() -> (consumeptionTypeName: String, money: String, comment: String?) {
        
        let latestBill = portalModel.getLatestBill()
        return (latestBill.consumeType?.subConsumeptionType?.name ?? "", String(latestBill.money), latestBill.comment)
    }
    
    
    
    func getTodayTotalExpense() -> Double {
        
        let tuple = DateHelper.getRangeTimeFrom(NSDate())
        let total = caculateTotalMoneyWith(tuple.startDate, endTime: tuple.endDate)

        return total
    }
    
    func getCurrentWeekExpense() -> Double {
        
        let start = DateHelper.getStartTimeFromCurrentWeek()
        let end = DateHelper.getOverTimeFromCurrentWeek()
        let total = caculateTotalMoneyWith(start, endTime: end)
        
        return total
    }
    
    func getCurrentMonthExpense() -> Double {
        
        let start = DateHelper.getStartTimeFromCurrentMonth()
        let end = DateHelper.getOverTimeFromCurrentMonth()
        let total = caculateTotalMoneyWith(start, endTime: end)
        return total
    }
    
    func getCurrentMonthIncome() -> Double {
        
        let start = DateHelper.getStartTimeFromCurrentMonth()
        let end = DateHelper.getOverTimeFromCurrentMonth()
        let total = caculateTotalMoneyWith(start, endTime: end, consumeptionType: 1)
        return total
    }
    
    func getCurrentYearExpense() -> Double {
        
        let start = DateHelper.getStartTimeFromCurrentYear()
        let end = DateHelper.getOverTimeFromCurrentYear()
        let total = caculateTotalMoneyWith(start, endTime: end)
        
        return total
    }
    
    func getCurrentYearIncome() -> Double {
        
        let start = DateHelper.getStartTimeFromCurrentYear()
        let end = DateHelper.getOverTimeFromCurrentYear()
        let total = caculateTotalMoneyWith(start, endTime: end, consumeptionType:  1)
        return total
    }
    
    func caculateTotalMoneyWith(startTime: NSDate, endTime: NSDate, consumeptionType type: Int = 0) -> Double {
        
        let bills = portalModel.getBills(startDate: startTime, endDate: endTime, consumeptionType: type)
        var total: Double = 0
        bills.forEach {
            total += $0.money
        }
        
        return total
    }
}
