//
//  AddConsumeTypeViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddConsumeTypeViewController: UIViewController {
    
    //MARK: - Properties
    /**
     parentTypeID 是空,则是添加一级类别；不为空,则是添加二级类别
     **/
    var parentTypeID: String?
    
    var name: String?
    
    weak var consumeTypeListController: ConsumeTypeListViewController?

    @IBOutlet weak var consumeTypeImageView: UIImageView!
    @IBOutlet weak var consumeTypeNameTextField: UITextField!
    @IBOutlet weak var consumeTypeImageCollectionView: UICollectionView!
    
    enum ButtonType: String {
        case Next = "下一步", Save = "保存"
        init?(title: String) {
            self.init(rawValue: title)
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        consumeTypeNameTextField.delegate = self
        navigationController?.delegate = self
        
        // 添加或修改的判断
        if let n = name {
            consumeTypeNameTextField.text = n
        } else {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: parentTypeID == nil ? "返回" : "二级类别-\(parentTypeID)", style: .Plain, target: nil, action: nil)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: parentTypeID == nil ? ButtonType.Next.rawValue : ButtonType.Save.rawValue, style: .Plain, target: self, action: "tapRightButton:")
            
            consumeTypeNameTextField.placeholder = parentTypeID == nil ? "输入一级名称" : "输入二级名称"
        }
    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        consumeTypeNameTextField.becomeFirstResponder()
    }
    
    
    
    // MARK: -Methods
    
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
}

// MARK: - Delegate

extension AddConsumeTypeViewController: UITextFieldDelegate, UINavigationControllerDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        consumeTypeNameTextField.resignFirstResponder()
        return true
    }
}
