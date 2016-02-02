//: Playground - noun: a place where people can play

import Foundation

let currentDate = NSDate()

let dateFormatter = NSDateFormatter()
dateFormatter.locale = NSLocale.currentLocale() //NSLocale(localeIdentifier: "el_GR")

dateFormatter.dateStyle = .FullStyle
let convertDate1 = dateFormatter.stringFromDate(currentDate)

dateFormatter.dateStyle = .LongStyle
let convertDate2 = dateFormatter.stringFromDate(currentDate)

dateFormatter.dateStyle = .MediumStyle
let convertDate3 = dateFormatter.stringFromDate(currentDate)

dateFormatter.dateStyle = .ShortStyle
let convertDate4 = dateFormatter.stringFromDate(currentDate)

dateFormatter.dateFormat = "HH:mm:ss"
let convertDate5 = dateFormatter.stringFromDate(currentDate)

let dateAsString = "2015-01-01 13:05"
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
let convertDate6 = dateFormatter.dateFromString(dateAsString)

let calendar = NSCalendar.currentCalendar()

let dateComponents = calendar.components([.Day, .Month, .Year, .WeekOfMonth, .Hour, .Minute, .Second], fromDate: currentDate)

let day = dateComponents.day
let month = dateComponents.month
let year = dateComponents.year
let weekofmonth = dateComponents.weekOfMonth
let hour = dateComponents.hour
let minute = dateComponents.minute
let second = dateComponents.second

let components = NSDateComponents()
components.day = 5
components.month = 01
components.year = 2016
components.hour = 02
components.minute = 00


let newDate = calendar.dateFromComponents(components)

components.timeZone = NSTimeZone(abbreviation: "GMT")
let newDate1 = calendar.dateFromComponents(components)

components.timeZone = NSTimeZone(abbreviation: "CST")
let newDate2 = calendar.dateFromComponents(components)

components.timeZone = NSTimeZone(abbreviation: "CET")
let newDate3 = calendar.dateFromComponents(components)

let dateAsString1 = "2015-12-16 03:05"
let dateAsString2 = "2015-12-15 03:05"
//dateFormatter.timeZone = NSTimeZone(abbreviation: "CST")
//dateFormatter.locale = NSLocale.currentLocale()
let date1 = dateFormatter.dateFromString(dateAsString1)!

let date2 = dateFormatter.dateFromString(dateAsString2)!

let str = "earlier is \(dateFormatter.stringFromDate(date1.earlierDate(date2)))"
let str2 = "earlier is \(date1.earlierDate(date2))"


if date2.compare(date1) == NSComparisonResult.OrderedAscending {
    print(1)
} else {
    print(2)
}

let mix = [1,2,3,4,5]
let res = mix.filter { return $0 % 2 != 0 }
print(res)

var nums: Set = [3, 1, 5]
print(nums.sort(>))



