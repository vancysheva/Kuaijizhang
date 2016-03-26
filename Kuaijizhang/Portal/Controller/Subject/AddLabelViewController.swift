//
//  AddLabelViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/31.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddLabelViewController: UITableViewController {

    @IBOutlet weak var labelTextField: UITextField!
    
    var labelTableViewModel: LabelTableViewModel?
    
    var indexPathForUpdate: NSIndexPath?
    
    let agent = TextFieldAgent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTextField.delegate = agent
        agent.addTextFieldTextDidChangeNotification { (notification) -> Void in
            let b = self.labelTextField.text?.characters.count > 0
            self.navigationItem.rightBarButtonItem?.enabled = b
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(tapRightBarButtonItem))
    
        if let indexPath = indexPathForUpdate {
            labelTextField.text = labelTableViewModel?.objectAt(indexPath).labelName
        } else {
            navigationItem.rightBarButtonItem?.enabled = false
        }
        
        delayHandler(500) {
            self.labelTextField.becomeFirstResponder()
        }

    }
    
    func tapRightBarButtonItem(sender: AnyObject) {
        
        if let indexPath = indexPathForUpdate, name = labelTextField.text {
            labelTableViewModel?.updateObjectWithName(name, indexPath: indexPath)
        } else {
            if !labelIsExist() {
                labelTableViewModel?.saveObject(labelTextField.text!)
            }
        }
    }
    
    func labelIsExist() -> Bool{
        
        if let name = labelTextField.text where labelTableViewModel?.subjectIsExist(name.trim()) == true {
            let alert = UIAlertHelpler.getAlertController("", message: "\"\(name)\"标签已经存在。", prefferredStyle: .Alert, actions: ("确定",.Default, nil))
            presentViewController(alert, animated: true, completion: nil)
            return true
        } else {
            return false
        }
    }
}