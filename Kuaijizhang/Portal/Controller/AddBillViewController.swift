//
//  AddBillViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

protocol ComponentViewControllerDelegate: class {
    
    func valueForLabel(value: String)
    
    func hideComponetViewController(content: UIViewController)
}

class AddBillViewController: UITableViewController {
    
    // MARK: - IBOutelt and IBAction
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var consumeTypeLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var pictureButton: CameraUIButton!
    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var billTypeButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveTemplateButton: UIButton!
    @IBOutlet weak var consumeptionTypeImageView: UIImageView!
    
    @IBAction func tapCancelBarButtonItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapSaveBarButtonItem(sender: UIBarButtonItem) {
        saveBill()
    }
    
    @IBAction func tapBillTypeButton(sender: UIButton) {
        setBillType()
        setConsumeType()
        deselectRowForTable()
        selectFirstRowAndDisplayNumPad()
    }
    
    @IBAction func tapSaveButtonInView(sender: UIButton) {
        saveBill()
    }
    
    @IBAction func tapSaveTemplateButtonInView(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pictureButton(sender: UIButton) {
        
        if let image = activeImage, previewVC = storyboard?.instantiateViewControllerWithIdentifier("PreviewViewController") as?PreviewViewController {
                previewVC.previewImage = image
                previewVC.delegate = self
            showViewController(previewVC, sender: self)
        } else {
            showPictureSelection()
        }
    }
    
    // MARK: - Properties
    // 标记被选中的cell
    var activeRow: Int?
    
    // 标记选中的图片
    var activeImage: UIImage? {
        didSet {
            if let image = activeImage {
                addBillViewModel.image = UIImageJPEGRepresentation(image, 0.5)
            } else {
                addBillViewModel.image = nil
            }
        }
    }
    
    var imagePickerController: UIImagePickerController?
    
    var billType: BillType = .Expense

    let addBillViewModel = AddBillViewModel()
    
    var portalController: ViewController?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.delegate = self
        navigationController?.delegate = self

        initButtonWithBorderStyle(saveTemplateButton)
        initButtonWithBorderStyle(saveButton)
        
        consumeTypeLabel.text = addBillViewModel.getConsumeptionTypeDescription(billType)
        accountLabel.text = addBillViewModel.getAccountDescription()
        setConsumeptionTypeNameImage()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        
        selectFirstRowAndDisplayNumPad()
        dateLabel.text = addBillViewModel.getCurrentTime()
        
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .Available {
                registerForPreviewingWithDelegate(self, sourceView: view)
            }
        }
        
        addBillViewModel.addNotification { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            self.portalController?.updateUI()
        }
    }
}

// MARK: - Internal Methodss

extension AddBillViewController {
    
    func setBillType() {
        
        billTypeButton.setTitle(billType.title, forState: .Normal)
        
        let duration: NSTimeInterval = 0.25
        let delay: NSTimeInterval = 0
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, CGFloat(M_PI))
            }, completion: nil)
    }
    
    func setConsumeType() {
        
        moneyLabel.textColor = billType.toggle().color
        consumeTypeLabel.text = addBillViewModel.getConsumeptionTypeDescription(billType)
        setConsumeptionTypeNameImage()
    }
    
    func selectFirstRowAndDisplayNumPad() {
        // 250毫秒后执行
        delayHandler(250) {
            self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)
            self.activeRow = 0
            // 弹出数字面板
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NumberPadViewController") as? NumberPadViewController {
                vc.delegate = self
                self.addContentController(vc)
            }
        }
    }
    
    func initButtonWithBorderStyle(button: UIButton) {
        
        button.layer.borderWidth = 1
        let color = UIColor(red: 27/255, green: 128/255, blue: 251/255, alpha: 1.0)
        button.layer.borderColor = color.CGColor
        button.layer.cornerRadius = 5
    }
    
    func addContentController(content: UIViewController) {
        
        addChildViewController(content)
        content.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height*0.4)
        view.addSubview(content.view)
        content.didMoveToParentViewController(self)

        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            content.view.frame.origin.y = self.view.frame.height - content.view.frame.height
        }, completion: nil)
    
    }
    
    func removeContentController(content: UIViewController) {
        
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    func removeCotentControllerWidthAnimation(content: UIViewController) {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            content.view.frame.origin.y += content.view.frame.height
            }) { bo in
                self.removeContentController(content)
        }
    }
    
    func deselectRowForTable() {
        
        if let row = activeRow {
            tableView.deselectRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), animated: true)
            activeRow = nil
        }
    }
    
    func showPictureSelection() {
    
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let camerAction = UIAlertAction(title: "拍照", style: .Default) { action in
            self.showImagePickerForSourceType(.Camera)
        }
        let photoLibraryAction = UIAlertAction(title: "相册", style: .Default) { action in
            self.showImagePickerForSourceType(.PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alert.addAction(camerAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        
        imagePickerController = UIImagePickerController()
        imagePickerController!.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
    func setConsumeptionTypeNameImage() {
        
        if let name = addBillViewModel.childConsumpetionType?.iconName {
            consumeptionTypeImageView.image = UIImage(named: name)
        }
    }

    func saveBill() {
        addBillViewModel.saveBill(commentTextView.text)
    }
}

// MARK: - Delegate

extension AddBillViewController: ComponentViewControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UIViewControllerPreviewingDelegate, PreviewViewControllerDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let row = activeRow where row == indexPath.row {
            return
        }
        
        activeRow = indexPath.row
        
        if let child = childViewControllers.first {
            removeContentController(child)
        }
        
        commentTextView.resignFirstResponder()

        switch indexPath.row {
        case 0:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("NumberPadViewController") as! NumberPadViewController
            vc.delegate = self
            
            addContentController(vc)
        case 1:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("ConsumeptionTypePickerViewController") as! ConsumeptionTypePickerViewController
            vc.delegate = self
            addContentController(vc)
        case 2:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("AccountPickerViewController") as! AccountPickerViewController
            vc.delegate = self
            addContentController(vc)
        case 3:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("DateViewController") as! DateViewController
            vc.delegate = self
            addContentController(vc)
        case 4:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("LabelTableViewController") as! LabelTableViewController
            vc.delegate = self
            addContentController(vc)
        default:
            break
        }
    }
    
    
    func valueForLabel(value: String) {
        
        if let row = activeRow {
            switch row {
            case 0:
                moneyLabel.text = value
                addBillViewModel.money = Double(value) ?? 0.00
            case 1:
                consumeTypeLabel.text = value
                //setConsumeptionTypeNameImage()
            case 2:
                accountLabel.text = value
            case 3:
                dateLabel.text = value
                addBillViewModel.date = value
            case 4:
                tagLabel.text = value
            case 5:
                fallthrough
            default:
                break
            }
        }
    }
    
    func hideComponetViewController(content: UIViewController) {
        activeRow = nil
        removeCotentControllerWidthAnimation(content)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            commentTextView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if let child = childViewControllers.first {
            removeContentController(child)
        }
        deselectRowForTable()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if let child = childViewControllers.first {
            removeCotentControllerWidthAnimation(child)
        }
        if !commentTextView.isFirstResponder() {
            commentTextView.resignFirstResponder()
        }
        deselectRowForTable()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        imagePickerController = nil
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictureButton.setBackgroundImage(image, forState: .Normal)
            pictureButton.contentMode = .ScaleAspectFit
            activeImage = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        imagePickerController = nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let previewVC = storyboard?.instantiateViewControllerWithIdentifier("PreviewViewController") as? PreviewViewController, image = activeImage {
            previewVC.previewImage = image
            previewVC.preferredContentSize = CGSizeZero
            previewVC.delegate = self
            if #available(iOS 9.0, *) {
                previewingContext.sourceRect = pictureButton.frame
            } else {
                return nil
            }
            
            return previewVC
        }
        
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
       
        showViewController(viewControllerToCommit, sender: self)
    }
    
    func reselect(previewViewController previewViewController: PreviewViewController) {
        
        showPictureSelection()
    }
    
    func delete(previewViewController previewViewController: PreviewViewController) {
        
        activeImage = nil
        pictureButton.setBackgroundImage(UIImage(named: "camera"), forState: .Normal)
    }    
}
