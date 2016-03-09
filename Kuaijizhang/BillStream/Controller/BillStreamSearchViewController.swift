//
//  BillStreamSearchViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/7.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class BillStreamSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    
    let duration = Double(Float(UINavigationControllerHideShowBarDuration))
    let translationTx = CGFloat(25)
    let blackColorForHalTransparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    let blackColorForTransparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    lazy var textFieldAgent = TextFieldAgent()
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    

    func show(y: CGFloat) {
        
        
        view.frame = CGRect(origin: CGPoint(x: 0, y: y), size: UIScreen.mainScreen().bounds.size)
        
        setState()
        bodyView.hidden = true
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.headerView.alpha = 1
            self.searchView.transform = CGAffineTransformIdentity
            self.cancelButton.transform = CGAffineTransformIdentity
            self.view.backgroundColor = self.blackColorForHalTransparent
            self.view.frame = CGRectOffset(self.view.frame, 0, -y)
            }, completion: { b in
                self.searchTextField.becomeFirstResponder()
        })

        if searchTextField.delegate == nil {
            searchTextField.delegate = textFieldAgent
            textFieldAgent.addTextFieldTextDidChangeNotification({ (notification) -> Void in
                if let key = self.searchTextField.text where key.trim() != "" {
                    self.bodyView.hidden = false
                } else {
                    self.bodyView.hidden = true
                }
            })
        }
    }
    
    
    
    func hide() {
        
        searchTextField.resignFirstResponder()
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.setState()
            }) { b in
                self.view.removeFromSuperview()
        }
    }
    
    
    
    func setState() {
        headerView.alpha = 0
        view.backgroundColor =  blackColorForTransparent
        searchView.transform = CGAffineTransformMakeTranslation(translationTx, 0)
        cancelButton.transform = CGAffineTransformMakeTranslation(translationTx, 0)
    }

    deinit {
        print("BillStreamSearchViewController deinit")
    }

}
