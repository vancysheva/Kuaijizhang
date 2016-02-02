//
//  ViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/17.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import UICountingLabel
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var todayExpenseLabel: CountingLabel!
    @IBOutlet weak var todayConsumeTypeLabel: UICountingLabel!
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
    
    var barChartController: FWChartController?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        
        ////  设置右上角的正在使用的账本名称
        setCurrentAccountBook()
        adapteLabelsFont()
        adapteRmbLabels(rmbLabel)
        // 设置面板中日期
        setDate()
        updateUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //// 设置左上角的年月
        monthLabel.text = DateHelper.getCurrentMonth()
        yearLabel.text = "月/\(DateHelper.getCurrentYear())"
        updateUI()
        
    }
    
    @IBAction func unwindToPortal(segue: UIStoryboardSegue) {
        
        if let vc = segue.sourceViewController as? AccountBookViewController {
            setCurrentAccountBook()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navi = segue.destinationViewController as? UINavigationController, vc = navi.visibleViewController as? AddBillViewController {
            vc.portalController = self
        }
    }
}

//MARK: - Methods

extension ViewController {
    
    func adapteLabelsFont() {
        adapteLabelFont(todayExpenseLabel)
        adapteLabelFont(todayConsumeTypeLabel)
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
    
    func setDate() {
        todayDisplayLabel.text = DateHelper.getCurrentDate()
        weekDisplayLabel.text = "\(DateHelper.getStartWeekDisplayStringFromCurrentWeek())-\(DateHelper.getOverWeekDisplayStringFromCurrentWeek())"
        monthDisplayLabel.text = "\(DateHelper.getStartMonthDisplayStringFromCurrentMonth())-\(DateHelper.getOverMonthDisplayStringFromCurrentMonth())"
        yearDisplayLabel.text = "\(DateHelper.getCurrentYear())\(DateHelper.YearStr)"
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
        
        let data = portalViewModel.getChartDataByCurrentMonth()
        
        barChartController = FWChartController(viewForChart: columnChartView, chartStyle: .BarChart(label: "test"), data: data, title: "")
        
        barChartController?.animate()
    }
    
    // 设置首页账本相关的内容
    func setCurrentAccountBook() {
        let accountBookTitle = portalViewModel.getCurrentAccountBookTitle()
        currentAccountBookLabel.text = accountBookTitle
    }
    
    func updateTodayUI() {
    
        let latestBill = portalViewModel.getLatestBill()

        todayConsumeTypeLabel.text = "最近一笔 \(latestBill.consumeptionTypeName) \(latestBill.money)"
        
        todayCommentLabel.text = latestBill.comment
        
        todayExpenseLabel.text = "\(portalViewModel.getTodayTotalExpense())"
        //numberCountingAnimatingWithLabel([todayExpenseLabel])
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

