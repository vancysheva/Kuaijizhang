//
//  RealmModelTest.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/29.
//  Copyright © 2015年 范伟. All rights reserved.
//

import XCTest
import RealmSwift

class TestModel: Object {
    dynamic var name = ""
    
    let list = List<TestModel>()
}

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
        
        let count1 = realmModel?.objectCount
        let count2 = realmModel?.realm.objects(TestModel.self).filter("name BEGINSWITH 'b'").count
        XCTAssertEqual(count1, count2)
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
        let count = realmModel?.objectCount ?? 0
        let name = realmModel?.objectAtIndex(count-1)?.name
        XCTAssertEqual(count, 3)
        XCTAssertEqual(name!, "b3")
    }
    
    func testInsertObjectInFirst() {
        
        realmModel?.insertObjectInFirst(TestModel(value: ["name": "b3"]))
        let count = realmModel?.objectCount
        let name = realmModel?.firstObject?.name
        XCTAssertEqual(count, 3)
        XCTAssertEqual(name, "b3")
    }
    
    func testInsertObject() {
        
        realmModel?.insertObject(TestModel(value: ["name": "b3"]), atIndex: 1)
        let count = realmModel?.objectCount
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
        
        realmModel?.deleteObjecctAtIndex(0)
        let count = realmModel?.objectCount
        XCTAssertEqual(count, 1)
    }
    
    func testDeleteObject() {
        
        realmModel?.deleteObject()
        let count = realmModel?.realm.objects(TestModel.self).count
        XCTAssertEqual(count, 2)
    }
    
    func testDeleteAllInObjectList() {
        
        realmModel?.deleteAllInObjectList()
        let count = realmModel?.objectCount
        XCTAssertEqual(count, 0)
    }
    
    func testDeleteObjectInObjectListAtIndexRange() {
        
        let range = NSRange(location: 0, length: 2)
        realmModel?.deleteObjectInObjectListAtIndexRange(range)
        let count = realmModel?.objectCount
        
        XCTAssertEqual(count, 0)
    }
}
