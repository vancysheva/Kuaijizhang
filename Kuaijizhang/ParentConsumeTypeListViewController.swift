//
//  ParentConsumeTypeListViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class ParentConsumeTypeListViewController: UIViewController {

    @IBOutlet weak var consumeTypeTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func edit(sender: UIButton) {
        toggleButtonForEditingStyleWidthAnimation()
    }
    
    var consumeptionTypeViewModel: ConsumeptionTypeViewModel?
    
    //weak var editViewController: UIViewController?
    
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "一级类别", style: .Plain, target: nil, action: nil)
        
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
        
        if let id = segue.identifier {
            switch id {
            case "toChildTypeList":
                if let vc = segue.destinationViewController as? ChildConsumeTypeListViewController, indexPath = consumeTypeTableView.indexPathForSelectedRow {
                    vc.consumeptionTypeViewModel = consumeptionTypeViewModel
                    vc.parentIndex = indexPath.row
                    vc.addViewController = addViewController
                    consumeTypeTableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            case "addParentConsumeType": // 增加名字
                if let vc = segue.destinationViewController as? AddParentConsumeTypeViewController {
                    vc.consumeptionTypeViewModel = consumeptionTypeViewModel
                }
            default:
                break
            }
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
    
    func deleteWorkFlow(indexPath: NSIndexPath) {
        
        if let viewModel = consumeptionTypeViewModel where viewModel.parentConsumeptionTypeHasChildConsumeptionTypes(indexPath.row) && viewModel.parentConsumeptionTypeHasBillsInChildConsumeptionType(indexPath.row) {
            
            //let alert = UIAlertHelpler.getAlertController("提示", message: "此删除操作此分类下的二级分类以及流水。", prefferredStyle: .Alert, actions: ("确定", .Default, { a in self.consumeptionTypeViewModel?.deleteParentConsumeptionType(indexPath.row)}), ("取消", .Cancel, nil))
            //presentViewController(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Delegate and Datasource

extension ParentConsumeTypeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumeptionTypeViewModel?.numberOfParentConsumeptionTypes() ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = consumeTypeTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if let t = consumeptionTypeViewModel?.parentConsumeptionTypeAtIndex(indexPath.row) {
            cell.textLabel?.text = t.parentName
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
            deleteWorkFlow(indexPath)
        default:
            break
        }
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        consumeptionTypeViewModel?.moveoObjectFromIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if consumeTypeTableView.editing { // 修改名字
            if let addVC = storyboard?.instantiateViewControllerWithIdentifier("AddParentConsumeTypeViewController") as? AddParentConsumeTypeViewController{
                addVC.parentIndex = indexPath.row

                //editViewController = addVC
                let naviVC = UINavigationController(rootViewController: addVC)
                
                presentViewController(naviVC, animated: true, completion: nil)
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !consumeTypeTableView.editing
    }
    
}

