//
//  Delay.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/6.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation

func delayHandler(microsecond: UInt64, handler: () -> Void) {
    
    let time = dispatch_time(DISPATCH_TIME_NOW, (Int64)(microsecond * NSEC_PER_MSEC))
    dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
        handler()
    }
}