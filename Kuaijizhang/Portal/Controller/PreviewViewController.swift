//
//  PreviewViewController.swift
//  Kuaijizhang 用于3D Touch 预览
//
//  Created by 范伟 on 15/10/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: class {
    
    func reselect(previewViewController previewViewController: PreviewViewController)
    func delete(previewViewController previewViewController: PreviewViewController)
}

class PreviewViewController: UIViewController {
    
    var previewImage: UIImage?
    
    weak var delegate: PreviewViewControllerDelegate?
    
    var tintColorForNavi: UIColor?

    @IBOutlet weak var previewImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = previewImage {
            previewImageView.image = image
            
        }

        previewImageView.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        previewImageView.addGestureRecognizer(tapGestureRecognizer)
        
        navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
    }
    
    func tap(sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let reselect = UIAlertAction(title: "替换", style: .Default) { [weak self] action -> Void in
            if let strongSelf = self {
                strongSelf.navigationController?.popViewControllerAnimated(true)
                strongSelf.delegate?.reselect(previewViewController: strongSelf)
            }
        }
        let delete = UIAlertAction(title: "删除", style: .Default) { [weak self] action -> Void in
            if let strongSelf = self {
                strongSelf.navigationController?.popViewControllerAnimated(true)
                strongSelf.delegate?.delete(previewViewController: strongSelf)
            }
        }
        
        let cancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(reselect)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @available(iOS 9.0, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let reselect = UIPreviewAction(title: "替换", style: .Default) { [weak self] action, controller in
            if let strongSelf = self {
                strongSelf.delegate?.reselect(previewViewController: strongSelf)
            }
        }
        let delete = UIPreviewAction(title: "删除", style: .Default) { [weak self] action, controller in
            if let strongSelf = self {
                strongSelf.delegate?.delete(previewViewController: strongSelf)
            }
        }
        
        return [reselect, delete]
    }
}
