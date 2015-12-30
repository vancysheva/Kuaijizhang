//
//  AccountHeaderView.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/11/25.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AccountHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var accountAmountLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    
    var data: (String?, String?, String?)? {
        didSet {
            if let d = data {
                accountAmountLabel.text = d.1
                accountNameLabel.text = d.0
            }
        }
    }
}
