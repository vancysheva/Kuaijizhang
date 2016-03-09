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
    lazy var textFieldAgent = TextFieldAgent()
    
    var billStreamViewModel: BillStreamViewModel?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        show()
    }
    

    // MARK: - Methods
    
    private func config() {
        searchTextField.delegate = textFieldAgent
        setState()
        bodyView.hidden = true
        
        searchView.layer.cornerRadius = 5
        
        textFieldAgent.addTextFieldTextDidChangeNotification({[unowned self] (notification) -> Void in
        if let key = self.searchTextField.text where key.trim() != "" {
            self.bodyView.hidden = false
        } else {
            self.bodyView.hidden = true
        }
        })
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        performSegueWithIdentifier("unwindToBillStreamSegue", sender: self)
    }

    func show() {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.headerView.alpha = 1
            self.searchView.transform = CGAffineTransformIdentity
            self.cancelButton.transform = CGAffineTransformIdentity
            self.view.backgroundColor = self.blackColorForHalTransparent
            }, completion: { b in
                self.searchTextField.becomeFirstResponder()
        })

    }

    
    func hide() {
        searchTextField.resignFirstResponder()
        UIView.animateWithDuration(duration) {
            self.setState()
        }
    }

    func setState() {
        headerView.alpha = 0
        view.backgroundColor =  blackColorForTransparent
        searchView.transform = CGAffineTransformMakeTranslation(translationTx, 0)
        cancelButton.transform = CGAffineTransformMakeTranslation(translationTx, 0)
    }
}
