//
//  AddBillViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddBillViewController: UITableViewController, UITextViewDelegate {
    
    // MARK: - IBOutelt and IBAction
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var consumeTypeLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var billTypeButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveTemplateButton: UIButton!

    @IBAction func tapCancelBarButtonItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapSaveBarButtonItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapBillTypeButton(sender: UIButton) {
        selectBillType()
    }
    
    @IBAction func tapSaveButtonInView(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapSaveTemplateButtonInView(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pictureButton(sender: UIButton) {
        print("pictureButton")
    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initConfig()

        initButtonWithBorderStyle(saveTemplateButton)
        initButtonWithBorderStyle(saveButton)
    }
    
    // MARK: - delegate
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        print("begin")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        print("end")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
                commentTextView.resignFirstResponder()
        return true
    }
    
    // MARK: - Internal Methods
    
    func keyboardDidShow(notification: NSNotification) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.frame = CGRectMake(0, -100, self.view.frame.width, self.view.frame.height)
            }, completion: nil)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            }, completion: nil)
    }
    
    func initConfig() {

    }

    func selectBillType() {
        billTypeButton.setTitle("收入", forState: .Normal)
        saveBarButtonItem.enabled = !saveBarButtonItem.enabled
        
        let duration: NSTimeInterval = 0.25
        let delay: NSTimeInterval = 0
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, CGFloat(M_PI))
            }, completion: nil)
    }
    
    func initButtonWithBorderStyle(button: UIButton) {
        button.layer.borderWidth = 1
        let color = UIColor(red: 27/255, green: 128/255, blue: 251/255, alpha: 1.0)
        button.layer.borderColor = color.CGColor
        button.layer.cornerRadius = 5
    }

}
