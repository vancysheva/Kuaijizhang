//
//  AddBillComponentsPageViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/9/1.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddBillComponentsPageViewController: UIPageViewController {
    
    let storyboardID = [1: "NumberPadViewController", 2: "PickerViewController", 3: "DateViewController", 4: "LabelTableViewController", 5: "CommentViewController"]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        //delegate = self
        
        setViewControllers([naviToController(1)!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
    }
}

typealias Method = AddBillComponentsPageViewController

extension Method {
    
    func naviToController(index: Int) -> UIViewController? {
        if storyboardID.keys.contains(index) {
            let vc = storyboard?.instantiateViewControllerWithIdentifier(storyboardID[index]!)
            return vc!
        } else {
            return nil
        }
    }

}

typealias DataSource = AddBillComponentsPageViewController

extension DataSource: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let id = viewController.restorationIdentifier!
        let results = storyboardID.filter { $0.1 == id }
        
        if results[0].0 == storyboardID.keys.minElement() {
            return nil
        }
        
        return naviToController(results[0].0 - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let id = viewController.restorationIdentifier!
        let results = storyboardID.filter { $0.1 == id }
        
        if results[0].0 == storyboardID.keys.maxElement() {
            return nil
        }
        
        return naviToController(results[0].0 + 1)
    }
}

typealias Delegate = AddBillComponentsPageViewController
/*
extension Delegate: UIPageViewControllerDelegate {
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return storyboardID.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
*/

