//
//  AppDelegate.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let obj = NSUserDefaults.standardUserDefaults()
        if obj.dictionaryForKey(System.Identifier.User) == nil {
            obj.setObject(["id": "", "username": "", "password": ""], forKey: System.Identifier.User)
            System.createDefaultRealmAndAccountBook()
        }
        
        
        if #available(iOS 9.0, *) {
            addDynamicShortcutItems()
        }
        
        return true
    }

    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        
        switch shortcutItem.type {
        case "add":
            handleAddAccount()
        case "query":
            print("query handling...")
        case "share":
            print("share handling...")
        default: break
        }
    }
    
    func handleAddAccount() {
        let vc = window!.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("AddBillViewController")
        let navi = UINavigationController(rootViewController: vc!)
        window!.rootViewController?.presentViewController(navi, animated: true, completion: nil)
    }
    
    //MARK: - Internal method
    
    @available(iOS 9.0, *)
    func addDynamicShortcutItems() {
        
        let shortcutItem1 = UIApplicationShortcutItem(type: "query", localizedTitle: "查找", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Search), userInfo: nil)
        
        let shortcutItem2 = UIApplicationShortcutItem(type: "share", localizedTitle: "分享", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Share), userInfo: nil)
        
        
        UIApplication.sharedApplication().shortcutItems = [shortcutItem1, shortcutItem2]
        
    }
}

