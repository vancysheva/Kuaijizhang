//
//  RealmModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel<T: Object>: ModelBase {
    
    let realm: Realm
    
    var objectList: List<T>?
    var object: T?

    
    override init() {
        self.realm = Realm.getRealmInstance()
    }
    
    var numberOfObjects: Int {
        return objectList?.count ?? 0
    }
    
    
    
    var firstObject: T? {
        return objectList?.first
    }
    
    
    
    var lastObject: T? {
        return objectList?.last
    }
    
    
    // MARK: - Query
    
    func objectAtIndex(index: Int) -> T? {
        
        return objectList?[index]
    }
    
    
    
    func filterObject(predicate: NSPredicate) -> [T]? {
        return objectList?.filter(predicate).toArray()
    }
    
    
    
    func filterObject(predicateFormat: String, args: AnyObject...) -> [T]? {
        return objectList?.filter(predicateFormat, args).toArray()
    }
    
    
    
    // MARK: - Insert
    
    func appendObject(object: T, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.append(object)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: numberOfObjects - 1, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func appendObject(object: T, inList list: List<T>, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            list.append(object)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: list.count - 1, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func insertObjectInFirst(object: T, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.insert(object, atIndex: 0)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func insertObject(object: T, atIndex index: Int, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.insert(object, atIndex: index)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func insertObject(object: T, atIndex index: Int, list: List<T>, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            list.insert(object, atIndex: index)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func add(object: T, update: Bool = false) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.add(object, update: update)
        }
        endUpdates?()
        
        let count = realm.objects(T.self).count
        let indexPath = NSIndexPath(forRow: count - 1, inSection: 0)
        sendNotificationsFeedBack(state, changedType: update ? .Update : .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func create(t: T.Type, value: AnyObject, update: Bool = false) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.create(t, value: value, update: update)
        }
        endUpdates?()
        
        let count = realm.objects(T.self).count
        let indexPath = NSIndexPath(forRow: count - 1, inSection: 0)
        sendNotificationsFeedBack(state, changedType: update ? .Update : .Insert, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    // MARK: - Update
    
    func moveObjectFromIndex(fromIndex: Int, toIndex: Int, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.move(from: fromIndex, to: toIndex)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: toIndex, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Move(fromIndex: fromIndex, toIndex: toIndex), indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func replaceObjectWithIndex(index: Int, object: T, inSection section: Int = 0)  {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.replace(index, object: object)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Replace, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func updateObjectWithIndex(index: Int, inSection section: Int = 0, handler: () -> Void)  {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            handler()
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Update, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func swapObject(index1 index1: Int, index2: Int, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.swap(index1, index2)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index1, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Swap(index1: index1, index2: index2), indexPath: indexPath, userInfo: nil)
    }
    
    
    
    // MARK: - Delete
    
    func removeObjecctAtIndex(index: Int, inSection section: Int = 0) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.removeAtIndex(index)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func deleteObjecctAtIndex(index: Int, inSection section: Int = 0) {
        
        if let obj = objectList?[index] {
            beginUpdates?()
            let state = realm.writeTransaction {
                self.realm.delete(obj)
            }
            endUpdates?()
            
            let indexPath = NSIndexPath(forRow: index, inSection: section)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
    
    
    
    func deleteObject() {
        
        if let obj = object {
            beginUpdates?()
            let state = realm.writeTransaction {
                self.realm.delete(obj)
            }
            endUpdates?()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
    
    func delete(object: T, indexPath: NSIndexPath) {

        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.delete(object)
        }
        endUpdates?()
    
        sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
    }
    
    func delete(objectList: List<T>) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.delete(objectList)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
    }
    
    
    
    func deleteAllInObjectList() {
        
        if let list = objectList {
            beginUpdates?()
            let state = realm.writeTransaction {
                self.realm.delete(list)
            }
            endUpdates?()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }

    

    func deleteObjectInObjectListAtIndexRange(indexRange: NSRange) {
        
        if let list = objectList {
            beginUpdates?()
            realm.beginWrite()
                var arr = [T]()
                (indexRange.location..<indexRange.length).forEach {
                    arr.append(list[$0])
                
                }
            arr.forEach {
                self.realm.delete($0)
            }
            let state = realm.commitTransaction()
            endUpdates?()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: nil)
        }
    }
}
