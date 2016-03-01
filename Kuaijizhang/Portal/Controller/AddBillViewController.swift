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
    
    @IBOutlet var childView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editComponentButton: UIButton!
    
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
    
    @IBAction func tapSlideDownButton(sender: UIButton) {
        removeComponentWithAnimation()
    }
    
    @IBAction func tapCancelBarButtonItem(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapSaveBarButtonItem(sender: UIBarButtonItem) {
        saveBill()
    }
    
    @IBAction func tapBillTypeButton(sender: UIButton) {
        toggleBillType()
        toggleConsumeType()
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
    
    var billStreamViewModel: BillStreamViewModel?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(childView)
        childView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height*0.4)
        
        commentTextView.delegate = self
        navigationController?.delegate = self

        initButtonWithBorderStyle(saveTemplateButton)
        initButtonWithBorderStyle(saveButton)
        
        
        if billStreamViewModel != nil {
            updateAddBillData()
            hideSomeComponents()
        } else {
            consumeTypeLabel.text = addBillViewModel.getConsumeptionTypeDescription(billType)
            accountLabel.text = addBillViewModel.getAccountDescription()
            setConsumeptionTypeNameImage()
            selectFirstRowAndDisplayNumPad()
            
            dateLabel.text = addBillViewModel.getCurrentTime()
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        
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
    
    func hideSomeComponents() {
        
        billTypeButton.hidden = true
        arrowImage.hidden = true
        saveTemplateButton.hidden = true
    }
    
    func toggleBillType() {
        billType.toggle()
        billTypeButton.setTitle(billType.title, forState: .Normal)
        
        let duration: NSTimeInterval = 0.25
        let delay: NSTimeInterval = 0
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, CGFloat(M_PI))
            }, completion: nil)
    }
    
    func toggleConsumeType() {
        
        moneyLabel.textColor = billType.color
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
                self.addContentControllerWithAnimation(vc)
                self.hide()
            }
        }
    }
    
    func hide() {
        editComponentButton.hidden = true
    }
    
    func show() {
        editComponentButton.hidden = false
    }
    
    func initButtonWithBorderStyle(button: UIButton) {
        
        button.layer.borderWidth = 1
        let color = UIColor(red: 27/255, green: 128/255, blue: 251/255, alpha: 1.0)
        button.layer.borderColor = color.CGColor
        button.layer.cornerRadius = 5
    }
    
    func addContentControllerWithAnimation(contentController: UIViewController) {

        addChildViewController(contentController)
        contentController.view.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        containerView.addSubview(contentController.view)
        contentController.didMoveToParentViewController(self)

        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.childView.frame.origin.y = self.view.frame.height - self.childView.frame.height
        }, completion: nil)
    
    }
    
    func removeContentController(contentController: UIViewController) {
        
        contentController.willMoveToParentViewController(self)
        contentController.view.removeFromSuperview()
        contentController.removeFromParentViewController()
    }
    
    func removeCotentControllerWidthAnimation(contentController: UIViewController) {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.childView.frame.origin.y += self.childView.frame.height
            }) { bo in
                self.removeContentController(contentController)
        }
    }
    
    func removeComponent() {
        
        if childViewControllers.count == 1 {
            childView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height*0.4)
            removeContentController(childViewControllers[0])
        }
    }
    
    func removeComponentWithAnimation() {

        if childViewControllers.count == 1 {
            removeCotentControllerWidthAnimation(childViewControllers[0])
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
        
        if let viewModel = billStreamViewModel {
            viewModel.updateBillCurrying?(addBillViewModel, commentTextView.text)
        } else {
            addBillViewModel.saveBill(commentTextView.text)
        }
        
    }
    
    func updateAddBillData() {
        
        billType = BillType(rawValue: Int(addBillViewModel.parentConsumpetionType?.type ?? "0")!)!
        
        if let img = addBillViewModel.image {
            pictureButton.setBackgroundImage(UIImage(data: img), forState: .Normal)
            pictureButton.contentMode = .ScaleAspectFit
        }
        
        moneyLabel.text = "\(addBillViewModel.money)"
         
        consumeptionTypeImageView.image = UIImage(named: addBillViewModel.childConsumpetionType?.iconName ?? "")
        
        if let parentConsumeptionType = addBillViewModel.parentConsumpetionType, childConsumeptionType = addBillViewModel.childConsumpetionType {
            consumeTypeLabel.text = "\(parentConsumeptionType.name)>\(childConsumeptionType.name)"
            moneyLabel.textColor = BillType(rawValue: Int(parentConsumeptionType.type) ?? 0)?.color
        }
        
        if let childAccount = addBillViewModel.childAccount {
            accountLabel.text = childAccount.name
        }
        
        if let date = addBillViewModel.date {
            dateLabel.text = date
        }
        
        tagLabel.text = addBillViewModel.subject?.name
        
        if let comment = addBillViewModel.comment {
            commentTextView.text = comment
        }
    }
}

// MARK: - Delegate

extension AddBillViewController: ComponentViewControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UIViewControllerPreviewingDelegate, PreviewViewControllerDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let row = activeRow where row == indexPath.row {
            return
        }
        
        activeRow = indexPath.row
        
        removeComponent()
        
        commentTextView.resignFirstResponder()
        
        show()
        
        editComponentButton.off()
        
        switch indexPath.row {
        case 0:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("NumberPadViewController") as! NumberPadViewController
            vc.delegate = self
            hide()
            addContentControllerWithAnimation(vc)
        case 1:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("ConsumeptionTypePickerViewController") as! ConsumeptionTypePickerViewController
            
            vc.delegate = self
            addContentControllerWithAnimation(vc)
            
            editComponentButton.on(.TouchUpInside) { (gesture) -> Void in
                vc.tapEditButton()
            }
        case 2:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("AccountPickerViewController") as! AccountPickerViewController
            
            vc.delegate = self
            addContentControllerWithAnimation(vc)
            
            editComponentButton.on(.TouchUpInside) { (gesture) -> Void in
                vc.tapEditButton()
            }
        case 3:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("DateViewController") as! DateViewController
            vc.delegate = self
            hide()
            addContentControllerWithAnimation(vc)
        case 4:
            let vc = storyboard?.instantiateViewControllerWithIdentifier("LabelTableViewController") as! LabelTableViewController
            
            vc.delegate = self
            addContentControllerWithAnimation(vc)
            
            editComponentButton.on(.TouchUpInside) { (gesture) -> Void in
                vc.tapEditButton()
            }        default:
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
        
        removeComponent()
        deselectRowForTable()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if childViewControllers.count == 0 {
            return
        }
        removeComponentWithAnimation()
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
