//
//  AddAccountBookViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/22.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddAccountBookViewController: UIViewController {
    
    //MARK: - IBOutlet and IBAction

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var coverImagesCollectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem! {
        didSet {
            saveButton.enabled = false
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldChange:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !nameTextField.isFirstResponder() {
            nameTextField.becomeFirstResponder()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    //MARK: - Internal method
    
    func textFieldChange(notification: NSNotificationCenter) {
        saveButton.enabled = nameTextField.text?.characters.count > 0
    }
}
