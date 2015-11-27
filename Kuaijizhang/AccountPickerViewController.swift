//
//  PickerViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AccountPickerViewController: UIViewController {
    
    weak var delegate: ComponentViewControllerDelegate?
    
    weak var addViewControlelr: AddBillViewController?
    
    var accountViewModel: AccountViewModel?
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Internal fields
    
    var firstColumnForParentConsumeTypeName: String = "" {
        didSet {
            pickerView.reloadComponent(1)
            
            secondColumnForChildConsumeTypeName = accountViewModel?.childAccountAt(parentAccountName: firstColumnForParentConsumeTypeName, index: 0) ?? ""
            pickerView.selectRow(0, inComponent: 1, animated: true) // 和上一行顺序不能颠倒
            setValue("\(secondColumnForChildConsumeTypeName)")
        }
    }
    
    var secondColumnForChildConsumeTypeName: String = "" {
        didSet {
            addViewControlelr?.addBillViewModel.setParentConsumeptionTypeFromName(firstColumnForParentConsumeTypeName)
            addViewControlelr?.addBillViewModel.setChildConsumeptionTypeFromName(parentConsumeptionTypeName: firstColumnForParentConsumeTypeName, childConsumeptionTypeName: secondColumnForChildConsumeTypeName)
            setValue("\(secondColumnForChildConsumeTypeName)")
            
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.accountViewModel = AccountViewModel()
        
        if let name = addViewControlelr?.addBillViewModel.parentAccount?.name {
            firstColumnForParentConsumeTypeName = name
        }
        
        if let name = addViewControlelr?.addBillViewModel.childAccount?.name {
            secondColumnForChildConsumeTypeName = name
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AccountTableViewController {
            vc.accountViewModel = accountViewModel
        }
    }
    
    // MARK: - Internal Methods
    
    internal func setValue(value: String) {
        delegate?.valueForLabel(value)
    }
    
}

extension AccountPickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String = ""
        switch component {
        case 0:
            title = accountViewModel?.parentAccountAt(row) ?? ""
        case 1:
            title = accountViewModel?.childAccountAt(parentAccountName: firstColumnForParentConsumeTypeName, index: row) ?? ""
        default:
            break
        }
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            firstColumnForParentConsumeTypeName = accountViewModel?.parentAccountAt(row) ?? ""
        case 1:
            secondColumnForChildConsumeTypeName = accountViewModel?.childAccountAt(parentAccountName: firstColumnForParentConsumeTypeName, index: row) ?? ""
        default:
            break
        }
        
    }
}

extension AccountPickerViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows: Int = 0
        switch component {
        case 0:
            rows = accountViewModel?.getParentAccountCount() ?? 0
        case 1:
            rows = accountViewModel?.getChildAccountCount(parentAccountName: firstColumnForParentConsumeTypeName) ?? 0
        default: break
        }
        return rows
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return nil
    }
}
