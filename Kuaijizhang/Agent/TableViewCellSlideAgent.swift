//
//  TableViewCellSlideAgent.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/1/1.
//  Copyright © 2016年 范伟. All rights reserved.
//

import Foundation
import SWTableViewCell

class TableViewCellSlideAgent: NSObject {
    
    typealias SwipeableTableViewCell1 = (cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex: Int) -> Void
    typealias SwipeableTableViewCell2 = (cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex: Int) -> Void
    typealias SwipeableTableViewCell3 = (cell: SWTableViewCell!, scrollingToState: SWCellState) -> Void
    typealias SwipeableTableViewCellShouldHideUtilityButtonsOnSwipe = (cell: SWTableViewCell!) -> Bool
    typealias SwipeableTableViewCell = (cell: SWTableViewCell!, canSwipeToState: SWCellState) -> Bool
    typealias SwipeableTableViewCellDidEndScrolling = (cell: SWTableViewCell!) -> Void
    
    private var swipeableTableViewCell1: SwipeableTableViewCell1?
    private var swipeableTableViewCell2: SwipeableTableViewCell2?
    private var swipeableTableViewCell3: SwipeableTableViewCell3?
    private var swipeableTableViewCellShouldHideUtilityButtonsOnSwipe: SwipeableTableViewCellShouldHideUtilityButtonsOnSwipe?
    private var swipeableTableViewCell: SwipeableTableViewCell?
    private var swipeableTableViewCellDidEndScrolling: SwipeableTableViewCellDidEndScrolling?
    
}

extension TableViewCellSlideAgent {
    
    func addTriggerLeftUtilityButtonHandler(handler: SwipeableTableViewCell1) {
        swipeableTableViewCell1 = handler
    }
    
    func addTriggerRightUtilityButtonHandler(handler: SwipeableTableViewCell2) {
        swipeableTableViewCell2 = handler
    }
    
    func addScrollingToStateHandler(handler: SwipeableTableViewCell3) {
        swipeableTableViewCell3 = handler
    }
    
    func addSwipeableTableViewCellShouldHideUtilityButtonsOnSwipe(handler: SwipeableTableViewCellShouldHideUtilityButtonsOnSwipe) {
        swipeableTableViewCellShouldHideUtilityButtonsOnSwipe = handler
    }
    
    func addSwipeableTableViewCellCanSwipeToState(handler: SwipeableTableViewCell) {
        swipeableTableViewCell = handler
    }
    
    func addSwipeableTableViewCellDidEndScrolling(handler: SwipeableTableViewCellDidEndScrolling) {
        swipeableTableViewCellDidEndScrolling = handler
    }
}

extension TableViewCellSlideAgent: SWTableViewCellDelegate {
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        swipeableTableViewCell1?(cell: cell, didTriggerLeftUtilityButtonWithIndex: index)
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        swipeableTableViewCell2?(cell: cell, didTriggerRightUtilityButtonWithIndex: index)
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        swipeableTableViewCell3?(cell: cell, scrollingToState: state)
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return swipeableTableViewCellShouldHideUtilityButtonsOnSwipe?(cell: cell) ?? true
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, canSwipeToState state: SWCellState) -> Bool {
        return swipeableTableViewCell?(cell: cell, canSwipeToState: state) ?? true
    }
    
    func swipeableTableViewCellDidEndScrolling(cell: SWTableViewCell!) {
        swipeableTableViewCellDidEndScrolling?(cell: cell)
    }
}