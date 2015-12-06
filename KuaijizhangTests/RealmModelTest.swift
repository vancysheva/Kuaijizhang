//
//  RealmModelTest.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/29.
//  Copyright © 2015年 范伟. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Kuaijizhang

class RealmModelTest: TestCaseBase {
    
    var realmModel: RealmModel<TestModel>?
    
    override func setUp() {
        super.setUp()

        realmModel = RealmModel<TestModel>()

        realmModel?.realm.writeTransaction {
            self.realmModel?.realm.add(TestModel(value: ["name": "a", "list": [["name": "b1"], ["name": "b2"]]]))
        }
        
        realmModel?.object = realmModel?.realm.objects(TestModel.self).filter("name = 'a'").first
        realmModel?.objectList = realmModel?.object?.list
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testObjectCount() {

        let count1 = realmModel?.numberOfObjects
        let count2 = realmModel?.realm.objects(TestModel.self).filter("name BEGINSWITH 'b'").count
        XCTAssertEqual(count1, count2)
        
        realmModel?.objectList = nil
        let count3 = realmModel?.numberOfObjects
        XCTAssertEqual(count3, 0)
    }
    
    func testFirstObject() {
        
        let name = realmModel?.firstObject?.name
        XCTAssertEqual(name, "b1")
    }
    
    func testLastObject() {
        
        let name = realmModel?.lastObject?.name
        XCTAssertEqual(name, "b2")
    }
    
    func testObjectAtIndex() {
        
        let name1 = realmModel?.objectAtIndex(0)?.name
        let name2 = realmModel?.objectAtIndex(1)?.name
        XCTAssertEqual(name1, "b1")
        XCTAssertEqual(name2, "b2")
    }
    
    func testFilterObject() {
        
        let predicate = NSPredicate(format: "name = %@", "b1")
        let arr = realmModel?.filterObject(predicate)
        let arr2 = realmModel?.filterObject("name = 'b1'")
        XCTAssertEqual(arr?.count, 1)
        XCTAssertEqual(arr!, arr2!)
    }
    
    func testAppendObject() {
        
        realmModel?.appendObject(TestModel(value:["name": "b3"]))
        let count = realmModel?.numberOfObjects ?? 0
        let name = realmModel?.objectAtIndex(count-1)?.name
        XCTAssertEqual(count, 3)
        XCTAssertEqual(name!, "b3")
    }
    
    func testInsertObjectInFirst() {
        
        realmModel?.insertObjectInFirst(TestModel(value: ["name": "b3"]))
        let count = realmModel?.numberOfObjects
        let name = realmModel?.firstObject?.name
        XCTAssertEqual(count, 3)
        XCTAssertEqual(name, "b3")
    }
    
    func testInsertObject() {
        
        realmModel?.insertObject(TestModel(value: ["name": "b3"]), atIndex: 1)
        let count = realmModel?.numberOfObjects
        let name = realmModel?.objectAtIndex(1)?.name
        XCTAssertEqual(count, 3)
        XCTAssertEqual(name, "b3")
    }
    
    func testMoveObjectFromIndex() {
        
        realmModel?.moveObjectFromIndex(0, toIndex: 1, inSection: 0)
        let name = realmModel?.objectAtIndex(0)?.name
        XCTAssertEqual(name, "b2")
    }
    
    func testReplaceObjectWithIndex() {
        
        realmModel?.replaceObjectWithIndex(0, object: TestModel(value: ["name": "b3"]), inSection: 0)
        let name = realmModel?.objectAtIndex(0)?.name
        XCTAssertEqual(name, "b3")
    }
    
    func testSwapObject() {
        
        realmModel?.swapObject(index1: 0, index2: 1)
        let name = realmModel?.objectAtIndex(0)?.name
        XCTAssertEqual(name, "b2")
    }
    
    func testDeleteObjecctAtIndex() {
        
        realmModel?.removeObjecctAtIndex(0)
        let count = realmModel?.numberOfObjects
        XCTAssertEqual(realmModel?.realm.objects(TestModel.self).count, 3)
        XCTAssertEqual(count, 1)
    }
    
    func testDeleteObject() {
        
        realmModel?.deleteObject()
        let count = realmModel?.realm.objects(TestModel.self).count
        XCTAssertEqual(count, 2)
    }
    
    func testDeleteAllInObjectList() {
        
        realmModel?.deleteAllInObjectList()
        let count = realmModel?.numberOfObjects
        XCTAssertEqual(count, 0)
    }
    
    func testDeleteObjectInObjectListAtIndexRange() {
        
        let range = NSRange(location: 0, length: 2)
        realmModel?.deleteObjectInObjectListAtIndexRange(range)
        let count = realmModel?.numberOfObjects
        
        XCTAssertEqual(count, 0)
    }
    
    func testAppendObjectWithList() {
        
        realmModel?.appendObject(TestModel(value: ["name": "1"]), inList: (realmModel?.objectList)!)
        let count = realmModel?.numberOfObjects
        XCTAssertEqual(count, 3)
    }
    
    func testInsertObjectWithList() {
        
        realmModel?.insertObject(TestModel(value: ["name": "b3"]), atIndex: 1, list: (realmModel?.objectList)!)
        let name = realmModel?.objectAtIndex(1)?.name
        XCTAssertEqual(name, "b3")
    }
    
    func testAdd() {
        
        realmModel?.add(TestModel(value: ["name": "b3"]))
        let count = realmModel?.realm.objects(TestModel.self).count
        XCTAssertEqual(count, 4)
    }
    
    func testCreate() {
        
        realmModel?.create(TestModel.self, value: ["name": "b3"])
        let count = realmModel?.realm.objects(TestModel.self).count
        XCTAssertEqual(count, 4)
    }
    
    func testDelete() {
        
        realmModel?.delete((realmModel?.object)!, indexPath: NSIndexPath(forRow: 0, inSection: 0))
        let count = realmModel?.realm.objects(TestModel.self).count
        XCTAssertEqual(count, 2)
    }
    
    func testDeleteList() {
        
        realmModel?.delete((realmModel?.objectList)!)
        let count = realmModel?.object?.list.count
        XCTAssertEqual(count, 0)
    }
}
