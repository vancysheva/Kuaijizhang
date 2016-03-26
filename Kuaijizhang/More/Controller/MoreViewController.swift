//
//  MoreViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class MoreViewController: UITableViewController {

    @IBOutlet var icons: [UIImageView]! {
        didSet {
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AccountTableViewController {
            vc.accountViewModel = AccountViewModel()
        } else if let _ = segue.destinationViewController as? CatlogManagePageViewController {
            
        }
    }
    
    
}
