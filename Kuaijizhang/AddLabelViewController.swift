//
//  AddLabelViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/31.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddLabelViewController: UIViewController {

    @IBOutlet weak var labelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTextField.becomeFirstResponder()
    }
}
