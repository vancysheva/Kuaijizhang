//: Playground - noun: a place where people can play

import Cocoa

let dateFormatter = NSDateFormatter()
let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
let date = NSDate()
let year = calendar.component(.Year, fromDate: date)
let month = calendar.component(.Month, fromDate: date)
let day = calendar.component(.Day, fromDate: date)

let comp = NSDateComponents()

comp.year = year
comp.month = month
comp.day = day
comp.hour = 0
comp.minute = 0
comp.second = 0

//dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

let startDate = dateFormatter.dateFromString(dateFormatter.stringFromDate(calendar.dateFromComponents(comp)!))!

comp.hour = 23
comp.minute = 59
comp.second = 59

let endDate = dateFormatter.dateFromString(dateFormatter.stringFromDate(calendar.dateFromComponents(comp)!))!



