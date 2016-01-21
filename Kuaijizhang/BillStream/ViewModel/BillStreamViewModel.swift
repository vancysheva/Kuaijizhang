//
//  BillStreamViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class BillStreamViewModel: ViewModelBase<BillStreamModel> {
    
    var hideMonths: [Int: Bool] = [:]
    
    var monthsOfHavingBills: [Int] = []
    
    var monthCount: Int = 0
    
    init() {
        super.init(model: BillStreamModel())
        
        monthsOfHavingBills = model.getMonthsWhichHasBills()
        
        for month in monthsOfHavingBills {
            hideMonths[month] = Int(DateHelper.getCurrentMonth()) == month ? false : true
        }
        
        monthCount = monthsOfHavingBills.count
        
    }
    
    func toggleBillsHiddenInMonth(month: Int) {
        if let isHidden = hideMonths[month] {
            hideMonths.updateValue(!isHidden, forKey: month)
        }
    }
    
    func getExpandMonth() -> Int? {
        let expandMonths = hideMonths.filter { return $0.1 == false }
        return expandMonths.count == 0 ? nil : expandMonths[0].0
    }
    
    func getBillCountForMonth(month: Int) -> Int {
        return hideMonths[month]! ? 0 : model.getBillsWithMonth(month).count
    }
    
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
    
    func getHeaderDataWithMonth(month: Int) -> (month: Int, income: Double, expense: Double, surplus: Double) {
        
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
    
    func getBillAtIndex(billIndex index: Int, withMonth month: Int) -> (day: Int, money: Double, consumeName: String, iconName: String, conmment: String, billType: BillType, week: String) {
        
        let bill = model.getBillsWithMonth(month)[index]
        let day = calendar.components(.Day, fromDate: bill.occurDate ?? NSDate()).day
        return (day, bill.money, bill.consumeType?.subConsumeptionType?.name ?? "", bill.consumeType?.subConsumeptionType?.iconName ?? "", bill.comment ?? "", bill.consumeType?.subConsumeptionType?.type ?? "0" == "0" ? .Expense : .Income, DateHelper.weekFromDate(bill.occurDate ?? NSDate()))
    }
    
    func deleteBillAtIndex(index: Int, withSection section: Int) {
        
        let bill = model.getBillsWithMonth(monthsOfHavingBills[section])[index]
        model.delete(bill, indexPath: NSIndexPath(forRow: index, inSection: section), userInfo: nil) {
            if let list = self.model.objectList, index = list.indexOf(bill) {
                list.removeAtIndex(index)
            }
        }
    }
}
