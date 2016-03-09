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
    var size = UIScreen.mainScreen().bounds.size
    
    override func perform() {
     
        let sourceView = sourceViewController.view
        let destView = destinationViewController.view
        let window = UIApplication.sharedApplication().keyWindow!
        
        destinationViewController.modalPresentationStyle = .Custom //设置透明viewctonroller的关键
        
        if let sourceVC = sourceViewController as? BillStreamTableViewController {
            let y = (sourceVC.navigationController?.navigationBar.frame.size.height)! + statusBarHeight
            window.insertSubview(destView, aboveSubview: sourceView)
            destView.frame = CGRect(x: 0, y: y, width: size.width, height: size.height)
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                destView.frame = CGRectOffset(destView.frame, 0, -y)
            }, completion: { _ in
                 self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: nil)
            })
            
            sourceVC.navigationController?.setNavigationBarHidden(true, animated: true)
            
        } else {
            let destVC = destinationViewController as! BillStreamTableViewController
            let y = (destVC.navigationController?.navigationBar.frame.size.height)! + statusBarHeight
            
            
            destVC.navigationController?.setNavigationBarHidden(false, animated: true)
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                sourceView.frame = CGRectOffset(sourceView.frame, 0, y)
            }, completion: { _ in
                self.sourceViewController.dismissViewControllerAnimated(false, completion: { _ in
                    sourceView.removeFromSuperview()
                })
            })
        }
        
    }
}
