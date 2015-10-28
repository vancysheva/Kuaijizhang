//
//  StatementSearchConditionViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/27.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class StatementSearchConditionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapDone(sender: UIBarButtonItem) {
        
        navigationController?.popViewControllerAnimated(true)
    }
}
