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
        
        let startDate = DateHelper.dateFromStartDayInCurrentMonth()
        let endDate = DateHelper.dateFromEndDayInCurrentMonth()
        
        let bills = portalModel.getBills(startDate: startDate, endDate: endDate)
        
        var arr = initArrayWithCurrentMonth()
        
        bills.forEach {
            if let occurDate = $0.occurDate {
                let day = DateHelper.getDayFromDate(occurDate)
                let t = arr[day]
                arr[day] = (t.day, t.value + $0.money)
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
    
    
    
    func getLatestBill() -> (consumeptionTypeName: String?, accountName: String?, comment: String?) {
        
        let latestBill = portalModel.getLatestBill()
        return (latestBill.consumeType?.name, latestBill.account?.name, latestBill.comment)
    }
    
    
    
    func getTodayTotalExpense() -> Double {
        
        let tuple = DateHelper.getRangeDateFor(NSDate())
        let total = caculateTotalMoneyWith(tuple.startDate, endTime: tuple.endDate)

        return total
    }
    
    func getCurrentWeekExpense() -> Double {
        
        let start = DateHelper.getStartTimeForCurrentWeek()
        let end = DateHelper.getOverTimeForCurrentWeek()
        let total = caculateTotalMoneyWith(start, endTime: end)
        
        return total
    }
    
    func getCurrentMonthExpense() -> Double {
        
        let start = DateHelper.getStartTimeForCurrentMonth()
        let end = DateHelper.getOverTimeForCurrentMonth()
        let total = caculateTotalMoneyWith(start, endTime: end)
        return total
    }
    
    func getCurrentMonthIncome() -> Double {
        
        let start = DateHelper.getStartTimeForCurrentMonth()
        let end = DateHelper.getOverTimeForCurrentMonth()
        let total = caculateTotalMoneyWith(start, endTime: end, consumeptionType: 1)
        return total
    }
    
    func getCurrentYearExpense() -> Double {
        
        let start = DateHelper.getStartTimeForCurrentYear()
        let end = DateHelper.getOverTimeForCurrentYear()
        let total = caculateTotalMoneyWith(start, endTime: end)
        
        return total
    }
    
    func getCurrentYearIncome() -> Double {
        
        let start = DateHelper.getStartTimeForCurrentYear()
        let end = DateHelper.getOverTimeForCurrentYear()
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
