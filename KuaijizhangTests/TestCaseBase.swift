//
//  TestCaseBase.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/29.
//  Copyright © 2015年 范伟. All rights reserved.
//

import XCTest

// 一个基本的测试类，每个使用 Realm 进行的测试都应当继承自该类，而不是直接继承自 XCTestCase 类
class TestCaseBase: XCTestCase {
  override func setUp() {
    super.setUp()

    // 使用当前测试名标识的内存 Realm 数据库。
    // 这确保了每个测试都不会从别的测试或者应用本身中访问或者修改数据，并且由于它们是内存数据库，因此无需对其进行清理。
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
  }
}
