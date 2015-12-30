//
//  CatlogManagePageViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/30.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class CatlogManagePageViewController: UIPageViewController {

    //MARK: - Life cycle
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var expenseBtn: UIButton!
    @IBOutlet weak var incomeBtn: UIButton!
    
    var originX: CGFloat?
    var indicatorMoveWidth: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        setCurrentViewController(viewControllerWith(.Expense))
        
        originX = indicatorView.frame.origin.x
        indicatorMoveWidth = incomeBtn.frame.origin.x - expenseBtn.frame.origin.x
        
        let subview = view.subviews[0]
        if subview.isKindOfClass(UIScrollView) {
            (subview as! UIScrollView).delegate = self
        }


    }
    
    //MARK: - Internal methods
    
    @IBAction func tapExpenseBtn(sender: UIButton) {

        if let vc = viewControllers?[0] as? ParentConsumeTypeListViewController, ctd = vc.consumeptionTypeViewModel where ctd.billType != .Expense {
            setCurrentViewController(viewControllerWith(.Expense), direction: .Reverse)
            indicatorAnimating(sender)
        }
    }
    
    @IBAction func tapIncomeBtn(sender: UIButton) {
        
        if let vc = viewControllers?[0] as? ParentConsumeTypeListViewController, ctd = vc.consumeptionTypeViewModel where ctd.billType != .Income {
            setCurrentViewController(viewControllerWith(.Income), direction: .Forward)
            indicatorAnimating(sender)
        }
    }
    
    func viewControllerWith(type: BillType) -> UIViewController {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ExpenseConsumeTypeListViewController") as! ParentConsumeTypeListViewController
        vc.consumeptionTypeViewModel = ConsumeptionTypeViewModel(billType: type)
        return vc
    }
    
    func setCurrentViewController(controller: UIViewController,direction: UIPageViewControllerNavigationDirection = .Forward) {
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func indicatorAnimating(toUnderWhichButton: UIButton) {
        
        let x = toUnderWhichButton.frame.origin.x
        UIView.animateWithDuration(0.5) {
            self.indicatorView.frame = CGRect(x: x, y: self.indicatorView.frame.origin.y, width: self.indicatorView.frame.width, height: self.indicatorView.frame.height)
        }
    }
}

//MARK: - Delegate and Datasource

extension CatlogManagePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? ParentConsumeTypeListViewController, ctd = vc.consumeptionTypeViewModel where ctd.billType == .Expense {
            return nil
        } else {
            return viewControllerWith(.Expense)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? ParentConsumeTypeListViewController, ctd = vc.consumeptionTypeViewModel where ctd.billType == .Income {
            return nil
        } else {
            return viewControllerWith(.Income)
        }
    }

    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        //print("begin")
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let previousVC = previousViewControllers[0] as? ParentConsumeTypeListViewController, currentVC = viewControllers?[0] as? ParentConsumeTypeListViewController, previousCTD = previousVC.consumeptionTypeViewModel, currentCTD = currentVC.consumeptionTypeViewModel where currentCTD.billType != previousCTD.billType {
            if completed {
                originX = indicatorView.frame.origin.x
            }
        } else {
            indicatorView.frame.origin.x = originX!
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        let scrollWidth = scrollView.frame.size.width
        let offsetX = scrollView.contentOffset.x
        let tx = offsetX - scrollWidth
        let tpercent = tx/scrollWidth
        let tDistance = indicatorMoveWidth! * tpercent
        //print(tpercent)

        
        UIView.animateWithDuration(0.25) {
            self.indicatorView.frame = CGRect(x: self.originX! + tDistance, y: self.indicatorView.frame.origin.y, width: self.indicatorView.frame.width, height: self.indicatorView.frame.height)
        }
    }
    
}


