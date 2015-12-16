//
//  AddParentConsumeTypeViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddParentConsumeTypeViewController: UIViewController {
    
    /**
     parentTypeID 是空,则是添加一级类别；不为空,则是添加二级类别
     **/
    var parentIndex: Int?
    var type: String?
    var iconName: String?

    
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
            self.navigationItem.rightBarButtonItem?.enabled = self.consumeTypeNameTextField.text?.characters.count > 0
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "returnBack:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: parentIndex == nil ? ButtonType.Next.rawValue : ButtonType.Save.rawValue, style: .Plain, target: self, action: parentIndex == nil ? "tapNextButton:" : "tapSaveButton:")
        
        // 添加或修改的判断
        if let index = parentIndex, parentConsumeptionType = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(index)  {
            consumeTypeNameTextField.text = parentConsumeptionType.parentName
            consumeTypeImageView.image = UIImage(named: parentConsumeptionType.iconName ?? "")
            
        } else {
            
        }
        
        delayHandler(500) { () -> Void in
            self.consumeTypeNameTextField.becomeFirstResponder()
        }
        
        consumeptionTypeViewModel?.addNotification({ (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            if case .Insert = dataChangedType {
                if let addChildVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddChildConsumeTypeViewController") as? AddChildConsumeTypeViewController {
                    addChildVC.parentIndex = indexPath.row
                    self.navigationController?.pushViewController(addChildVC, animated: true)
                }
            }
            
            if case .Update = dataChangedType {
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)
        //consumeTypeNameTextField.becomeFirstResponder()
    }
    
    
    // MARK: -Methods
    
    func returnBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tapNextButton(sender: AnyObject) { // 保存一级类别，在回调函数中push到添加到二级类别界面
        if let name = consumeTypeNameTextField.text, t = type {
            //consumeptionTypeViewModel?.saveParentConsumeptionTypeName(name, iconName: iconName)
        }
    }
    
    func tapSaveButton(sender: AnyObject) {
        if let name = consumeTypeNameTextField.text, index = parentIndex {
            consumeptionTypeViewModel?.updateParentConsumeptionTypeWith(name, withParentIndex: index)
        }
    }
}
