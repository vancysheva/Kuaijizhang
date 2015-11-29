//
//  AddAccountViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/26.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddAccountTableViewController: UITableViewController {
    
    var accountViewModel: AccountViewModel?
    var parentAccountIndex: Int?

    let textFieldAgent = TextFieldAgent()
    
    @IBOutlet weak var accountNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.enabled = false
        
        accountNameTextField.delegate = textFieldAgent
        textFieldAgent.addTextFieldTextDidChangeNotification { [unowned self] (notification) -> Void in
            self.navigationItem.rightBarButtonItem?.enabled = self.accountNameTextField.text?.trim().characters.count > 0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !accountNameTextField.isFirstResponder() {
            accountNameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func tapSaveAccount(sender: AnyObject) {
        
        if let name = accountNameTextField.text, index = parentAccountIndex {
            accountViewModel?.saveAccountWidthChildName(name, parentAccountIndex: index)
        }
    }
}
