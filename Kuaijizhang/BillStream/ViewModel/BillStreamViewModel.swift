//
//  BillStreamViewModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

typealias BillTuple = (displayDay: Bool, displayLongSeparatorLine: Bool, day: Int, money: Double, consumeName: String, iconName: String, conmment: String, billType: BillType, week: String, haveBillImage: Bool)

typealias SearchBillTuple = (iconName: String?, consumeName: String?, comment: String?, money: Double, haveBillImage: Bool, billType: BillType, index: Int, occurDate: NSDate?)

class BillStreamViewModel: ViewModelBase<BillStreamModel> {
    
    /// 存12个月是否账单的字典
    var hideMonths: [Int: Bool] = [:]
    
    /// 当年月份数据
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
    
    func refreshData() {
        
        let startTime = DateHelper.getStartTimeFromCurrentYear()
        let endTime = DateHelper.getOverTimeFromCurrentYear()

        model.refreshData(startTime, endTime)
    }
    
    convenience init(year: Int) {
        
        let startTime = DateHelper.getStartTimeFromYear(year)
        let endTime = DateHelper.getOverTimeFromYear(year)
        self.init(startTime: startTime, endTime: endTime)
        self.currentYear = year
        initMonths()
        initHiddenMonths()
    }
    
    /**
     初始化隐藏的年份
     
     - returns: <#return value description#>
     */
    func initHiddenMonths() {
        
        var showMonth = 12
        if String(currentYear) == DateHelper.getCurrentYear() {
            showMonth = Int(DateHelper.getCurrentMonth())!
        }
        for month in months {
            hideMonths[month] = showMonth == month ? false : true
        }
    }
    
    /**
     初始化月份
     
     - returns: <#return value description#>
     */
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
    
    /**
     切换隐藏、显示的月份
     
     - parameter month: <#month description#>
     */
    func toggleBillsHiddenInMonth(month: Int) {
        
        if let isHidden = hideMonths[month] {
            hideMonths.updateValue(!isHidden, forKey: month)
        }
    }
    
    /**
    获取展开的月份
     
     - returns: <#return value description#>
     */
    func getExpandMonth() -> Int? {
       
        let expandMonths = hideMonths.filter { return $0.1 == false }
        return expandMonths.count == 0 ? nil : expandMonths[0].0
    }
    
    /**
     根据月份获取账单数
     
     - parameter month: 月份
     
     - returns: 返回月份的账单数
     */
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
    var displayDay: (day: Int, display: Bool)? = nil
    var displayLongSeparatorLine = [Bool]()

    func getBillAtIndex(billIndex index: Int, withMonth month: Int) -> BillTuple {
        
        let bill = model.getBillsWithMonth(month)[index]
        let day = calendar.components(.Day, fromDate: bill.occurDate ?? NSDate()).day

        // 每月中的每天的第一个账单显示日和周信息
        displayDay = index == 0 ? (day: day, display: true) : (day: day, display: day == displayDay?.day ? false : true)
        
        // 每月(一个月份对应一个section)中的每天的最后一个账单显示长分割线
        // 满足长分割线的账单的条件：此账单和下一个账单不属于同一天或此账单是最后一个账单
        var displayLongSeparatorLine = false
        let billCount = model.getBillsWithMonth(month).count
        if index == billCount - 1 || day != calendar.components(.Day, fromDate: model.getBillsWithMonth(month)[index+1].occurDate ?? NSDate()).day {
            displayLongSeparatorLine = true
        }
        
        return (displayDay?.display ?? true, displayLongSeparatorLine, day, bill.money, bill.consumeType?.subConsumeptionType?.name ?? "", bill.consumeType?.subConsumeptionType?.iconName ?? "", bill.comment ?? "", bill.consumeType?.subConsumeptionType?.type ?? "0" == "0" ? .Expense : .Income, DateHelper.weekFromDate(bill.occurDate ?? NSDate()), bill.image == nil ? false : true)
    }
    
    func deleteBillAtIndex(index: Int, withSection section: Int, weekIsDisplayForDeleteCell display: Bool) {
        
        let bill = model.getBillsWithMonth(months[section])[index]
        model.delete(bill, indexPath: NSIndexPath(forRow: index, inSection: section), userInfo: ["weekIsDisplayForDeleteCell": display]) {
            if let list = self.model.objectList, index = list.indexOf(bill) {
                list.removeAtIndex(index)
            }
        }
    }
    
    func getBillByIndex(billIndex index: Int, withMonth month: Int) -> Bill {
        return model.getBillsWithMonth(month)[index]
    }
    
    func getBillAtIndex(indexAtObject index: Int) -> Bill? {
        return model.objectList?[index]
    }
    
    var updateBillCurrying: ((AddBillViewModel, String, [String: Any]?) -> Void)?
    
    func updateBill(billIndex index: Int, withSection section: Int) -> (viewModel: AddBillViewModel, comment: String, userInfo: [String: Any]?) -> Void {
        
        let month = months[section]
        let bill = model.getBillsWithMonth(month)[index]
        
        return {(viewModel: AddBillViewModel, comment: String, userInfo) -> Void in
            self.model.updateObjectWithIndex(index, inSection: section, userInfo: userInfo) {
                bill.money = viewModel.money
                bill.account = viewModel.parentAccount
                bill.account?.subAccount = viewModel.childAccount
                bill.consumeType = viewModel.parentConsumpetionType
                bill.consumeType?.subConsumeptionType = viewModel.childConsumpetionType
                bill.subject = viewModel.subject
                bill.image = viewModel.image
                bill.comment = comment
                bill.occurDate = DateHelper.dateFromString(viewModel.date!, formatter: DateHelper.dateFormatForCurrentTime)
            }
        }
    }
    
    func updateBill(indexAtObject index: Int) -> (viewModel: AddBillViewModel, comment: String, userInfo: [String: Any]?) -> Void {
        
        if let bill = model.objectList?[index] {
            return { (viewModel: AddBillViewModel, comment: String, userInfo) -> Void in
                self.model.updateObjectWithIndex(index, inSection: 0, userInfo: userInfo) {
                    bill.money = viewModel.money
                    bill.account = viewModel.parentAccount
                    bill.account?.subAccount = viewModel.childAccount
                    bill.consumeType = viewModel.parentConsumpetionType
                    bill.consumeType?.subConsumeptionType = viewModel.childConsumpetionType
                    bill.subject = viewModel.subject
                    bill.image = viewModel.image
                    bill.comment = comment
                    bill.occurDate = DateHelper.dateFromString(viewModel.date!, formatter: DateHelper.dateFormatForCurrentTime)
                }
            }
        } else {
            return { (viewModel: AddBillViewModel, comment: String, userInfo: [String: Any]?) -> Void in }
        }
    }
    
    // MARK: - 以下的方法搜索功能用
    
    var searchBills = [[SearchBillTuple]]()
    var totalSearchBillsIncome: Double = 0.0
    var totalSearchBillsExpense: Double = 0.0
    
    func getBillsBy(text: String) {
        
        searchBills.removeAll()
        let bills = model.getBillsBy(text)
        
        bills.forEach {
            if let occurDate = $0.occurDate {
                let index = model.objectList?.indexOf($0) ?? 0
                if searchBills.count == 0 {
                    var arr = [SearchBillTuple]()
                    arr.append(assembleSearchBillTuple($0, index: index))
                    searchBills.append(arr)
                } else {
                    let lastDate = DateHelper.getStringFromDate(searchBills.last?.last?.occurDate ?? NSDate(), dateFormat: DateHelper.dateFormatForDate1)
                    let currentDate = DateHelper.getStringFromDate(occurDate, dateFormat: DateHelper.dateFormatForDate1)
                    
                    if (lastDate == currentDate) {
                        let temp = searchBills.last!
                        searchBills[searchBills.count - 1] = temp + [assembleSearchBillTuple($0, index: index)]
                    } else {
                        var arr = [SearchBillTuple]()
                        arr.append(assembleSearchBillTuple($0, index: index))
                        searchBills.append(arr)
                    }
                }
            }
        }
        
        totalSearchBillsIncome = bills.filter { $0.consumeType?.type == "1" }.reduce(0) { $0 + $1.money }
        
        totalSearchBillsExpense = bills.filter { $0.consumeType?.type == "0" }.reduce(0) { $0 + $1.money }
    }
    
    private func assembleSearchBillTuple(bill: Bill, index: Int) -> SearchBillTuple {
        return (bill.consumeType?.iconName, bill.consumeType?.name, bill.comment, bill.money, bill.image == nil ? false : true, bill.consumeType?.subConsumeptionType?.type ?? "0" == "0" ? .Expense : .Income, index, bill.occurDate)
    }
    
    func deleteSearchBillAt(index: Int, indexPath: NSIndexPath) {
        
        searchBills[indexPath.section].removeAtIndex(indexPath.row)
        // 如果最后一个数组元素为空, 则删除之。
        if searchBills.last?.count == 0 {
            searchBills.removeLast()
        }
        
        model.deleteSearchBillAt(index, indexPath: indexPath)
    }
    
    func getHeaderTitle(tuple: SearchBillTuple) -> String {
        
        let date = tuple.occurDate ?? NSDate()
        let time = DateHelper.getStringFromDate(date, dateFormat: DateHelper.dateFormatForDate2)
        let week = DateHelper.weekFromDate(date)
        return "\(time)   \(week)"
    }
}
