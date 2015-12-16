//
//  ConsumeptionTypeIconCollectionAgent.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/14.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class ConsumeptionTypeIconCollectionAgent {

    //let icons: [String]
    
    init() {
        self.readIcons()
    }
    
    
    func readIcons() -> [String] {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let bool = NSFileManager.defaultManager().fileExistsAtPath("\(paths[0])/Media.xcassets")
        
        let path = NSBundle.mainBundle().pathForResource("Media", ofType: "xcassets")
        print(bool)
        return [""]
    }
}
