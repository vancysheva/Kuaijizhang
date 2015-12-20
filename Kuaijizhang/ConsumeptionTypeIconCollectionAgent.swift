//
//  ConsumeptionTypeIconCollectionAgent.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/12/14.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit

class ConsumeptionTypeIconCollectionAgent: NSObject {
    
    let colorForSelectedItem = UIColor(red: 255/255, green: 254/255, blue: 206/255, alpha: 1.0)
    
    var icons: [String]
    var selectedhandler: ((iconName: String)->Void)?
    var collectionReceiveTouch: (()->Bool)?
    var selectedIconName: String
    var selectedFirstIcon: Bool = true
    
    override init() {
        self.icons = [String]()
        self.selectedIconName = ""
        super.init()
        self.icons = readIcons()
        self.selectedIconName = self.icons[0]
    }
    
    func readIcons() -> [String] {
        
        var diyIcons = [String]()
        for i in 1...48 {
            diyIcons.append("icon-\(i)")
        }
        
        var preDefinedIcons = [String]()
        let realm = RealmModel<ConsumeptionType>()
        realm.realm.objects(ConsumeptionType.self).filter("iconName != ''").forEach {
            preDefinedIcons.append($0.iconName)
        }
        
        return diyIcons + preDefinedIcons
    }
    
    func addIconSelectedHandler(handler: (iconName: String)->Void) {
        selectedhandler = handler
    }
    
    func addCollectionRecieveTouch(handler: ()->Bool) {
        collectionReceiveTouch = handler
    }
    
    func setSelectedIconForFirstItem(iconName: String) {
        
        if let index = icons.indexOf(iconName) {
            icons.removeAtIndex(index)
            icons.insert(iconName, atIndex: 0)
        }
    }
    
    func setCurrentCoverChecked(index: Int, cell: UICollectionViewCell) {
        
        selectedIconName = icons[index]
        selectedhandler?(iconName: icons[index])
        
        let checkImage = UIImage(named: "check")
        let checkImageView = UIImageView(image: checkImage)
        cell.addSubview(checkImageView)
        cell.backgroundColor = colorForSelectedItem
        checkImageView.frame = CGRect(x: cell.frame.size.width-20, y: cell.frame.size.height-20, width: 20, height: 20)
        checkImageView.contentMode = .ScaleAspectFit
    }
}

extension ConsumeptionTypeIconCollectionAgent: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: icons[indexPath.row])
        
        if indexPath.row == 0 {
            setCurrentCoverChecked(0, cell: cell)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        for index in 0..<icons.count {
            if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) where cell.backgroundColor == colorForSelectedItem {
                cell.backgroundColor = UIColor.whiteColor()
                cell.subviews[1].removeFromSuperview()
            }
        }
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        setCurrentCoverChecked(indexPath.row, cell: cell!)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConsumeptionTypeIconCollectionAgent: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 4) / 6
        let height = width
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ConsumeptionTypeIconCollectionAgent: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return collectionReceiveTouch?() ?? false
    }
}

