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
    var consumeptionTypeViewModel: ConsumeptionTypeViewModel?

    @IBOutlet weak var consumeTypeImageView: UIImageView!
    @IBOutlet weak var consumeTypeNameTextField: UITextField!
    @IBOutlet weak var consumeTypeImageCollectionView: UICollectionView!
    
    let textFieldAgent = TextFieldAgent()
    let iconCollectionAgent = ConsumeptionTypeIconCollectionAgent()
    
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
        consumeTypeImageCollectionView.delegate = iconCollectionAgent
        consumeTypeImageCollectionView.dataSource = iconCollectionAgent
        consumeTypeImageCollectionView.gestureRecognizers?[0].delegate = iconCollectionAgent
        
        textFieldAgent.addTextFieldTextDidChangeNotification { [unowned self] (notification) -> Void in
            self.navigationItem.rightBarButtonItem?.enabled = self.consumeTypeNameTextField.text?.characters.count > 0
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: parentIndex == nil ? ButtonType.Next.rawValue : ButtonType.Save.rawValue, style: .Plain, target: self, action: parentIndex == nil ? #selector(tapNextButton) : #selector(tapSaveButton))
        
        if let index = parentIndex, parentConsumeptionType = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(index)  {// 修改
            consumeTypeNameTextField.text = parentConsumeptionType.parentName
            consumeTypeImageView.image = UIImage(named: parentConsumeptionType.iconName ?? "")
            iconCollectionAgent.setSelectedIconInFirstItemPosition(parentConsumeptionType.iconName ?? "")
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(dismissSelf))
        } else {// 添加
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(returnBack))

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
        
        if parentIndex == nil {
            self.consumeTypeNameTextField.becomeFirstResponder()
        }
    }
    
    // MARK: -Methods
    
    func returnBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tapNextButton(sender: AnyObject) { // 保存一级类别，在回调函数中push到添加到二级类别界面
        if let name = consumeTypeNameTextField.text {
            consumeptionTypeViewModel?.saveParentConsumeptionTypeName(name, iconName: iconCollectionAgent.selectedIconName)
        }
    }
    
    func tapSaveButton(sender: AnyObject) {
        if let name = consumeTypeNameTextField.text, index = parentIndex {
            consumeptionTypeViewModel?.updateParentConsumeptionTypeWith(name, iconName: iconCollectionAgent.selectedIconName, withParentIndex: index)
        }
    }
    
    func dismissSelf(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
