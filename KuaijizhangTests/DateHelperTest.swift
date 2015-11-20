//
//  DateHelperTest.swift
//  
//
//  Created by 范伟 on 15/11/15.
//
//

import XCTest

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
        
        XCTAssertEqual(DateHelper.getCurrentDate(), "2015年11月19日")
    }
    
    func test_getCurrentDay() {
        
        XCTAssertEqual(DateHelper.getCurrentDay(), "19")
    }
    
    func test_getCurrentMonth() {
        
        XCTAssertEqual(DateHelper.getCurrentMonth(), "11")
    }
    
    func test_getCurrentYear() {
        
        XCTAssertEqual(DateHelper.getCurrentYear(), "2015")
    }
    
    func test_getCurrentWeek() {
        
        XCTAssertEqual(DateHelper.getCurrentWeek(), "周四")
    }
    
    func test_getStartWeekDisplayStringOfPeriodWeek() {
        
        XCTAssertEqual(DateHelper.getStartWeekDisplayStringOfPeriodWeek(), "11月16日")
    }
    
    func test_getOverWeekDisplayStringOfPeriodWeek() {
        
        XCTAssertEqual(DateHelper.getOverWeekDisplayStringOfPeriodWeek(), "11月22日")
    }
    
    func test_getStartMonthDisplayStringOfPeriodMonth() {
        
        XCTAssertEqual(DateHelper.getStartMonthDisplayStringOfPeriodMonth(), "11月01日")
    }
    
    func test_getOverMonthDisplayStringOfPeriodMonth() {
        
        XCTAssertEqual(DateHelper.getOverMonthDisplayStringOfPeriodMonth(), "11月30日")
    }
    
    func test_getRangeOfCurrentMonth() {
        
        let range = NSRange.init(location: 1, length: 30)
        let sourceRange = DateHelper.getRangeOfCurrentMonth()
        XCTAssertEqual(sourceRange.length, range.length)
        XCTAssertEqual(sourceRange.location, range.location)
    }
    
    func test_dateFromStartDayInCurrentMonth() {
        
        let startDate = DateHelper.dateFromStartDayInCurrentMonth()
        print(startDate)
        
        XCTAssertEqual(1, 1)
    }
    
    func test_getDayFromDate() {
        
        XCTAssertEqual(DateHelper.getDayFromDate(NSDate()), 19)
    }
    
    func test_getRangeDateFor() {
        
        print(DateHelper.getRangeDateFor(NSDate()))
        XCTAssert(true)
    }
    
    func test_getStartTimeForCurrentWeek() {
        
        print(DateHelper.getStartTimeForCurrentWeek())
        XCTAssert(true)
    }
    
    func test_getOverTimeForCurrentWeek() {
        
        print(DateHelper.getOverTimeForCurrentWeek())
        XCTAssert(true)
    }
    
    func test_getStartTimeForCurrentMonth() {
        
        print(DateHelper.getStartTimeForCurrentMonth())
        XCTAssert(true)
    }
    
    func test_getOverTimeForCurrentMonth() {
        
        print(DateHelper.getOverTimeForCurrentMonth())
        XCTAssert(true)
    }
    
    func test_getStartTimeForCurrentYear() {
        
        print(DateHelper.getStartTimeForCurrentYear())
        XCTAssert(true)
    }
    
    func test_getOverTimeForCurrentYear() {
        
        print(DateHelper.getOverTimeForCurrentYear())
        XCTAssert(true)
    }
}
