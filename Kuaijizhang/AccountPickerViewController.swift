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
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.accountViewModel = AccountViewModel()
        
        accountViewModel?.addNotification({ [unowned self] (transactionState, dataChangedType, indexPath) -> Void in
            if case .Insert = dataChangedType {
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                self.pickerView.selectRow(indexPath.section, inComponent: 0, animated: true)
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(indexPath.row, inComponent: 1, animated: true)
                if let name = self.accountViewModel?.childAccountAtParentIndex(indexPath.section, withChildIndex: indexPath.row).childName {
                    self.setValueForDelegate(name)
                }
                
            }
        })
        
    }
    
    @IBAction func tapEditButton(sender: UIButton) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AccountTableViewController") as! AccountTableViewController
        vc.accountViewModel = accountViewModel
        addViewControlelr?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setValueForDelegate(name: String) {
        delegate?.valueForLabel("\(name)")
    }
    
}

// MARK: - UIPickerViewDelegate

extension AccountPickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String = ""
        switch component {
        case 0:
            title = accountViewModel?.parentAccountWithAmountAt(row).parentName ?? ""
        case 1:
            title = accountViewModel?.childAccountAtParentIndex(pickerView.selectedRowInComponent(0), withChildIndex: row).childName ?? ""
        default:
            break
        }
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            let name = accountViewModel?.childAccountAtParentIndex(row, withChildIndex: 0).childName ?? ""
            setValueForDelegate(name)
        case 1:
            let name = accountViewModel?.childAccountAtParentIndex(pickerView.selectedRowInComponent(0), withChildIndex: row).childName ?? ""
            setValueForDelegate(name)
        default:
            break
        }
        
    }
}

// MARK: - UIPickerViewDataSource

extension AccountPickerViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows: Int = 0
        switch component {
        case 0:
            rows = accountViewModel?.numberOfParentAccounts() ?? 0
        case 1:
            rows = accountViewModel?.numberOfChildAccountsAtParentIndex(pickerView.selectedRowInComponent(0)) ?? 0
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
