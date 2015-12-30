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
    var parentAccount: (String, String)?
    var indexPathForUpdate: NSIndexPath?

    let textFieldAgent = TextFieldAgent()
    
    @IBOutlet weak var accountNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountNameTextField.delegate = textFieldAgent
        textFieldAgent.addTextFieldTextDidChangeNotification { [unowned self] (notification) -> Void in
            self.navigationItem.rightBarButtonItem?.enabled = self.accountNameTextField.text?.trim().characters.count > 0
        }
        
        if let indexPath = indexPathForUpdate {
            accountNameTextField.text = accountViewModel?.childAccountAtParentIndex(indexPath.section, withChildIndex: indexPath.row).childName
        } else {
            navigationItem.rightBarButtonItem?.enabled = false
        }
        
        delayHandler(500) {
            self.accountNameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func tapSaveAccount(sender: AnyObject) {
        
        if let indexPath = indexPathForUpdate, name = accountNameTextField.text {
            accountViewModel?.updateChildAccountWithName(name, atParentIndex: indexPath.section, withChildIndex: indexPath.row)
        } else {
            if let name = accountNameTextField.text, t = parentAccount {
                accountViewModel?.saveAccountWithChildName(name, parentAccountName: t.1, parentIconName: t.0)
            }
        }
    }
}
