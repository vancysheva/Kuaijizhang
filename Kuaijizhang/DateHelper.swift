//
//  DateHelper.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/14.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

class DateHelper {

    static let dateFormatForDay = "dd"
    static let dateFormatForMonth = "MM"
    static let dateFormatForYear = "YYYY"
    static let dateFormatForWeek = "ccc"
    static let dateFormatForTime = "yyyy-MM-dd HH:mm:ss"
    static let dateFormatForDate1 = "yyyy年MM月dd日"
    static let dateFormatForDate2 = "MM月dd日"
    
    static let dayStr = "日"
    static let MonthStr = "月"
    static let YearStr = "年"
    
    static let dateFormatter = NSDateFormatter()
    
    static let locale = NSLocale(localeIdentifier: "zh_CN")
    static let calendar = NSCalendar.currentCalendar()
    
    /**
     获取当前日期
     返回的格式：yyyy年MM月dd日
    */
    class func getCurrentDate() -> String {
        dateFormatter.dateFormat = dateFormatForDate1
        return dateFormatter.stringFromDate(NSDate())
    }
    
    /**
     获取当天
     返回的格式：dd
     */
    class func getCurrentDay() -> String {
        dateFormatter.dateFormat = dateFormatForDay
        return dateFormatter.stringFromDate(NSDate())
    }
    
    /**
    获取当月
    返回的格式：MM
    */
    class func getCurrentMonth() -> String {
        dateFormatter.dateFormat = dateFormatForMonth
        return dateFormatter.stringFromDate(NSDate())
    }
    
    /**
     获取当年
     返回的格式：yyyy
     */
    class func getCurrentYear() -> String {
        dateFormatter.dateFormat = dateFormatForYear
        return dateFormatter.stringFromDate(NSDate())
    }
    
    /**
     获取当前星期
     返回的格式：周一等
     */
    class func getCurrentWeek() -> String {
        dateFormatter.dateFormat = dateFormatForWeek
        return dateFormatter.stringFromDate(NSDate())
    }
    
    /**
     获取本周第一天
     返回的格式：MM月dd日
    */
    class func getStartWeekDisplayStringOfPeriodWeek() -> String {
        
         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)
        let dayinweek = calendar.component(.Weekday, fromDate: now)
        
        var addingDay:Int?
        switch dayinweek {
        case 1:
            addingDay = -6
        case 2:
            addingDay = 0
        case 3:
            addingDay = -1
        case 4:
            addingDay = -2
        case 5:
            addingDay = -3
        case 6:
            addingDay = -4
        case 7:
            addingDay = -5
        default:
            break
        }
        
        let firstDayInCurrentWeek = calendar.dateByAddingUnit(.Day, value: addingDay!, toDate: now, options: NSCalendarOptions())
        dateFormatter.dateFormat = dateFormatForDate2
        let str = dateFormatter.stringFromDate(firstDayInCurrentWeek!)
        return str
    }
    
    /**
     返回本周第一天0点时间
    */
    class func getStartTimeForCurrentWeek() -> NSDate {
        
        let str = getStartWeekDisplayStringOfPeriodWeek()
        dateFormatter.dateFormat = dateFormatForDate2
        let date = dateFormatter.dateFromString(str)!
        
        let comp = NSDateComponents()
        comp.year = calendar.component(.Year, fromDate: date)
        comp.month = calendar.component(.Month, fromDate: date)
        comp.day = calendar.component(.Day, fromDate: date)
        comp.hour = 0 + 8
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本周最后一天
     返回的格式：MM月dd日
     */
    class func getOverWeekDisplayStringOfPeriodWeek() -> String {
        
         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)
        let dayinweek = calendar.component(.Weekday, fromDate: now)
        
        var addingDay:Int?
        switch dayinweek {
        case 1:
            addingDay = 0
        case 2:
            addingDay = 6
        case 3:
            addingDay = 5
        case 4:
            addingDay = 4
        case 5:
            addingDay = 3
        case 6:
            addingDay = 2
        case 7:
            addingDay = 1
        default:
            break
        }
        
        let firstDayInCurrentWeek = calendar.dateByAddingUnit(.Day, value: addingDay!, toDate: now, options: NSCalendarOptions())
        dateFormatter.dateFormat = dateFormatForDate2
        let str = dateFormatter.stringFromDate(firstDayInCurrentWeek!)
        return str
    }
    
    
    /**
     返回本周最后一天23:59:59
    */
    class func getOverTimeForCurrentWeek() -> NSDate {
        
        let str = getOverWeekDisplayStringOfPeriodWeek()
        dateFormatter.dateFormat = dateFormatForDate2
        let date = dateFormatter.dateFromString(str)!
        
        let comp = NSDateComponents()
        comp.year = calendar.component(.Year, fromDate: date)
        comp.month = calendar.component(.Month, fromDate: date)
        comp.day = calendar.component(.Day, fromDate: date)
        comp.hour = 23 + 8
        comp.minute = 59
        comp.second = 59
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本月的第一天
     返回的格式：MM月dd日
    */
    class func getStartMonthDisplayStringOfPeriodMonth() -> String {
        
        dateFormatter.dateFormat = dateFormatForDate2
        
         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)
        
        let comp = calendar.components(.Day, fromDate: now)
        comp.day = 1
        comp.month = calendar.component(.Month, fromDate: now)
        comp.year = calendar.component(.Year, fromDate: now)
        
        let date = calendar.dateFromComponents(comp)

        let str = dateFormatter.stringFromDate(date!)
        return str
    }
    
    /**
     获取本月的第一天 00:00:00
     */
    class func getStartTimeForCurrentMonth() -> NSDate {
        
        let str = getStartMonthDisplayStringOfPeriodMonth()
        dateFormatter.dateFormat = dateFormatForDate2
        let date = dateFormatter.dateFromString(str)!
        
        let comp = NSDateComponents()
        comp.year = calendar.component(.Year, fromDate: date)
        comp.month = calendar.component(.Month, fromDate: date)
        comp.day = calendar.component(.Day, fromDate: date)
        comp.hour = 0 + 8
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本月的第一天
     返回的格式：yyyy-MM-dd HH:mm:ss
     */
    class func dateFromStartDayInCurrentMonth() -> NSDate {
        
        dateFormatter.dateFormat = dateFormatForTime

         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)
        
        let comp = calendar.components(.Day, fromDate: now)
        comp.day = 1
        comp.month = calendar.component(.Month, fromDate: now)
        comp.year = calendar.component(.Year, fromDate: now)
        
        let date = calendar.dateFromComponents(comp)
        
        return date!
    }
    
    /**
     获取本月最后一天
     返回的格式：MM月dd日
    */
    class func getOverMonthDisplayStringOfPeriodMonth() -> String {
    
        dateFormatter.dateFormat = dateFormatForDate2
        
         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)
        
        let comp = calendar.components(.Day, fromDate: now)
        comp.day = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: now).length
        comp.month = calendar.component(.Month, fromDate: now)
        comp.year = calendar.component(.Year, fromDate: now)
        
        let date = calendar.dateFromComponents(comp)
        
        let str = dateFormatter.stringFromDate(date!)
        return str
    }
    
    /**
     获取本月最后一天
     返回的格式：yyyy-MM-dd HH:mm:ss
     */
    class func dateFromEndDayInCurrentMonth() -> NSDate {
        
        dateFormatter.dateFormat = dateFormatForTime
        
         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)
        
        let comp = calendar.components(.Day, fromDate: now)
        comp.day = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: now).length
        comp.month = calendar.component(.Month, fromDate: now)
        comp.year = calendar.component(.Year, fromDate: now)
        
        let date = calendar.dateFromComponents(comp)
        
        return date!
    }
    
    /**
     返回本月最后一天23:59:59
     */
    class func getOverTimeForCurrentMonth() -> NSDate {
        
        let str = getOverMonthDisplayStringOfPeriodMonth()
        dateFormatter.dateFormat = dateFormatForDate2
        let date = dateFormatter.dateFromString(str)!
        
        let comp = NSDateComponents()
        comp.year = calendar.component(.Year, fromDate: date)
        comp.month = calendar.component(.Month, fromDate: date)
        comp.day = calendar.component(.Day, fromDate: date)
        comp.hour = 23 + 8
        comp.minute = 59
        comp.second = 59
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取当月的天数范围
    */
    class func getRangeOfCurrentMonth() -> NSRange {
        
         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)
        
        return calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: now)
    }
    
    
    /**
     获取给定日期的日信息
    */
    class func getDayFromDate(date: NSDate) -> Int {
        
        let day = calendar.component(.Day, fromDate: date)
        return day
    }
    
    class func getRangeDateFor(date: NSDate) -> (startDate: NSDate, endDate: NSDate) {
       
        let year = calendar.component(.Year, fromDate: date)
        let month = calendar.component(.Month, fromDate: date)
        let day = calendar.component(.Day, fromDate: date)
        
        let comp = NSDateComponents()
        
        comp.year = year
        comp.month = month
        comp.day = day
        comp.hour = 0 + 8
        comp.minute = 0
        comp.second = 0
        
        let startDate = calendar.dateFromComponents(comp)!
        
        comp.hour = 23 + 8
        comp.minute = 59
        comp.second = 59
        
        let endDate = calendar.dateFromComponents(comp)!
        
        
        
        return (startDate, endDate)
    }
    
    
    /**
     获取本年的第一天 00:00:00
     */
    class func getStartTimeForCurrentYear() -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = Int(getCurrentYear())!
        comp.month = 1
        comp.day = 1
        comp.hour = 0 + 8
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本年的最后一天 23:59:59
     */
    class func getOverTimeForCurrentYear() -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = Int(getCurrentYear())!
        comp.month = 12
        comp.day = 31
        comp.hour = 23 + 8
        comp.minute = 59
        comp.second = 59
        
        return calendar.dateFromComponents(comp)!
    }
}