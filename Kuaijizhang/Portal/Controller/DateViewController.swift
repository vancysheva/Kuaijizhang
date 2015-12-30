//
//  DateViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    weak var delegate: ComponentViewControllerDelegate?
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    // MARK: - Internal fields
    
    let dateFormatter = NSDateFormatter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLocale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        
        datePickerView.locale = currentLocale
        datePickerView.addTarget(self, action: "valueChaned:", forControlEvents: UIControlEvents.ValueChanged)
    }
        
    // MARK: - Internal Methods
    
    func valueChaned(pickerView: UIDatePicker) {
        delegate?.valueForLabel(dateFormatter.stringFromDate(datePickerView.date))
    }
}

