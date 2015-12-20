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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: childIndex == nil ? "tapButtonForSave:" : "tapButtonForUpdate:")
        
        if let pIndex = parentIndex, cIndex = childIndex, childConsumeptionType = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(pIndex, withChildIndex: cIndex) { // 修改
            consumeTypeNameTextField.text = childConsumeptionType.childName
            consumeTypeImageView.image = UIImage(named: childConsumeptionType.iconName ?? "")
            iconCollectionAgent.setSelectedIconForFirstItem(childConsumeptionType.iconName ?? "")
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "dismissSelf:")
        } else { // 添加
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回二级类别", style: .Plain, target: self, action: "returnBack:")
        }
        
        consumeptionTypeViewModel?.addNotification({ (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            if case .Insert = dataChangedType {
                
            }
            
            if case .Update = dataChangedType {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
        iconCollectionAgent.addIconSelectedHandler { (iconName) -> Void in
            self.consumeTypeImageView.image = UIImage(named: iconName)
        }
        
        iconCollectionAgent.addCollectionRecieveTouch { () -> Bool in
            return self.consumeTypeNameTextField.endEditing(true)
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

    /*
    func tapRightButton(sender: AnyObject) {
        
        name = consumeTypeNameTextField.text?.trim()
        if  name?.isEmpty == true {
            let alert = UIAlertController(title: "提示", message: "请填写类型名称", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "好的", style: .Default, handler: { (action) -> Void in
                if !self.consumeTypeNameTextField.isFirstResponder() {
                    self.consumeTypeNameTextField.becomeFirstResponder()
                }
            }))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            if let button = sender as? UIBarButtonItem, title = button.title where ButtonType(title: title) == .Save {
                saveChildTypeBy(rightButtonType: .Save)
                navigationController?.popViewControllerAnimated(true)
            } else { // .Next
                saveChildTypeBy(rightButtonType: .Next)
                if let childConsumeTypeListVC = storyboard?.instantiateViewControllerWithIdentifier("ConsumeTypeListViewController") as? ConsumeTypeListViewController
                    , addChildConsumeTypeVC = storyboard?.instantiateViewControllerWithIdentifier("AddConsumeTypeViewController") as? AddConsumeTypeViewController {
                        
                        childConsumeTypeListVC.consumeTypeData = consumeTypeListController?.consumeTypeData
                        childConsumeTypeListVC.parentTypeID = consumeTypeNameTextField.text
                        addChildConsumeTypeVC.parentTypeID = consumeTypeNameTextField.text
                        
                        addChildConsumeTypeVC.consumeTypeListController = childConsumeTypeListVC
                        
                        if let vcs = navigationController?.viewControllers {
                            var newVCArr = [UIViewController]()
                            for (var i = 0; i < vcs.count; i++) {
                                if i != (vcs.count - 1) {
                                    newVCArr.append(vcs[i])
                                }
                            }
                            newVCArr.append(childConsumeTypeListVC)
                            newVCArr.append(addChildConsumeTypeVC)
                            navigationController?.setViewControllers(newVCArr, animated: true)
                        }
                }
            }
        }
    }
    
    func saveChildTypeBy(rightButtonType type: ButtonType) {
        
        if consumeTypeListController?.data == nil {
            consumeTypeListController?.data = [name!]
            
        } else {
            consumeTypeListController?.data?.append(name!)
            consumeTypeListController?.consumeTypeTableView.reloadData()
        }
    }
*/
}
