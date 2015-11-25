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
    
    var labelTabelViewModel: LabelTableViewModel?
    
    let agent = TextFieldAgent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTextField.delegate = agent
        agent.addTextFieldTextDidChangeNotification { (notification) -> Void in
            let b = self.labelTextField.text?.characters.count > 0
            self.navigationItem.rightBarButtonItem?.enabled = b
            self.saveButton.hidden = !b
        }
        labelTextField.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem?.enabled = false
        saveButton.hidden = true
    }
    
    
    @IBAction func tapSaveButton(sender: UIButton) {
        labelIsExist()
        return
    }
    
    func labelIsExist() {
        
        if let name = labelTextField.text where labelTabelViewModel?.subjectIsExist(name.trim()) == true {
            let alert = UIAlertHelpler.getAlertController("", message: "\"\(name)\"标签已经存在。", prefferredStyle: .Alert, actions: ("确定",.Default, nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}