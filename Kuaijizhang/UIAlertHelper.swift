//
//  UIAlertHelper.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/13.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import UIKit

class UIAlertHelpler {
    
    class func getAlertController(title: String?, message: String?, prefferredStyle: UIAlertControllerStyle, actions: (actionTitle: String?, actionStyle: UIAlertActionStyle, actionHandler: ((action: UIAlertAction) -> Void)?)...) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: prefferredStyle)
        
        for (actionTitle, actionStyle, actionHandler) in actions {
            alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: actionHandler))
        }
        return alert
    }
}