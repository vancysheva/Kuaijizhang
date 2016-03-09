//
//  PresentSearchViewControllerSegue.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/8.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class PresentSearchViewControllerSegue: UIStoryboardSegue {
    
    let duration = Double(Float(UINavigationControllerHideShowBarDuration))
    let translationTx = CGFloat(25)
    let blackColorForHalTransparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    let blackColorForTransparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height

    override func perform() {
        
        let sourceView = sourceViewController.view
        let destView = destinationViewController.view
        
        let window = UIApplication.sharedApplication().keyWindow!
        
        if let sourceVC = sourceViewController as? BillStreamTableViewController, destVC = destinationViewController as? BillStreamSearchViewController {
            
            window.addSubview(destView)
            

            destVC.show((sourceVC.navigationController?.navigationBar.frame.size.height)!)
            
            sourceVC.navigationController?.setNavigationBarHidden(true, animated: true)
            sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
            
        } else {
            let sourceVC = sourceViewController as! BillStreamSearchViewController
            let destVC = destinationViewController as! BillStreamTableViewController
            
            sourceVC.hide()
            destVC.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
}
