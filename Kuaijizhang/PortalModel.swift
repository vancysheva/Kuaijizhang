//
//  PortalModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/14.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class PortalModel: RealmModel<AccountBook> {
    
    let user: User?
    
    
    override init() {
        user = System.getCurrentUser()
    }
    
    
    func getCurrentAccountBookTitle() -> String {
        
        if let title = user?.accountBooks.filter("isUsing = true").first?.title {
            return title
        }
        return "None"
    }
    
    
    func getBills(startDate startDate: NSDate, endDate: NSDate, consumeptionType type: Int = 0) -> [Bill] {
        
    
        if let res =  user?.accountBooks.filter("isUsing = true").first?.bills.filter("occurDate BETWEEN %@ AND consumeType.type = %@", [startDate, endDate], "\(type)").sorted("occurDate").toArray() {
            return res
        }
        return [Bill]()
    }
    
    
    
    func getLatestBill() -> Bill {
        
        if let latestBill = user?.accountBooks.filter("isUsing = true").first?.bills.last {
            return latestBill
        }
        return Bill()
    }    
}
