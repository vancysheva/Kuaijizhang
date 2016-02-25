//
//  DateHelperTest.swift
//  
//
//  Created by 范伟 on 15/11/15.
//
//

import XCTest
@testable import Kuaijizhang

class DateHelperTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func test_getCurrentDate() {
        
        XCTAssertEqual(DateHelper.getCurrentDate(), "2016年02月03日")
    }
    
    func test_getCurrentDay() {
        
        XCTAssertEqual(DateHelper.getCurrentDay(), "03")
    }
    
    func test_getCurrentMonth() {
        
        XCTAssertEqual(DateHelper.getCurrentMonth(), "02")
    }
    
    func test_getCurrentYear() {
        
        XCTAssertEqual(DateHelper.getCurrentYear(), "2016")
    }
    
    func test_getCurrentWeek() {
        
        XCTAssertEqual(DateHelper.getCurrentWeek(), "周三")
    }
    
    func test_getStartWeekDisplayStringOfPeriodWeek() {
        
        XCTAssertEqual(DateHelper.getStartWeekDisplayStringFromCurrentWeek(), "02月01日")
    }
    
    func test_getOverWeekDisplayStringFromCurrentWeek() {
        
        XCTAssertEqual(DateHelper.getOverWeekDisplayStringFromCurrentWeek(), "02月07日")
    }
    
    func test_getStartMonthDisplayStringFromCurrentMonth() {
        
        XCTAssertEqual(DateHelper.getStartMonthDisplayStringFromCurrentMonth(), "02月01日")
    }
    
    func test_getOverMonthDisplayStringFromCurrentMonth() {
        
        XCTAssertEqual(DateHelper.getOverMonthDisplayStringFromCurrentMonth(), "02月29日")
    }
    
    func test_getRangeOfCurrentMonth() {
        
        let range = NSRange.init(location: 1, length: 29)
        let sourceRange = DateHelper.getRangeOfCurrentMonth()
        XCTAssertEqual(sourceRange.length, range.length)
        XCTAssertEqual(sourceRange.location, range.location)
    }
    
    func test_getDayFromDate() {
        
        XCTAssertEqual(DateHelper.getDayFromDate(NSDate()), 03)
    }
    
    func test_getRangeDateFrom() {
        let range = DateHelper.getRangeTimeFrom(NSDate())
        let startDate = range.startDate
        let endDate = range.endDate
        
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let startComp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: startDate)
        let startYear = startComp.year
        let startMonth = startComp.month
        let startDay = startComp.day
        let startHour = startComp.hour
        let startMinute = startComp.minute
        let startSecond = startComp.second
        
        let endComp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: endDate)
        let endYear = endComp.year
        let endMonth = endComp.month
        let endDay = endComp.day
        let endHour = endComp.hour
        let endMinute = endComp.minute
        let endSecond = endComp.second
        
        XCTAssertEqual(startYear, endYear)
        XCTAssertEqual(startMonth, endMonth)
        XCTAssertEqual(startDay, endDay)
        XCTAssertEqual(startHour, 0)
        XCTAssertEqual(startMinute, 0)
        XCTAssertEqual(startSecond, 0)
        XCTAssertEqual(endHour, 23)
        XCTAssertEqual(endMinute, 59)
        XCTAssertEqual(endSecond, 59)
        
    }
    
    func test_getStartTimeFromCurrentWeek() {
        
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let date = DateHelper.getStartTimeFromCurrentWeek()
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 2)
        XCTAssertEqual(comp.day, 1)
        XCTAssertEqual(comp.hour, 0)
        XCTAssertEqual(comp.minute, 0)
        XCTAssertEqual(comp.second, 0)
    }
    
    func test_getOverTimeFromCurrentWeek() {
        
        
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let date = DateHelper.getOverTimeFromCurrentWeek()
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 2)
        XCTAssertEqual(comp.day, 7)
        XCTAssertEqual(comp.hour, 23)
        XCTAssertEqual(comp.minute, 59)
        XCTAssertEqual(comp.second, 59)
    }
    
    func test_getStartTimeFromCurrentMonth() {
        
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let date = DateHelper.getStartTimeFromCurrentMonth()
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 2)
        XCTAssertEqual(comp.day, 1)
        XCTAssertEqual(comp.hour, 0)
        XCTAssertEqual(comp.minute, 0)
        XCTAssertEqual(comp.second, 0)
    }
    
    func test_getOverTimeFromCurrentMonth() {
        
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let date = DateHelper.getOverTimeFromCurrentMonth()
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 2)
        XCTAssertEqual(comp.day, 29)
        XCTAssertEqual(comp.hour, 23)
        XCTAssertEqual(comp.minute, 59)
        XCTAssertEqual(comp.second, 59)
    }
    
    func test_getStartTimeFromCurrentYear() {
        
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let date = DateHelper.getStartTimeFromCurrentYear()
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 1)
        XCTAssertEqual(comp.day, 1)
        XCTAssertEqual(comp.hour, 0)
        XCTAssertEqual(comp.minute, 0)
        XCTAssertEqual(comp.second, 0)
    }
    
    func test_getOverTimeFromCurrentYear() {
        
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let date = DateHelper.getOverTimeFromCurrentYear()
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 12)
        XCTAssertEqual(comp.day, 31)
        XCTAssertEqual(comp.hour, 23)
        XCTAssertEqual(comp.minute, 59)
        XCTAssertEqual(comp.second, 59)
    }
    
    func test_weekFromDate() {
        
        let week = DateHelper.weekFromDate(NSDate())
        XCTAssertEqual(week, "周三")
    }
    
    func test_dateFromString() {
        let date = DateHelper.dateFromString("2016年02月01日 02:14", formatter: DateHelper.dateFormatForCurrentTime)!
        
        let c = NSCalendar.currentCalendar()
        
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 02)
        XCTAssertEqual(comp.day, 01)
    }
    
    func test_getCurrentTime() {
        
        let str = DateHelper.getCurrentTime()
        print(str)
        XCTAssert(true)
    }
    
    func test_getStartTimeFromPreviousYear() {
        
        let date = DateHelper.getStartTimeFromPreviousYear(2016)
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2015)
        XCTAssertEqual(comp.month, 01)
        XCTAssertEqual(comp.day, 1)
        XCTAssertEqual(comp.hour, 0)
        XCTAssertEqual(comp.minute, 0)
        XCTAssertEqual(comp.second, 0)
    }
    
    func test_getOverTimeFromPreviousYear() {
        
        let date = DateHelper.getOverTimeFromPreviousYear(2016)
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2015)
        XCTAssertEqual(comp.month, 12)
        XCTAssertEqual(comp.day, 31)
        XCTAssertEqual(comp.hour, 23)
        XCTAssertEqual(comp.minute, 59)
        XCTAssertEqual(comp.second, 59)
    }
    
    func test_getStartTimeFromNextYear() {
        
        let date = DateHelper.getStartTimeFromNextYear(2016)
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2017)
        XCTAssertEqual(comp.month, 01)
        XCTAssertEqual(comp.day, 1)
        XCTAssertEqual(comp.hour, 0)
        XCTAssertEqual(comp.minute, 0)
        XCTAssertEqual(comp.second, 0)
    }
    
    func test_getOverTimeFromNextYear() {
        
        let date = DateHelper.getOverTimeFromNextYear(2016)
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2017)
        XCTAssertEqual(comp.month, 12)
        XCTAssertEqual(comp.day, 31)
        XCTAssertEqual(comp.hour, 23)
        XCTAssertEqual(comp.minute, 59)
        XCTAssertEqual(comp.second, 59)
        
    }
    
    func test_getStartTimeFromYear() {
        
        let date = DateHelper.getStartTimeFromYear(2016)
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 01)
        XCTAssertEqual(comp.day, 1)
        XCTAssertEqual(comp.hour, 0)
        XCTAssertEqual(comp.minute, 0)
        XCTAssertEqual(comp.second, 0)
    }
    
    func test_getOverTimeFromYear() {
        
        let date = DateHelper.getOverTimeFromYear(2016)
        let c = NSCalendar.currentCalendar()
        c.timeZone = NSTimeZone(abbreviation: "GMT")!
        let comp = c.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        XCTAssertEqual(comp.year, 2016)
        XCTAssertEqual(comp.month, 12)
        XCTAssertEqual(comp.day, 31)
        XCTAssertEqual(comp.hour, 23)
        XCTAssertEqual(comp.minute, 59)
        XCTAssertEqual(comp.second, 59)
    }
}
