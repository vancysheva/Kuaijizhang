//
//  ChildConsumeTypeListViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class ChildConsumeTypeListViewController: UIViewController {
    
    @IBOutlet weak var consumeTypeTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func edit(sender: UIButton) {
        toggleButtonForEditingStyleWidthAnimation()
    }
    
    var parentIndex: Int?
    
    var consumeptionTypeViewModel: ConsumeptionTypeViewModel?
    
    weak var addViewController: AddBillViewController?
    
    enum ButtonType: String {
        case Edit = "✎ 编辑", Done = "✓完成"
        
        init?(title: String) {
            self.init(rawValue: title)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consumeTypeTableView.delegate = self
        consumeTypeTableView.dataSource = self
        consumeTypeTableView.tableFooterView = UIView()
        navigationController?.delegate = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "二级类别", style: .Plain, target: nil, action: nil)
        
        cleanSpaceOnTableViewTop()
        
        consumeptionTypeViewModel?.addNotification({ (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            
            switch dataChangedType {
            case .Delete:
                self.consumeTypeTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case .Update:
                self.consumeTypeTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            case.Insert:
                self.consumeTypeTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            default: break
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? AddChildConsumeTypeViewController {
            vc.parentIndex = parentIndex
            vc.consumeptionTypeViewModel = consumeptionTypeViewModel
        }
    }
    
    private func toggleButtonForEditingStyleWidthAnimation() {
        
        if let title = editButton.titleForState(.Normal) where ButtonType(title: title) == .Edit  {
            
            editButton.setTitle(ButtonType.Done.rawValue, forState: .Normal)
            consumeTypeTableView.setEditing(true, animated: true)
            self.addButton.hidden = true
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                let affine = self.editButton.transform
                self.editButton.transform = CGAffineTransformTranslate(affine, self.editButton.frame.width/2, 0)
                }, completion: nil)
        } else {
            editButton.setTitle(ButtonType.Edit.rawValue, forState: .Normal)
            consumeTypeTableView.setEditing(false, animated: true)
            self.addButton.hidden = false
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                let affine = self.editButton.transform
                self.editButton.transform = CGAffineTransformTranslate(affine, -self.editButton.frame.width/2, 0)
                self.addButton.hidden = false
                }, completion: nil)
        }
    }
    
    func cleanSpaceOnTableViewTop() {
        var zeroFrame = CGRectZero
        zeroFrame.size.height = 1
        consumeTypeTableView.tableHeaderView = UIView(frame: zeroFrame)
    }
    
    func returnForEditingState(sender: AnyObject) {
        
        dismissViewControllerAnimated(true) {
            [unowned self] in
            if let row = self.consumeTypeTableView.indexPathForSelectedRow {
                self.consumeTypeTableView.deselectRowAtIndexPath(row, animated: false)
            }
        }
    }
    
    func deleteWorkFlow(index: Int) {
        
        if let viewModel = consumeptionTypeViewModel where viewModel.childConsumeptionTypeHasBills(index, withParentIndex: parentIndex ?? 0) {
            let alert = UIAlertHelpler.getAlertController("提示", message: "此删除操作此分类下的二级分类以及流水。", prefferredStyle: .Alert, actions: ("确定", .Default, { action in
                self.consumeptionTypeViewModel?.deleteChildConsumeptionTypeAt(index, withParentIndex: self.parentIndex ?? 0)
            }), ("取消", .Cancel, nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Delegate and Datasource

extension ChildConsumeTypeListViewController: UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumeptionTypeViewModel?.numberOfChildConsumeptionTypesAtParentIndex(parentIndex ?? 0) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = consumeTypeTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let index = parentIndex, t = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(index, withChildIndex: indexPath.row) {
            cell.textLabel?.text = t.childName
            cell.imageView?.image = UIImage(named: t.iconName ?? "")
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            deleteWorkFlow(indexPath.row)
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        print("moving...")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if consumeTypeTableView.editing { // 修改二级类别
            if let editVC = storyboard?.instantiateViewControllerWithIdentifier("AddChildConsumeTypeViewController") as? AddChildConsumeTypeViewController, pIndex = parentIndex {

                editVC.parentIndex = pIndex
                editVC.childIndex = indexPath.row
                editVC.consumeptionTypeViewModel = consumeptionTypeViewModel
                
                let naviVC = UINavigationController(rootViewController: editVC)
                presentViewController(naviVC, animated: true, completion: nil)
                
                delayHandler(500) {
                    self.toggleButtonForEditingStyleWidthAnimation()
                }
            }
        } else {
            if let index = parentIndex, parentConsumeptionType = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(index), childConsumeptionType = consumeptionTypeViewModel?.childConsumeptionTypeAtParentIndex(index, withChildIndex: indexPath.row) {
                addViewController?.consumeTypeLabel.text = "\(parentConsumeptionType.parentName)>\(childConsumeptionType.childName)"
                
                if let addVC = addViewController, childVC = addVC.childViewControllers[0] as? ConsumeptionTypePickerViewController {
                    addVC.removeCotentControllerWidthAnimation(childVC)
                    navigationController?.popToViewController(addVC, animated: true)
                }
            }
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !consumeTypeTableView.editing
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ChildConsumeTypeListViewController where vc.parentIndex == nil {
            navigationController.popViewControllerAnimated(true)
        }
    }
}
