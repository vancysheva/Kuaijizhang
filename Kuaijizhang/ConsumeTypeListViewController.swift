//
//  ConsumeTypeListViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class ConsumeTypeListViewController: UIViewController {

    @IBOutlet weak var consumeTypeTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func edit(sender: UIButton) {
        toggleButtonForEditingStyleWidthAnimation()
    }
    
    /**
     parentTypeID 是空,则是一级类别view controller；不为空,则是二级类别view controller
    **/
    var parentTypeID: String?
    
    var childTypeID: String?
    
    var consumeTypeData: ConsumeTypeData?
    
    weak var editViewController: UIViewController?
    
    weak var addViewController: AddBillViewController?
    
    var data: [String]?
    
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
        navigationController?.delegate = self
        data = readDataWith(parentTypeID: parentTypeID)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: parentTypeID == nil ? "一级类别" : "二级类别", style: .Plain, target: nil, action: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let id = segue.identifier {
            switch id {
            case "toChildTypeList":
                if let vc = segue.destinationViewController as? ConsumeTypeListViewController, indexPath = consumeTypeTableView.indexPathForSelectedRow, d = data {
                    vc.consumeTypeData = consumeTypeData
                    vc.parentTypeID = d[indexPath.row]
                    vc.addViewController = addViewController
                    consumeTypeTableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            case "addChildConsumeType":
                if let vc = segue.destinationViewController as? AddConsumeTypeViewController {
                    vc.parentTypeID = parentTypeID
                    vc.consumeTypeListController = self
                }
            case "addParentConsumeType":
                if let vc = segue.destinationViewController as? AddConsumeTypeViewController {
                    vc.consumeTypeListController = self
                }
            default:
                break
            }
        }
    }
    
    private func readDataWith(parentTypeID identifier: String?) -> [String] {
        
        if let id = identifier {
            if let d = consumeTypeData {
                let res = d.childDataListForID(id)
                return res.count == 0 ? data! : res
            } else {
                return []
            }
        } else {
            return consumeTypeData!.parentDataList
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
    
    func returnForEditingState(sender: AnyObject) {
        
        dismissViewControllerAnimated(true) {
            [unowned self] in
            if let row = self.consumeTypeTableView.indexPathForSelectedRow {
                self.consumeTypeTableView.deselectRowAtIndexPath(row, animated: false)
            }
        }
    }
    
    func saveForEditingState(sender: AnyObject) {
        if let vc = editViewController as? AddConsumeTypeViewController, indexpPath = consumeTypeTableView.indexPathForSelectedRow, name = vc.name {
            data![indexpPath.row] = name
            consumeTypeTableView.reloadData()
        }
        
        dismissViewControllerAnimated(true) {
            [unowned self] in
            if let row = self.consumeTypeTableView.indexPathForSelectedRow {
                self.consumeTypeTableView.deselectRowAtIndexPath(row, animated: true)
            }
        }
    }
}

// MARK: - Delegate and Datasource

extension ConsumeTypeListViewController: UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = consumeTypeTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = data![indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            data?.removeAtIndex(indexPath.row)
            consumeTypeTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
        
        if consumeTypeTableView.editing {
            if let editVC = storyboard?.instantiateViewControllerWithIdentifier("AddConsumeTypeViewController") as? AddConsumeTypeViewController, d = data {
                editVC.name = d[indexPath.row]
                
                
                editViewController = editVC
                let naviVC = UINavigationController(rootViewController: editVC)
                editVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .Plain, target: self, action: "returnForEditingState:")
                editVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: "saveForEditingState:")
                
                presentViewController(naviVC, animated: true, completion: nil)
            }
        } else {
            if parentTypeID != nil{
                childTypeID = data?[indexPath.row]
                addViewController?.consumeTypeLabel.text = "\(parentTypeID!)>\(childTypeID!)"
                if let addVC = addViewController, childVC = addVC.childViewControllers[0] as? PickerViewController {
                        addVC.removeCotentControllerWidthAnimation(childVC)
                }
                navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !consumeTypeTableView.editing
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ConsumeTypeListViewController where vc.parentTypeID == nil {
            vc.childTypeID = self.childTypeID
            
            if childTypeID != nil {
                navigationController.popViewControllerAnimated(true)
            }
        }
    }
}
