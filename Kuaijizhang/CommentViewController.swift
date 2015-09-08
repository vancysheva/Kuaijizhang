//
//  CommentViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/9/1.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextView: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTextView.becomeFirstResponder()
    }
}
