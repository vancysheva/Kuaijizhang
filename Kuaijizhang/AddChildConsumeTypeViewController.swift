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
    
    enum ButtonType: String {
        case Next = "下一步", Save = "保存"
        init?(title: String) {
            self.init(rawValue: title)
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consumeTypeNameTextField.delegate = textFieldAgent
        textFieldAgent.addTextFieldTextDidChangeNotification { [unowned self] (notification) -> Void in
            self.consumeTypeNameTextField.becomeFirstResponder()
        }
        
        // 添加或修改的判断
        if consumeTypeNameTextField.text == nil {
            //let childConsumeTypeName = consumeptionTypeViewModel.ch
            //navigationItem.backBarButtonItem = UIBarButtonItem(title: parentIndex == nil ? "返回" : "二级类别-\()", style: .Plain, target: nil, action: nil)
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: parentIndex == nil ? ButtonType.Next.rawValue : ButtonType.Save.rawValue, style: .Plain, target: self, action: "tapRightButton:")
            
            consumeTypeNameTextField.placeholder = parentIndex == nil ? "输入一级名称" : "输入二级名称"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        //consumeTypeNameTextField.becomeFirstResponder()
    }
    
    
    // MARK: -Methods
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
