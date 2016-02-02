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
    
    /**
     初始化该类的子类的同时，应该对此属性赋值。
     */
    var objectList: List<T>?
    /**
     初始化该类的子类的同时，应该对此属性赋值。
     */
    var object: T?

    
    override init() {
        self.realm = Realm.getRealmInstance()
    }
    
    /**
     返回objectList里对象的个数。
     */
    var numberOfObjects: Int {
        return objectList?.count ?? 0
    }
    
    
    /**
     返回objectList里第一个对象
     */
    var firstObject: T? {
        return objectList?.first
    }
    
    
    /**
     返回objectList里最后一个对象
     */
    var lastObject: T? {
        return objectList?.last
    }
    
    
    // MARK: - Query
    
    /**
    返回objectList中索引号是index的对象
    */
    func objectAtIndex(index: Int) -> T? {
        
        return objectList?[index]
    }
    
    
    /**
     返回objectList里符合断言条件的对象数组。
     */
    func filterObject(predicate: NSPredicate) -> [T]? {
        return objectList?.filter(predicate).toArray()
    }
    
    
    /**
     返回objectList里符合断言条件的对象数组。
     */
    func filterObject(predicateFormat: String, args: AnyObject...) -> [T]? {
        return objectList?.filter(predicateFormat, args).toArray()
    }
    
    
    
    // MARK: - Insert
    
    /**
    在objectList末位，增加一个对象。
    */
    func appendObject(object: T, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.append(object)
        }
        endUpdates?()

        let indexPath = NSIndexPath(forRow: numberOfObjects - 1, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     在给定的序列中末位，增加一个对象。
     */
    func appendObject(object: T, inList list: List<T>, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            list.append(object)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: list.count - 1, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     在objectList的首位，增加一个对象。
     */
    func insertObjectInFirst(object: T, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.insert(object, atIndex: 0)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     在objectList中给定的索引号处，增加一个对象。
     */
    func insertObject(object: T, atIndex index: Int, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.insert(object, atIndex: index)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     在给定的序列中，在制定的索引号处，增加一个对象。
     */
    func insertObject(object: T, atIndex index: Int, list: List<T>, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            list.insert(object, atIndex: index)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Insert, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     在realm数据库中增加一个对象。如果update是true，且数据库中含有该对象的主键，则做更新操作，否则为增加操作。
     */
    func add(object: T, update: Bool = false, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.add(object, update: update)
        }
        endUpdates?()
        
        let count = realm.objects(T.self).count
        let indexPath = NSIndexPath(forRow: count - 1, inSection: 0)
        sendNotificationsFeedBack(state, changedType: update ? .Update : .Insert, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     在realm数据库中通过给定的值，增加一个对象。如果update是true，且数据库中含有该对象的主键，则做更新操作，否则为增加操作。
     */
    func create(t: T.Type, value: AnyObject, update: Bool = false, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.create(t, value: value, update: update)
        }
        endUpdates?()
        
        let count = realm.objects(T.self).count
        let indexPath = NSIndexPath(forRow: count - 1, inSection: 0)
        sendNotificationsFeedBack(state, changedType: update ? .Update : .Insert, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    
    // MARK: - Update
    
    /**
     移动fromIndex处的对象到toIndex处。
     */
    func moveObjectFromIndex(fromIndex: Int, toIndex: Int, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.move(from: fromIndex, to: toIndex)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: toIndex, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Move(fromIndex: fromIndex, toIndex: toIndex), indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     通过给定的对象，替换objectList中索引是index的对象。
     */
    func replaceObjectWithIndex(index: Int, object: T, inSection section: Int = 0, userInfo: [String: Any]? = nil)  {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.replace(index, object: object)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Replace, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     更新index处的对象。
     */
    func updateObjectWithIndex(index: Int, inSection section: Int = 0, userInfo: [String: Any]? = nil, handler: () -> Void)  {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            handler()
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Update, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     交换objectList中给定两个索引处的对象。
     */
    func swapObject(index1 index1: Int, index2: Int, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.swap(index1, index2)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index1, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Swap(index1: index1, index2: index2), indexPath: indexPath, userInfo: userInfo)
    }
    
    
    
    // MARK: - Delete
    
    /**
     删除objectList中给定索引号的对象，此操作只是将对象从objectList中移除，不会从数据库中移除。
     */
    func removeObjecctAtIndex(index: Int, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.objectList?.removeAtIndex(index)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     从数据库中删除objcectList中给定索引号的对象。
     */
    func deleteObjecctAtIndex(index: Int, inSection section: Int = 0, userInfo: [String: Any]? = nil) {
        
        if let obj = objectList?[index] {
            beginUpdates?()
            let state = realm.writeTransaction {
                self.realm.delete(obj)
            }
            endUpdates?()
            
            let indexPath = NSIndexPath(forRow: index, inSection: section)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
        }
    }
    
    
    /**
     从数据库中删除object对象。
     */
    func deleteObject(userInfo: [String: Any]? = nil) {
        
        if let obj = object {
            beginUpdates?()
            let state = realm.writeTransaction {
                self.realm.delete(obj)
            }
            endUpdates?()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
        }
    }
    
    /**
     从数据库中删除给定的对象。
     */
    func delete(object: T, indexPath: NSIndexPath, userInfo: [String: Any]? = nil, completeHandler: (()->Void)? = nil) {

        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.delete(object)
        }
        completeHandler?()
        endUpdates?()
    
        sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     从数据库中删除给定的对象序列。
     */
    func delete(objectList: List<T>, userInfo: [String: Any]? = nil) {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            self.realm.delete(objectList)
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
    }
    
    
    /**
     从数据库中国年删除objectList对象序列。
     */
    func deleteAllInObjectList(userInfo: [String: Any]? = nil) {
        
        if let list = objectList {
            beginUpdates?()
            let state = realm.writeTransaction {
                self.realm.delete(list)
            }
            endUpdates?()
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
        }
    }

    
    /**
     从数据库中删除objectList中指定序列范围的对象。
     */
    func deleteObjectInObjectListAtIndexRange(indexRange: NSRange, userInfo: [String: Any]? = nil) {
        
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
            sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
        }
    }
    
    
    /**
     删除index处的对象。
     */
    func deleteObjectWithIndex(index: Int, inSection section: Int = 0, userInfo: [String: Any]? = nil, handler: () -> Void)  {
        
        beginUpdates?()
        let state = realm.writeTransaction {
            handler()
        }
        endUpdates?()
        
        let indexPath = NSIndexPath(forRow: index, inSection: section)
        sendNotificationsFeedBack(state, changedType: .Delete, indexPath: indexPath, userInfo: userInfo)
    }
}
