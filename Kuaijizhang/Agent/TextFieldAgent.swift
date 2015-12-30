//
//  TextFieldAgent.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/11.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import UIKit

/**
 UITextField代理类，其相关代理实现在这个类中
*/
class TextFieldAgent: NSObject {
   
    typealias notificationHandleBlock = (notification: NSNotification) -> Void
    
    var textFieldTextDidChangeNotificationHandler: notificationHandleBlock?
    var textFieldShouldReturn: Bool = true
    
    override init() {
        super.init()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    /**
     观察TextField文本改变。
    */
    func addTextFieldTextDidChangeNotification(handler: notificationHandleBlock) {
        self.textFieldTextDidChangeNotificationHandler = handler
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChanged:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    func textDidChanged(notification: NSNotification) {
        textFieldTextDidChangeNotificationHandler?(notification: notification)
    }
}

extension TextFieldAgent: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textFieldShouldReturn {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
}