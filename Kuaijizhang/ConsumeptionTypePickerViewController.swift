//
//  ConsumeptionTypePickerViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class ConsumeptionTypePickerViewController: UIViewController {
    
    weak var delegate: ComponentViewControllerDelegate?
    
    weak var addViewControlelr: AddBillViewController?
    
    var consumeptionTypeViewModel: ConsumeptionTypeViewModel?
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var pickerView: UIPickerView!

    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.consumeptionTypeViewModel = ConsumeptionTypeViewModel(billType: (addViewControlelr?.billType)!)

        consumeptionTypeViewModel?.addNotification("ConsumeptionTypePickerViewController") { [unowned self] (transactionState, dataChangedType, indexPath, _) -> Void in
            /*
            switch dataChangedType {
            case .Insert:
                self.pickerView.selectRow(indexPath.section, inComponent: 0, animated: true)
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(indexPath.row, inComponent: 1, animated: true)
                if let name = self.consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(indexPath.section, withChildIndex: indexPath.row).childName {
                    self.setValueForDelegate(name)
                }
            case .Delete:
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(0, inComponent: 1, animated: true)
            default:
                break
            }*/
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let id = segue.identifier, vc = segue.destinationViewController as? ParentConsumeTypeListViewController where id == "toParentConsumeptionTypeTypeList" {
            vc.consumeptionTypeViewModel = consumeptionTypeViewModel
            vc.addViewController = addViewControlelr
        }
    }
        
    // MARK: - Internal Methods
    
    func setValueForDelegate(name: String) {
        delegate?.valueForLabel("\(name)")
    }
}

extension ConsumeptionTypePickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String = ""
        switch component {
        case 0:
            title = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(row).parentName ?? ""
        case 1:
            title = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(pickerView.selectedRowInComponent(0), withChildIndex: row).childName ?? ""
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
            let name = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(row, withChildIndex: 0).childName ?? ""
            setValueForDelegate(name)
        case 1:
            let name = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(pickerView.selectedRowInComponent(0), withChildIndex: row).childName ?? ""
            setValueForDelegate(name)
        default:
            break
        }
        
    }
}

extension ConsumeptionTypePickerViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows: Int = 0
        switch component {
        case 0:
            rows = consumeptionTypeViewModel?.numberOfParentConsumeptionTypes() ?? 0
        case 1:
            rows = consumeptionTypeViewModel?.numberOfChildConsumeptionTypesAtParentIndex(pickerView.selectedRowInComponent(0)) ?? 0
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
