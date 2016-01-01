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
    
    var consumeptionTypeViewModel: ConsumeptionTypeViewModel?
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var pickerView: UIPickerView!

    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if let vc = parentViewController as? AddBillViewController {
            self.consumeptionTypeViewModel = ConsumeptionTypeViewModel(billType: vc.billType)
        }

        consumeptionTypeViewModel?.addNotification("ConsumeptionTypePickerViewController") { [unowned self] (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            switch dataChangedType {
            case .Insert:
                if let info = userInfo?["save"] as? String where info == "saveParent" {
                    self.pickerView.reloadComponent(0)
                    self.pickerView.selectRow(indexPath.row, inComponent: 0, animated: false)
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(0, inComponent: 1, animated: false)
                    
                    if let parent = self.consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(indexPath.row) {
                        self.setValueForDelegate("\(parent.parentName)>", iconName: parent.iconName)
                    }
                } else if let info = userInfo?["save"] as? String, pIndex = userInfo?["parentIndex"] as? Int where info == "saveChild" {
                    self.pickerView.reloadComponent(1)
                    self.pickerView.selectRow(indexPath.row, inComponent: 1, animated: false)
                    
                    if let parent = self.consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(pIndex), child = self.consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(pIndex, withChildIndex: indexPath.row) {
                        self.setValueForDelegate("\(parent.parentName)>\(child.childName)", iconName: child.iconName)
                    }
                }
            case .Update:
                var comp = 0
                if let info = userInfo?["update"] as? String where info == "updateParent" {
                    comp = 0
                } else if let info = userInfo?["update"] as? String where info == "updateChild" {
                    comp = 1
                }
                self.pickerView.reloadComponent(comp)
                self.pickerView.selectRow(indexPath.row, inComponent: comp, animated: false)
            case .Delete:
                if let info = userInfo?["delete"] as? String where info == "deleteParent" {
                    if indexPath.row == self.pickerView.selectedRowInComponent(0) {
                        self.pickerView.reloadComponent(0)
                        self.pickerView.selectRow(0, inComponent: 0, animated: false)
                        self.pickerView.reloadComponent(1)
                        self.pickerView.selectRow(0, inComponent: 1, animated: false)
                    } else {
                        self.pickerView.reloadComponent(0)
                        self.pickerView.selectRow(self.pickerView.selectedRowInComponent(0), inComponent: 0, animated: false)
                        self.pickerView.reloadComponent(1)
                        self.pickerView.selectRow(self.pickerView.selectedRowInComponent(1), inComponent: 1, animated: false)
                    }
                } else if let info = userInfo?["delete"] as? String where info == "deleteChild" {
                    if indexPath.row == self.pickerView.selectedRowInComponent(1) {
                        self.pickerView.reloadComponent(1)
                        self.pickerView.selectRow(0, inComponent: 1, animated: false)
                    } else {
                        self.pickerView.reloadComponent(1)
                        self.pickerView.selectRow(self.pickerView.selectedRowInComponent(1), inComponent: 1, animated: false)
                    }
                }
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(0, inComponent: 1, animated: true)
            default:
                break
            }
        }
        
        consumeptionTypeViewModel?.addObserver("ConsumeptionTypePickerViewController") { (indexPath, userInfo) -> Void in
            
            if let section = indexPath?.section, row = indexPath?.row, parentName = self.consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(section).parentName, childType = self.consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(section, withChildIndex: row), addBillVC = self.parentViewController as? AddBillViewController {
                self.navigationController?.popToViewController(addBillVC, animated: true)
                self.setValueForDelegate("\(parentName)>\(childType.childName)", iconName: childType.iconName)
                
                self.pickerView.reloadComponent(0)
                self.pickerView.selectRow(section, inComponent: 0, animated: false)
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(row, inComponent: 1, animated: false)
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let id = segue.identifier, vc = segue.destinationViewController as? ParentConsumeTypeListViewController where id == "toParentConsumeptionTypeTypeList" {
            vc.consumeptionTypeViewModel = consumeptionTypeViewModel
        }
    }
        
    // MARK: - Internal Methods
    
    func setValueForDelegate(name: String, iconName: String) {
        delegate?.valueForLabel("\(name)")
        if let vc = parentViewController as? AddBillViewController {
            vc.consumeptionTypeImageView.image = UIImage(named: iconName)
        }
    }
}

extension ConsumeptionTypePickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let nibs = NSBundle.mainBundle().loadNibNamed("ConsumeptionTypePickerCompView", owner: nil, options: nil)
        let compView = nibs[component] as! ConsumeptionTypeComView
        let width = pickerView.rowSizeForComponent(component).width
        let height = pickerView.rowSizeForComponent(component).height
        compView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        switch component {
            case 0:
                if let name = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(row).parentName {
                    compView.data = (name, "")
                }
            case 1:
                compView.data = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(pickerView.selectedRowInComponent(0), withChildIndex: row)
            default:
            break
        }
        
        return compView
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            if let child = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(row, withChildIndex: 0), parent = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(row) {
                setValueForDelegate("\(parent.parentName)>\(child.childName)", iconName: child.iconName)
            }
        case 1:
            if let child = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(pickerView.selectedRowInComponent(0), withChildIndex: row), parent = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(pickerView.selectedRowInComponent(0)) {
                setValueForDelegate("\(parent.parentName)>\(child.childName)", iconName: child.iconName)
            }
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
}
