//
//  PickerViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    var consumeTypeData: ConsumeTypeData?
    
    weak var delegate: ComponentViewControllerDelegate?
    
    weak var addViewControlelr: AddBillViewController?
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Internal fields
    
    var firstColumnForParentConsumeTypeName: String = "" {
        didSet { //设置新国家的俱乐部数据
            pickerView.reloadComponent(1)
            let arr = consumeTypeData?.childDataListForID(firstColumnForParentConsumeTypeName)
            secondColumnForChildConsumeTypeName = arr?.count == 0 ? "" : arr![0]
            pickerView.selectRow(0, inComponent: 1, animated: true) // 和上一行顺序不能颠倒
            setValue("\(firstColumnForParentConsumeTypeName)>\(secondColumnForChildConsumeTypeName)")
        }
    }
    
    var secondColumnForChildConsumeTypeName: String = "" {
        didSet {
            setValue("\(firstColumnForParentConsumeTypeName)>\(secondColumnForChildConsumeTypeName)")
        }
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self

        if let parr = consumeTypeData?.parentDataList where parr.count > 0 {
            firstColumnForParentConsumeTypeName = parr[0]
        }
        if let carr = consumeTypeData?.childDataListForID(firstColumnForParentConsumeTypeName) where carr.count > 0 {
            secondColumnForChildConsumeTypeName = carr[0]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let id = segue.identifier, vc = segue.destinationViewController as? ConsumeTypeListViewController where id == "toParentTypeList" {
            vc.consumeTypeData = consumeTypeData
            vc.addViewController = addViewControlelr
        }
    }
        
    // MARK: - Internal Methods
    
    internal func setValue(value: String) {
        delegate?.valueForLabel(value)
    }

}

extension PickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String = ""
        switch component {
        case 0:
            title = consumeTypeData!.parentDataList[row]
        case 1:
            title = consumeTypeData!.childDataListForID(firstColumnForParentConsumeTypeName)[row]
        default:
            break
        }
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            firstColumnForParentConsumeTypeName = consumeTypeData!.parentDataList[row]
        case 1:
            secondColumnForChildConsumeTypeName = consumeTypeData!.childDataListForID(firstColumnForParentConsumeTypeName)[row]
        default:
            break
        }
        
    }
}

extension PickerViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows: Int = 0
        switch component {
        case 0:
            rows = consumeTypeData!.parentDataList.count
        case 1:
            rows = consumeTypeData!.childDataListForID(firstColumnForParentConsumeTypeName).count
        default: break
        }
        return rows
    }

}
