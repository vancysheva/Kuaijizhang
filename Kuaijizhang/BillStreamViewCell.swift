//
//  BillStreamViewCell.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/23.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class BillStreamViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var consumeType: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var billImage: UIImageView!
}
