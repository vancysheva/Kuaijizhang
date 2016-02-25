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
    
    var months: [Int] = []
    
    var currentYear: Int = 0
    
    init() {
        self.currentYear = Int(DateHelper.getCurrentYear())!
        let startTime = DateHelper.getStartTimeFromCurrentYear()
        let endTime = DateHelper.getOverTimeFromCurrentYear()
        super.init(model: BillStreamModel(startTime: startTime, endTime: endTime))
        initMonths()
        initHiddenMonths()
    }
    
    init(startTime: NSDate, endTime: NSDate) {
        super.init(model: BillStreamModel(startTime: startTime, endTime: endTime))
    }
    
    convenience init(year: Int) {
        
        let startTime = DateHelper.getStartTimeFromYear(year)
        let endTime = DateHelper.getOverTimeFromYear(year)
        self.init(startTime: startTime, endTime: endTime)
        self.currentYear = year
        initMonths()
        initHiddenMonths()
    }
    
    func initHiddenMonths() {
        
        var showMonth = 12
        if String(currentYear) == DateHelper.getCurrentYear() {
            showMonth = Int(DateHelper.getCurrentMonth())!
        }
        for month in months {
            hideMonths[month] = showMonth == month ? false : true
        }
    }
    
    func initMonths() {
        
        var endMonth = 12
        //如果是当年的流水，则提出至当月的月份；如果是其他年份，则提出所有月份
        if String(currentYear) == DateHelper.getCurrentYear() {
            endMonth = Int(DateHelper.getCurrentMonth())!
        }
        for month in 1...endMonth {
            months.append(month)
        }
        months.sortInPlace(>)
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
        return model.getBillsWithMonth(month).count
    }
    
    func getCountForSection(month: Int) -> Int {
        
        let cnt = getBillCountForMonth(month) // 如果cnt是0，则说明这个月没有账单显示一个提示cell所以返回1
        return hideMonths[month]! ? 0 : (cnt == 0 ? 1 : cnt)
    }
    
    func getIncome() -> Double {
    
        let bills = model.getIncome()
        return bills.reduce(0) {
            return $0 + $1.money
        }
    }
    
    func getExpense() -> Double {
        
        let bills = model.getExpense()
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
        
        let bill = model.getBillsWithMonth(months[section])[index]
        model.delete(bill, indexPath: NSIndexPath(forRow: index, inSection: section), userInfo: nil) {
            if let list = self.model.objectList, index = list.indexOf(bill) {
                list.removeAtIndex(index)
            }
        }
    }
    
    func getBillByIndex(billIndex index: Int, withMonth month: Int) -> Bill {
        return model.getBillsWithMonth(month)[index]
    }
    
    var updateBillCurrying: ((AddBillViewModel) -> Void)?
    
    func updateBill(billIndex index: Int, withSection section: Int)(viewModel: AddBillViewModel) {
        
        let month = months[section]
        let bill = model.getBillsWithMonth(month)[index]
        
        model.updateObjectWithIndex(index, inSection: section) {
            bill.money = viewModel.money
            bill.account = viewModel.parentAccount
            bill.consumeType = viewModel.parentConsumpetionType
            bill.subject = viewModel.subject
            bill.image = viewModel.image
            bill.comment = viewModel.comment
            bill.occurDate = DateHelper.dateFromString(viewModel.date!, formatter: DateHelper.dateFormatForCurrentTime)
        }
    }
}
