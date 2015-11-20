//
//  ViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import UICountingLabel
import RealmSwift

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
    @IBOutlet weak var todayDisplayLabel: UILabel!
    @IBOutlet weak var weekDisplayLabel: UILabel!
    @IBOutlet weak var monthDisplayLabel: UILabel!
    @IBOutlet weak var yearDisplayLabel: UILabel!
    
    @IBOutlet weak var columnChartView: ColumnChart!
    
    var screenSize: CGSize = {
        return UIScreen.mainScreen().bounds.size
    }()

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
    
    let portalViewModel = PortalViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        
        ////  设置右上角的正在使用的账本名称
        setCurrentAccountBook()
        
        adapteLabelsFont()
        adapteRmbLabels(rmbLabel)
        
        // 设置面板中日期
        todayDisplayLabel.text = DateHelper.getCurrentDate()
        weekDisplayLabel.text = "\(DateHelper.getStartWeekDisplayStringOfPeriodWeek())-\(DateHelper.getOverWeekDisplayStringOfPeriodWeek())"
        monthDisplayLabel.text = "\(DateHelper.getStartMonthDisplayStringOfPeriodMonth())-\(DateHelper.getOverMonthDisplayStringOfPeriodMonth())"
        yearDisplayLabel.text = "\(DateHelper.getCurrentYear())\(DateHelper.YearStr)"
        
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //// 设置左上角的年月
        monthLabel.text = DateHelper.getCurrentMonth()
        yearLabel.text = "月/\(DateHelper.getCurrentYear())"
    }
    
    @IBAction func unwindToPortal(segue: UIStoryboardSegue) {
        
        if let vc = segue.sourceViewController as? AccountBookViewController {
            setCurrentAccountBook()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}

//MARK: - Methods

extension ViewController {
    
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
    
    func updateUI() {
        renderChart() //// 设置柱状图数据
        updateTodayUI() //设置最近一笔支出或收入
        updateCurrentWeekUI()
        updateCurrentMonthUI()
        updateCurrentYearUI()
    }
    
    func adapteLabelFont(label: UILabel) {
        
        if screenSize.width == 320 && screenSize.height == 480 {
            let fontSize = label.font.pointSize * 0.85
            label.font = UIFont.systemFontOfSize(fontSize)
        }
    }
    
    func adapteRmbLabels(labels: [UILabel]) {
        
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
    
    func renderChart() {
        var value = [Double]()
        let range = DateHelper.getRangeOfCurrentMonth()
        for _ in range.location...range.length {
            value.append(Double(min(max(arc4random()%800, 1), 800)))
        }
        columnChartView.value = value
        let color = UIColor(red: 33/255, green: 211/255, blue: 158/255, alpha: 1.0)
        columnChartView.colors = [UIColor](count: columnChartView.value!.count, repeatedValue: color)
        columnChartView.showColumnTitle = false
        columnChartView.showYAxis = false
        var labelValues = [String]()
        for index in range.location...range.length {
            labelValues.append("\(index)")
        }
        columnChartView.columnLabelValue = labelValues
        
        let dataDic = portalViewModel.getChartDataByCurrentMonth()
    }
    
    // 设置首页账本相关的内容
    func setCurrentAccountBook() {
        currentAccountBookLabel.text = portalViewModel.getCurrentAccountBookTitle()
    }
    
    func updateTodayUI() {
    
        let latestBill = portalViewModel.getLatestBill()
        (todayConsumeTypeLabel.text, todayAccountLabel.text, todayCommentLabel.text) = latestBill
        
        todayExpenseLabel.text = "\(portalViewModel.getTodayTotalExpense())"
        numberCountingAnimatingWithLabel([todayExpenseLabel])
    }
    
    func updateCurrentWeekUI() {
        weekExpenseLabel.text = "\(portalViewModel.getCurrentWeekExpense())"
        numberCountingAnimatingWithLabel([weekExpenseLabel])
    }
    
    func updateCurrentMonthUI() {
        monthExpense.text = "\(portalViewModel.getCurrentMonthExpense())"
        monthIncomeLabel.text = "\(portalViewModel.getCurrentMonthIncome())"
        numberCountingAnimatingWithLabel([monthExpense, monthIncomeLabel])
    }
    
    func updateCurrentYearUI() {
        yearExpenseLabel.text = "\(portalViewModel.getCurrentYearExpense())"
        yearIncomeLabel.text = "\(portalViewModel.getCurrentYearIncome())"
        numberCountingAnimatingWithLabel([yearExpenseLabel, yearIncomeLabel])
    }
}

