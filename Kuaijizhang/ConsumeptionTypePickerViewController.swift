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
    
    var consumeptionTypePickerViewModel: ConsumeptionTypePickerViewModel?
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Internal fields
    
    var firstColumnForParentConsumeTypeName: String = "" {
        didSet {
            pickerView.reloadComponent(1)
            
            secondColumnForChildConsumeTypeName = consumeptionTypePickerViewModel?.childConsumeptionTypeAt(parentConsumeptionTypeName: firstColumnForParentConsumeTypeName, index: 0) ?? ""
            pickerView.selectRow(0, inComponent: 1, animated: true) // 和上一行顺序不能颠倒
            setValue("\(firstColumnForParentConsumeTypeName)>\(secondColumnForChildConsumeTypeName)")
        }
    }
    
    var secondColumnForChildConsumeTypeName: String = "" {
        didSet {
            addViewControlelr?.addBillViewModel.setParentConsumeptionTypeFromName(firstColumnForParentConsumeTypeName)
            addViewControlelr?.addBillViewModel.setChildConsumeptionTypeFromName(parentConsumeptionTypeName: firstColumnForParentConsumeTypeName, childConsumeptionTypeName: secondColumnForChildConsumeTypeName)
            setValue("\(firstColumnForParentConsumeTypeName)>\(secondColumnForChildConsumeTypeName)")
            
        }
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.consumeptionTypePickerViewModel = ConsumeptionTypePickerViewModel(billType: (addViewControlelr?.billType)!)

        if let name = addViewControlelr?.addBillViewModel.parentConsumpetionType?.name {
            firstColumnForParentConsumeTypeName = name
        }
        
        if let name = addViewControlelr?.addBillViewModel.childConsumpetionType?.name {
            secondColumnForChildConsumeTypeName = name
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let id = segue.identifier, vc = segue.destinationViewController as? ConsumeTypeListViewController where id == "toParentTypeList" {
            //vc.consumeTypeData = consumeTypeData
            vc.addViewController = addViewControlelr
        }
    }
        
    // MARK: - Internal Methods
    
    internal func setValue(value: String) {
        delegate?.valueForLabel(value)
    }

}

extension ConsumeptionTypePickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String = ""
        switch component {
        case 0:
            title = consumeptionTypePickerViewModel?.parentConsumeptionTypeAt(row) ?? ""
        case 1:
            title = consumeptionTypePickerViewModel?.childConsumeptionTypeAt(parentConsumeptionTypeName: firstColumnForParentConsumeTypeName, index: row) ?? ""
        default:
            break
        }
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            firstColumnForParentConsumeTypeName = consumeptionTypePickerViewModel?.parentConsumeptionTypeAt(row) ?? ""
        case 1:
            secondColumnForChildConsumeTypeName = consumeptionTypePickerViewModel?.childConsumeptionTypeAt(parentConsumeptionTypeName: firstColumnForParentConsumeTypeName, index: row) ?? ""
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
            rows = consumeptionTypePickerViewModel?.getParentConsumeptionTypeCount() ?? 0
        case 1:
            rows = consumeptionTypePickerViewModel?.getChildConsumeptionTypeCount(consumeptionTypeName: firstColumnForParentConsumeTypeName) ?? 0
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
