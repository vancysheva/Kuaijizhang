//
//  TestModel.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import RealmSwift

class TestModel: Object {
    dynamic var name = ""
    
    let list = List<TestModel>()
}