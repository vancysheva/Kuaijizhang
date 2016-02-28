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
        
        if let addBillVC = parentViewController as? AddBillViewController,
                parentAccount = addBillVC.addBillViewModel.parentAccount,
                childAccount = addBillVC.addBillViewModel.childAccount,
                pIndex = accountViewModel?.getParentAccountIndex(parentAccount),
                cIndex = accountViewModel?.getChildAccountIndex(childAccount, withParentAccount: parentAccount) {
                    
                    pickerView.reloadComponent(0)
                    pickerView.selectRow(pIndex, inComponent: 0, animated: false)
                    pickerView.reloadComponent(1)
                    pickerView.selectRow(cIndex, inComponent: 1, animated: false)
        }
        
        accountViewModel?.addNotification("AccountPickerViewController") { [unowned self] (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            switch dataChangedType {
            case .Insert:
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                
                var pIndex = 0
                var cIndex = 0
                if let info = userInfo?["type"] as? String where info == "insertChild" {
                    pIndex = indexPath.section
                    cIndex = indexPath.row
                    
                    self.pickerView.selectRow(indexPath.section, inComponent: 0, animated: false)
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(indexPath.row, inComponent: 1, animated: false)
                } else {
                    pIndex = indexPath.row
                    
                    self.pickerView.reloadComponent(0)
                    self.pickerView.selectRow(pIndex, inComponent: 0, animated: false)
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(0, inComponent: 1, animated: false)
                }

                if let parent = self.accountViewModel?.model.objectAtIndex(pIndex) {
                    self.setValueForDelegate(parent, child: parent.accounts[cIndex])
                }
                
            case .Delete:
                if let lastOneDelete = userInfo?["lastOneDelete"] as? Bool where lastOneDelete == true {
                    self.pickerView.reloadComponent(0)
                    self.pickerView.selectRow(0, inComponent: 0, animated: false)
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(0, inComponent: 1, animated: false)
                } else {
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(0, inComponent: 1, animated: false)
                }
            case .Update:
                if indexPath.section == self.pickerView.selectedRowInComponent(0) {
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(self.pickerView.selectedRowInComponent(1), inComponent: 1, animated: false)
                }
                
                if let parent = self.accountViewModel?.model.objectAtIndex(indexPath.section) {
                    self.setValueForDelegate(parent, child: parent.accounts[indexPath.row])
                }
            default:
                break
            }
        }
        
        accountViewModel?.addObserver("AccountPickerViewController", observerHandler: { (indexPath, userInfo) -> Void in
            
            if let row = indexPath?.row, section = indexPath?.section, parent = self.accountViewModel?.model.objectAtIndex(section) {
                self.navigationController?.popViewControllerAnimated(true)
                self.pickerView.reloadComponent(0)
                self.pickerView.selectRow(section, inComponent: 0, animated: false)
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(row, inComponent: 1, animated: false)
                self.setValueForDelegate(parent, child: parent.accounts[row])
            }
        })
        
    }
    
    func tapEditButton() {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AccountTableViewController") as! AccountTableViewController
        vc.accountViewModel = accountViewModel
        parentViewController?.navigationController?.pushViewController(vc, animated: true)

    }
    
    func setValueForDelegate(parent: Account, child: Account?) {
        
        if let a = child {
            delegate?.valueForLabel("\(a.name)")
        }
        
        if let pcontroller = parentViewController as? AddBillViewController {
            pcontroller.addBillViewModel.parentAccount = parent
            pcontroller.addBillViewModel.childAccount = child
        }
    }
    
}

// MARK: - UIPickerViewDelegate

extension AccountPickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let nibs = NSBundle.mainBundle().loadNibNamed("AccountPickerCompView", owner: nil, options: nil)
        let compView = nibs[component] as! UIView
        
        let width = pickerView.rowSizeForComponent(component).width
        let height = pickerView.rowSizeForComponent(component).height
        
        compView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        switch component {
        case 0:
            if let data = accountViewModel?.parentAccountWithAmountAt(row) {
                let label = compView.viewWithTag(1) as! UILabel
                label.text = data.0
            }
        case 1:
            print("component=\(component), row=\(row)")
            if let data = accountViewModel?.childAccountAtParentIndex(pickerView.selectedRowInComponent(0), withChildIndex: row) {
                let nameLabel = compView.viewWithTag(1) as! UILabel
                let amountLabel = compView.viewWithTag(2) as! UILabel
                nameLabel.text = data.0
                amountLabel.text = data.1
            }
        default:break
        }
        
        return compView
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            
            if let parent = self.accountViewModel?.model.objectAtIndex(row) {
                self.setValueForDelegate(parent, child: parent.accounts[0])
            }
        case 1:
            if let parent = self.accountViewModel?.model.objectAtIndex(pickerView.selectedRowInComponent(0)) {
                self.setValueForDelegate(parent, child: parent.accounts[row])
            }
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
}
