//
//  AddChildConsumeTypeViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddChildConsumeTypeViewController: UIViewController {
    
    /**
     parentTypeID 是空,则是添加一级类别；不为空,则是添加二级类别
     **/
    var parentIndex: Int?
    var childIndex: Int?
    
    var consumeptionTypeViewModel: ConsumeptionTypeViewModel?
    
    @IBOutlet weak var consumeTypeImageView: UIImageView!
    @IBOutlet weak var consumeTypeNameTextField: UITextField!
    @IBOutlet weak var consumeTypeImageCollectionView: UICollectionView!
    
    let textFieldAgent = TextFieldAgent()
    let iconCollectionAgent = ConsumeptionTypeIconCollectionAgent()

    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consumeTypeNameTextField.delegate = textFieldAgent
        consumeTypeImageCollectionView.delegate = iconCollectionAgent
        consumeTypeImageCollectionView.dataSource = iconCollectionAgent
        consumeTypeImageCollectionView.gestureRecognizers?[0].delegate = iconCollectionAgent
        
        textFieldAgent.addTextFieldTextDidChangeNotification { [unowned self] (notification) -> Void in
            self.consumeTypeNameTextField.becomeFirstResponder()
        }
        
        consumeptionTypeViewModel?.addNotification("AddChildConsumeTypeViewController", notificationHandler: { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            if case .Insert = dataChangedType {
                if let info = userInfo?["save"] as? String where info == "saveChild" {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        })
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: childIndex == nil ? "tapButtonForSave:" : "tapButtonForUpdate:")
        
        if let pIndex = parentIndex, cIndex = childIndex, childConsumeptionType = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(pIndex, withChildIndex: cIndex) { // 修改
            consumeTypeNameTextField.text = childConsumeptionType.childName
            consumeTypeImageView.image = UIImage(named: childConsumeptionType.iconName ?? "")
            iconCollectionAgent.setSelectedIconInFirstItemPosition(childConsumeptionType.iconName ?? "")
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "dismissSelf:")
        } else { // 添加
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回二级类别", style: .Plain, target: self, action: "returnBack:")
        }
        
        iconCollectionAgent.addIconSelectedHandler { (iconName) -> Void in
            self.consumeTypeImageView.image = UIImage(named: iconName)
        }
        
        iconCollectionAgent.addCollectionRecieveTouch { () -> Bool in
            return self.consumeTypeNameTextField.endEditing(true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if childIndex == nil {
            consumeTypeNameTextField.becomeFirstResponder()
        }
    }

    
    // MARK: -Methods
    
    // 返回新增一级类别的二级类别列表
    func returnBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tapButtonForSave(sender: AnyObject) { // 保存二级类别，并返回到添加账单页面
        if let name = consumeTypeNameTextField.text, pIndex = parentIndex {
            consumeptionTypeViewModel?.saveChildConsumeptionTypeWithName(name, iconName: iconCollectionAgent.selectedIconName, withParentIndex: pIndex)
        }
    }
    
    func tapButtonForUpdate(sender: AnyObject) {
        if let name = consumeTypeNameTextField.text, pIndex = parentIndex, cIndex = childIndex {
            consumeptionTypeViewModel?.updateChildConsumeptionTypeWithName(name, iconName: iconCollectionAgent.selectedIconName, atParentIndex: pIndex, withChildIndex: cIndex)
        }
    }
    
    func dismissSelf(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
