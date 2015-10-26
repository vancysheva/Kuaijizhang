//
//  ViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import UICountingLabel

class ViewController: UIViewController {
    
    @IBOutlet weak var todayExpenseLabel: UICountingLabel!
    @IBOutlet weak var todayConsumeTypeLabel: UICountingLabel!
    @IBOutlet weak var todayAccountLabel: UICountingLabel!
    @IBOutlet weak var todayCommentLabel: UICountingLabel!
    @IBOutlet weak var weekExpenseLabel: UICountingLabel!
    @IBOutlet weak var monthExpense: UICountingLabel!
    @IBOutlet weak var monthIncomeLabel: UICountingLabel!
    @IBOutlet weak var yearExpenseLabel: UICountingLabel!
    @IBOutlet weak var yearIncomeLabel: UICountingLabel!
    @IBOutlet var rmbLabel: [UILabel]!
    @IBOutlet weak var currentAccountBookLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var columnChartView: ColumnChart!

    @IBAction func tapAccountBookIcon(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapStatementIcon(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapMoreIcon(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapAddBillIcon(sender: UIButton) {
        
    }
    @IBOutlet weak var leftView: UIView! {
        didSet {
            leftView.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
            leftView.backgroundColor = leftView.superview?.backgroundColor
        }
    }
    
    @IBOutlet weak var rightView: UIView! {
        didSet {
            rightView.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
            rightView.backgroundColor = rightView.superview?.backgroundColor
        }
    }
    
    var screenSize: CGSize = {
        return UIScreen.mainScreen().bounds.size
        }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()
        adapteLabelsFont()
        adapteRmbLabels(rmbLabel)
        numberCountingAnimatingWithLabel([todayExpenseLabel, weekExpenseLabel, monthExpense, monthIncomeLabel, yearExpenseLabel, yearIncomeLabel])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

//MARK: - Internal Methods

extension ViewController {
    
    private func adapteLabelFont(label: UILabel) {
        if screenSize.width == 320 && screenSize.height == 480 {
            let fontSize = label.font.pointSize * 0.85
            label.font = UIFont.systemFontOfSize(fontSize)
        }
    }
    
    private func adapteRmbLabels(labels: [UILabel]) {
        if screenSize.width == 320 && screenSize.height == 480 {
            for label in labels {
                label.hidden = true
            }
        }
    }
    
    func numberCountingAnimatingWithLabel(labels: [UICountingLabel]) {
        for label in labels {
            let number: Float = Float(label.text!)!
            if number == 0.0 {
                continue
            }
            label.animationDuration = 1
            label.countFromZeroTo(number)
        }
    }
    
    func adapteLabelsFont() {
        adapteLabelFont(todayExpenseLabel)
        adapteLabelFont(todayConsumeTypeLabel)
        adapteLabelFont(todayAccountLabel)
        adapteLabelFont(todayCommentLabel)
        adapteLabelFont(weekExpenseLabel)
        adapteLabelFont(monthExpense)
        adapteLabelFont(monthIncomeLabel)
        adapteLabelFont(yearExpenseLabel)
        adapteLabelFont(yearIncomeLabel)
    }
    
    func test() {
        var value = [Double]()
        for _ in 1...31 {
            value.append(Double(min(max(arc4random()%800, 1), 800)))
        }
        columnChartView.value = value
        let color = UIColor(red: 33/255, green: 211/255, blue: 158/255, alpha: 1.0)
        columnChartView.colors = [UIColor](count: columnChartView.value!.count, repeatedValue: color)
        columnChartView.showColumnTitle = false
        columnChartView.showYAxis = false
        var labelValues = [String]()
        for index in 1...31 {
            labelValues.append("\(index)")
        }
        columnChartView.columnLabelValue = labelValues
    }
    
    @IBAction func unwindToPortal(segue: UIStoryboardSegue) {
        
        if let vc = segue.sourceViewController as? AccountBookViewController, name = vc.currentAccountBook {
            currentAccountBookLabel.text = name
        }
    }
}

