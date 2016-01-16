//
//  BillStreamViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class BillStreamViewModel: ViewModelBase<BillStreamModel> {
    
    init() {
        super.init(model: BillStreamModel())
    }
    
    typealias bill = (date: Int, money: Double, type: BillType, label: String, consumeName: String, comment: String)
    typealias bills = [bill]
    typealias month = Int
    
    var data = [month : bills]()
    
    
    
    func getIncome() -> Double {
        let startTime = DateHelper.getStartTimeForCurrentYear()
        let endTime = DateHelper.getOverTimeForCurrentYear()
        let bills = model.getIncome(startTime, endDate: endTime)
        
        return bills.reduce(0) {
            return $0 + $1.money
        }
    }
    
    func getExpense() -> Double {
        let startTime = DateHelper.getStartTimeForCurrentYear()
        let endTime = DateHelper.getOverTimeForCurrentYear()
        let bills = model.getExpense(startTime, endDate: endTime)
        
        return bills.reduce(0) {
            return $0 + $1.money
        }
    }
    
    func getBillCountForMonth(month: Int) -> Int {
        return model.getBillsWithMonth(month).count
    }
    
    func getHeaderDataWithMonth(month: Int) -> (month: Int, inconme: Double, expense: Double, surplus: Double) {
        
        let bills = model.getBillsWithMonth(month)
        
        let expense = bills.reduce(0) {
            return $1.consumeType?.type ?? "0" == "0" ? ($0 + $1.money) : $0
        }
        
        let income = bills.reduce(0) {
            return $1.consumeType?.type ?? "1" == "1" ? ($0 + $1.money) : $0
        }

        return (month, income, expense, income-expense)
    }
    
    let calendar = NSCalendar.currentCalendar()
    
    func getBillAtIndex(row: Int, withMonth section: Int) -> (day: Int, money: Double, consumeName: String, iconName: String, conmment: String, billType: BillType, week: String) {
        
        let bill = model.getBillsWithMonth(section)[row]
        let day = calendar.components(.Day, fromDate: bill.occurDate ?? NSDate()).day
        return (day, bill.money, bill.consumeType?.subConsumeptionType?.name ?? "", bill.consumeType?.subConsumeptionType?.iconName ?? "", bill.comment ?? "", bill.consumeType?.subConsumeptionType?.type ?? "0" == "0" ? .Expense : .Income, DateHelper.weekFromDate(bill.occurDate ?? NSDate()))
    }
}
