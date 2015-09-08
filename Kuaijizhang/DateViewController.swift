//
//  DateViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var showValueLabel: UILabel!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    // MARK: - Internal fields
    
    let dateFormatter = NSDateFormatter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentLocale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd HH:mm", options:0, locale:currentLocale)
        dateFormatter.dateFormat = dateFormat
        
        datePickerView.locale = currentLocale
        datePickerView.addTarget(self, action: "valueChaned:", forControlEvents: UIControlEvents.ValueChanged)
    }
        
    // MARK: - Internal Methods
    
    func valueChaned(pickerView: UIDatePicker) {
        showValueLabel.text = dateFormatter.stringFromDate(datePickerView.date)
    }
}

