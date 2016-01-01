//
//  ConsumeptionTypeComView.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/1/1.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class ConsumeptionTypeComView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var data: (String, String)? {
        didSet {
            if let d = data {
                let iconName = d.1
                if iconName != "" {
                    iconImageView.image = UIImage(named: iconName)
                }
                name.text = d.0 == "" ? "无类别" : d.0
            }
        }
    }
}
