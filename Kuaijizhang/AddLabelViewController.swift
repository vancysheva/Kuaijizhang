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
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTextField.delegate = self
        
        labelTextField.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem?.enabled = false
        saveButton.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
        print("deinit")
    }
    
    func textDidChange(notification: NSNotification) {
        let b = labelTextField.text?.characters.count > 0
        navigationItem.rightBarButtonItem?.enabled = b
        saveButton.hidden = !b
    }
}

extension AddLabelViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        labelTextField.resignFirstResponder()
        
        return true
    }
}
