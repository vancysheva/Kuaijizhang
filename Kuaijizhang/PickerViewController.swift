//
//  PickerViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    weak var delegate: ComponentViewControllerDelegate?
    
    // MARK: - IBOutlet and IBAction
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Internal fields
    
    var dic: NSDictionary!
    
    var keyForCounty: String = "" {
        didSet { //设置新国家的俱乐部数据
            pickerView.reloadComponent(1)
            keyForClub = (dic.valueForKey(keyForCounty) as! NSDictionary).allKeys[0] as! String
            pickerView.selectRow(0, inComponent: 1, animated: true) // 和上一行顺序不能颠倒
            setValue("\(keyForCounty)>\(keyForClub)")
        }
    }
    
    var keyForClub: String = "" {
        didSet {
            setValue("\(keyForCounty)>\(keyForClub)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dic = readPickerData()
        
        pickerView.delegate = self
        pickerView.dataSource = self

        keyForCounty = dic.allKeys[0] as! String
        
        keyForClub = (dic.valueForKey(keyForCounty) as! NSDictionary).allKeys[0] as! String
    }
    
    // MARK: - Internal Methods
    
    func readPickerData() -> NSDictionary {
        let data = NSDictionary(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("football", ofType: "plist")!))
        return data!
    }
    
    internal func setValue(value: String) {
        delegate?.valueForLabel(value)
    }

}

extension PickerViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title: String = ""
        switch component {
        case 0:
            title = self.dic.allKeys[row] as! String
        case 1:
            title = (self.dic.valueForKey(self.keyForCounty) as! NSDictionary).allKeys[row] as! String
        default:
            break
        }
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.keyForCounty = self.dic.allKeys[row] as! String
        case 1:
            self.keyForClub = (self.dic.valueForKey(self.keyForCounty) as! NSDictionary).allKeys[row] as! String
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
        var rows: Int? = 0
        switch component {
        case 0: // 国家数量
            rows = dic.count
        case 1: // 俱乐部数量
            rows = (dic.valueForKey(self.keyForCounty) as! NSDictionary).count
        default: break
        }
        return rows!
    }

}
