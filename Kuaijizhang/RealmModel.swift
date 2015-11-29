//
//  RealmModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel<T: Object> {
    
    let realm: Realm
    
    var notificationHandler: ViewModelNotificationHandler?
    var objectList: List<T>?
    var object: T?

    
    init() {
        self.realm = Realm.getRealmInstance()
    }
    
    convenience init(objectList: List<T>) {
        self.init()
        self.objectList = objectList
    }
    
    convenience init(object: T) {
        self.init()
        self.object = object
    }
    
    
    
    var objectCount: Int {
        return objectList?.count ?? 0
    }
    
    
    
    var firstObject: T? {
        return objectList?.first
    }
    
    
    
    var lastObject: T? {
        return objectList?.last
    }
    
    
    
    func objectAtIndex(index: Int) -> T? {
        
        return objectList?[index]
    }
    
    
    
    func filterObject(predicate: NSPredicate) -> [T]? {
        return objectList?.filter(predicate).toArray()
    }
    
    
    
    func filterObject(predicateFormat: String, args: AnyObject...) -> [T]? {
        return objectList?.filter(predicateFormat, args).toArray()
    }
    
    
    
    func appendObjectInTransaction(object: T, inSection section: Int = 0) {

        let state = realm.writeTransaction {
            self.objectList?.append(object)
        }
        let indexPath = NSIndexPath(forRow: objectCount - 1, inSection: section)
        notificationHandler?(transactionState: state, dataChangedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func insertObjectInFirst(object: T, inSection section: Int = 0) {
        
        let state = realm.writeTransaction {
            self.objectList?.insert(object, atIndex: 0)
        }
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        notificationHandler?(transactionState: state, dataChangedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func insertObject(object: T, atIndex index: Int, inSection section: Int = 0) {
        
        let state = realm.writeTransaction {
            self.objectList?.insert(object, atIndex: index)
        }
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        notificationHandler?(transactionState: state, dataChangedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func moveObjectFromIndex(fromIndex: Int, toIndex: Int, inSection section: Int) {
        
        let state = realm.writeTransaction {
            self.objectList?.move(from: fromIndex, to: toIndex)
        }
        let indexPath = NSIndexPath(forRow: toIndex, inSection: section)
        notificationHandler?(transactionState: state, dataChangedType: .Move(fromIndex: fromIndex, toIndex: toIndex), indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func replaceObjectWithIndex(index: Int, object: T, inSection section: Int) {
        
        let state = realm.writeTransaction {
            self.objectList?.replace(index, object: object)
        }
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        notificationHandler?(transactionState: state, dataChangedType: .Replace, indexPath: indexPath, userInfo: nil)
    }
    
    
    func swapObject(index1 index1: Int, index2: Int, inSection section: Int = 0) {
        
        let state = realm.writeTransaction {
            self.objectList?.swap(index1, index2)
        }
        let indexPath = NSIndexPath(forRow: index1, inSection: section)
        notificationHandler?(transactionState: state, dataChangedType: .Swap(index1: index1, index2: index2), indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func deleteObjecctAtIndex(index: Int, inSection section: Int = 0) {
        
        let state = realm.writeTransaction {
            self.objectList?.removeAtIndex(index)
        }
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        notificationHandler?(transactionState: state, dataChangedType: .Delete, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func deleteObject() {
        
        if let obj = object {
            let state = realm.writeTransaction {
                self.realm.delete(obj)
            }
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            notificationHandler?(transactionState: state, dataChangedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
    
    
    
    func deleteAllInObjectList() {
        
        if let list = objectList {
            let state = realm.writeTransaction {
                self.realm.delete(list)
            }
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            notificationHandler?(transactionState: state, dataChangedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }

    

    func deleteObjectInObjectListAtIndexRange(indexRange: NSRange) {
        
        if let list = objectList {
            realm.beginWrite()
                (indexRange.location..<indexRange.length).forEach {
                    self.realm.delete(list[$0])
                }
            let state = realm.commitTransaction()
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            notificationHandler?(transactionState: state, dataChangedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
}
