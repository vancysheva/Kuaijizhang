//
//  AddAccountBookViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/22.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class AddAccountBookViewController: UIViewController {
    
    //MARK: - Properties
    
    let covers = ["cover1", "cover2", "cover3", "cover4", "cover5", "cover6"]
    let colorForSelectedItem = UIColor(red: 255/255, green: 254/255, blue: 206/255, alpha: 1.0)
    let textFieldAgent = TextFieldAgent()
    var coverImageName: String?
    var indexPathForUpdate: NSIndexPath?
    var accountBookViewModel: AccountBookViewModel?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverImagesCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = textFieldAgent
        textFieldAgent.addTextFieldTextDidChangeNotification { [unowned self] (notification) -> Void in
            self.saveButton.enabled = self.nameTextField.text?.trim().characters.count > 0
        }
        
        coverImagesCollectionView.delegate = self
        coverImagesCollectionView.dataSource = self
        
        
        coverImagesCollectionView.gestureRecognizers?[0].delegate = self
        
        if let indexPath = indexPathForUpdate, data = accountBookViewModel?.objectAt(indexPath) {
            nameTextField.text = data.title
            coverImageView.image = UIImage(named: data.coverImageName)
        } else {
            saveButton.enabled = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !nameTextField.isFirstResponder() {
            nameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func tapSaveButton(sender: UIBarButtonItem) {
        
        if let title = nameTextField.text, image = coverImageName {
            if let indexPath = indexPathForUpdate {
                accountBookViewModel?.updateAccountBookWithTitle(title, coverImageName: image, atIndex: indexPath.row)
            } else {
                accountBookViewModel?.saveAccountBookWithTitle(title, coverImageName: image)
            }
        }
    }
    
    
    //MARK: - Methods
    
    func setCurrentCoverChecked(index: Int, cell: UICollectionViewCell) {
        coverImageView.image = UIImage(named: covers[index])
        coverImageName = covers[index]
        
        let checkImage = UIImage(named: "check")
        let checkImageView = UIImageView(image: checkImage)
        cell.addSubview(checkImageView)
        checkImageView.frame = CGRect(x: cell.frame.size.width-20, y: cell.frame.size.height-20, width: 20, height: 20)
        checkImageView.contentMode = .ScaleAspectFit
    }
    
    func clearCoverImage() {
        
        for index in 0..<covers.count {
            if let cell = coverImagesCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) where cell.backgroundColor == colorForSelectedItem {
                cell.backgroundColor = UIColor.whiteColor()
                cell.subviews[1].removeFromSuperview()
            }
        }
    }
}


//MARK: - UICollectionViewDataSource

extension AddAccountBookViewController: UICollectionViewDataSource  {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return covers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = coverImagesCollectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: covers[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let footer = coverImagesCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath)
        //// 设置footer的新高度，使footer覆盖剩余的部分，并画两条线
        let screenHeight = UIScreen.mainScreen().bounds.height
        let newFooterHeight = screenHeight - footer.frame.origin.y
        footer.frame = CGRect(x: 0, y: footer.frame.origin.y+1, width: footer.frame.size.width, height: newFooterHeight)
        return footer
    }

}


// MARK: - UICollectionViewDelegate

extension AddAccountBookViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        clearCoverImage()
        
        let cell = coverImagesCollectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = colorForSelectedItem
        setCurrentCoverChecked(indexPath.row, cell: cell!)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            cell.backgroundColor = colorForSelectedItem
            setCurrentCoverChecked(0, cell: cell)
        }
        
        if indexPath.row == (covers.count - 1) {
            if let ip = indexPathForUpdate, imageName = accountBookViewModel?.objectAt(ip).coverImageName, index = covers.indexOf(imageName), cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) {
            clearCoverImage()
               cell.backgroundColor = colorForSelectedItem
               setCurrentCoverChecked(index, cell: cell)
            }
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension AddAccountBookViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (coverImagesCollectionView.frame.size.width - 2) / 3
        let height = width / 0.8
        
        return CGSize(width: width, height: height)
    }
}


// MARK: - UIGestureRecognizerDelegate

extension AddAccountBookViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return nameTextField.endEditing(true)
    }
}
