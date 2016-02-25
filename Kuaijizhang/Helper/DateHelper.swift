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
    static let dateFormatForCurrentTime = "yyyy年MM月dd日 HH:mm"
    static let dateFormatForDate1 = "yyyy年MM月dd日"
    static let dateFormatForDate2 = "MM月dd日"
    
    static let dayStr = "日"
    static let MonthStr = "月"
    static let YearStr = "年"
    
    static let dateFormatter = NSDateFormatter()
    
    static let locale = NSLocale(localeIdentifier: "zh_CN")
    static let calendar = NSCalendar.currentCalendar()
    
    class func dateFromString(date: String, formatter: String) -> NSDate? {
        dateFormatter.dateFormat = formatter
        return dateFormatter.dateFromString(date)
    }
    
    /**
     获取当前时间
     返回的格式：yyyy年MM月dd日 HH:mm
     */
    class func getCurrentTime() -> String {
        dateFormatter.dateFormat = dateFormatForCurrentTime
        return dateFormatter.stringFromDate(NSDate())
    }
    
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
     根据日期获取周几
     返回的格式：周一等
     */
    class func weekFromDate(date: NSDate) -> String {
        dateFormatter.dateFormat = dateFormatForWeek
        return dateFormatter.stringFromDate(date)
    }
    
    /**
     获取本周第一天
     返回的格式：MM月dd日
    */
    class func getStartWeekDisplayStringFromCurrentWeek(formatterSytle: String = DateHelper.dateFormatForDate2) -> String {
        
         
        let now = NSDate(timeIntervalSinceNow: 60*60*8)//nsdate默认采用gmt标准时间
        
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
        dateFormatter.dateFormat = formatterSytle
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")!
        let str = dateFormatter.stringFromDate(firstDayInCurrentWeek!)
        
        return str
    }
    
    /**
     返回本周第一天0点时间
    */
    class func getStartTimeFromCurrentWeek() -> NSDate {
        
        let str = getStartWeekDisplayStringFromCurrentWeek(dateFormatForTime)
        dateFormatter.dateFormat = dateFormatForTime
        let date = dateFormatter.dateFromString(str)!
        
        let comp = calendar.components([.Day, .Month, .Year, .WeekOfMonth, .Hour, .Minute, .Second], fromDate: date)
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本周最后一天
     返回的格式：MM月dd日
     */
    class func getOverWeekDisplayStringFromCurrentWeek(formatterStyle: String = dateFormatForDate2) -> String {
        
         
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
        dateFormatter.dateFormat = formatterStyle
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")!
        let str = dateFormatter.stringFromDate(firstDayInCurrentWeek!)
        return str
    }
    
    
    /**
     返回本周最后一天23:59:59
    */
    class func getOverTimeFromCurrentWeek() -> NSDate {
        
        let str = getOverWeekDisplayStringFromCurrentWeek(dateFormatForTime)
        dateFormatter.dateFormat = dateFormatForTime
        let date = dateFormatter.dateFromString(str)!
        
        let comp = calendar.components([.Day, .Month, .Year, .WeekOfMonth, .Hour, .Minute, .Second], fromDate: date)
        
        comp.hour = 23
        comp.minute = 59
        comp.second = 59
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本月的第一天
     返回的格式：MM月dd日
    */
    class func getStartMonthDisplayStringFromCurrentMonth(formatterStyle: String = dateFormatForDate2) -> String {
        
        dateFormatter.dateFormat = formatterStyle
        
         
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
    class func getStartTimeFromCurrentMonth() -> NSDate {
        
        let str = getStartMonthDisplayStringFromCurrentMonth(dateFormatForTime)
        dateFormatter.dateFormat = dateFormatForTime
        let date = dateFormatter.dateFromString(str)!
        
        let comp = NSDateComponents()
        comp.year = calendar.component(.Year, fromDate: date)
        comp.month = calendar.component(.Month, fromDate: date)
        comp.day = calendar.component(.Day, fromDate: date)
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        calendar.timeZone = NSTimeZone(abbreviation: "GMT")!
        return calendar.dateFromComponents(comp)!
    }
    
    
    /**
     获取本月最后一天
     返回的格式：MM月dd日
    */
    class func getOverMonthDisplayStringFromCurrentMonth(formatterStyle: String = dateFormatForDate2) -> String {
    
        dateFormatter.dateFormat = formatterStyle
        
         
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
     返回本月最后一天的时间 23:59:59
     */
    class func getOverTimeFromCurrentMonth() -> NSDate {
        
        let str = getOverMonthDisplayStringFromCurrentMonth(dateFormatForTime)
        dateFormatter.dateFormat = dateFormatForTime
        let date = dateFormatter.dateFromString(str)!
        
        let comp = NSDateComponents()
        comp.year = calendar.component(.Year, fromDate: date)
        comp.month = calendar.component(.Month, fromDate: date)
        comp.day = calendar.component(.Day, fromDate: date)
        comp.hour = 23
        comp.minute = 59
        comp.second = 59
        
        calendar.timeZone = NSTimeZone(abbreviation: "GMT")!
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本年的第一天的时间 00:00:00
     */
    class func getStartTimeFromCurrentYear() -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = Int(getCurrentYear())!
        comp.month = 1
        comp.day = 1
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取本年的最后一天的时间 23:59:59
     */
    class func getOverTimeFromCurrentYear() -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = Int(getCurrentYear())!
        comp.month = 12
        comp.day = 31
        comp.hour = 23
        comp.minute = 59
        comp.second = 59
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取给定年的的开始时间 00:00:00
     */
    class func getStartTimeFromYear(year: Int) -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = year
        comp.month = 1
        comp.day = 1
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取给定年的结束时间 23:59:59
     */
    class func getOverTimeFromYear(year: Int) -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = year
        comp.month = 12
        comp.day = 31
        comp.hour = 23
        comp.minute = 59
        comp.second = 59
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取给定年的前一年的开始时间 00:00:00
    */
    class func getStartTimeFromPreviousYear(year: Int) -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = year - 1
        comp.month = 1
        comp.day = 1
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取给定年的前一年的结束时间 23:59:59
     */
    class func getOverTimeFromPreviousYear(year: Int) -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = year - 1
        comp.month = 12
        comp.day = 31
        comp.hour = 23
        comp.minute = 59
        comp.second = 59
        
        return calendar.dateFromComponents(comp)!
    }
    
    /**
     获取给定年的后一年的开始时间 00:00:00
     */
    class func getStartTimeFromNextYear(year: Int) -> NSDate {
        let comp = NSDateComponents()
        comp.year = year + 1
        comp.month = 1
        comp.day = 1
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        return calendar.dateFromComponents(comp)!
        
    }
    
    /**
     获取给定年的后一年的结束时间 23:59:59
     */
    class func getOverTimeFromNextYear(year: Int) -> NSDate {
        
        let comp = NSDateComponents()
        comp.year = year + 1
        comp.month = 12
        comp.day = 31
        comp.hour = 23
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
        
        dateFormatter.dateFormat = dateFormatForDay
        return Int(dateFormatter.stringFromDate(date))!
    }
    
    /**
     获取给定日期的开始时间和结束时间
     */
    class func getRangeTimeFrom(date: NSDate) -> (startDate: NSDate, endDate: NSDate) {
        
        calendar.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comp = calendar.components([.Day, .Month, .Year, .WeekOfMonth, .Hour, .Minute, .Second], fromDate: date)
        
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        
        let startDate = calendar.dateFromComponents(comp)!
        
        comp.hour = 23
        comp.minute = 59
        comp.second = 59
        
        let endDate = calendar.dateFromComponents(comp)!
        
        return (startDate, endDate)
    }
}