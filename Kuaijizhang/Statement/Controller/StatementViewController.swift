//
//  StatementViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/8/18.
//  Copyright © 2015年 范伟. All rights reserved.
//

import UIKit
import Charts

class StatementViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pieChartBtn: UIButton! {
        didSet {
            pieChartBtn.enabled = false
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var columnChartBtn: UIButton!
    
    @IBOutlet weak var statementTableView: UITableView! {
        didSet {
            statementTableView.tableFooterView = UIView()
        }
    }
    
    var chartController: FWChartController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        chartController = FWChartController(viewForChart: containerView, chartStyle: .PieChart(label: "消费类型", sliceSpace: 2, colors: ChartColorTemplates.joyful()), data: getData(), title: "Test")
        //chartController?.addChartValueSelectedHandler { (chartView, entry, dataSetIndex, highlight) -> Void in
            //print(dataSetIndex, "closure")
        //}
        
        chartController?.animate()
        
    }
    
    @IBAction func tapPieChartBtn(sender: UIButton) {
        
        updateButtonStateWith(sender, otherBtn: columnChartBtn)
        statementTableView.removeFromSuperview()
    }
    
    @IBAction func tapColumnChartBtn(sender: UIButton) {
        
        if containerView.subviews.count > 0 {
            //containerView.subviews[0].removeFromSuperview()
        }
        containerView.addSubview(statementTableView)
        statementTableView.frame = containerView.bounds
        
        if statementTableView.delegate == nil {
            statementTableView.delegate = self
            statementTableView.dataSource = self
        }
        
        updateButtonStateWith(sender, otherBtn: pieChartBtn)
    }
    
    func updateButtonStateWith(tappedBtn: UIButton, otherBtn: UIButton) {
       
        if tappedBtn.enabled == true {
            let bColor = tappedBtn.backgroundColor
            let tColor = tappedBtn.tintColor
            
            tappedBtn.backgroundColor = otherBtn.backgroundColor
            tappedBtn.tintColor = otherBtn.tintColor
            
            otherBtn.backgroundColor = bColor
            otherBtn.tintColor = tColor
            
            tappedBtn.enabled = false
            otherBtn.enabled = true
        }
    }
    
    @IBAction func previousBtn(sender: UIButton) {
      
        
    }
    
    @IBAction func nextBtn(sender: UIButton) {
        chartController?.animate()
    }
    
    func getData() -> [(day: String, value: Double)] {
        
        return [(day: "吃", value: 5),
                (day: "穿", value: 15),
                (day: "住", value: 35),
                (day: "行", value: 15),
                (day: "吃", value: 100),
                (day: "吃", value: 100)]
    }
}

//MARK: - Delegate and Datasource

extension StatementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = statementTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StatementViewCell
        cell.data = (getData())[indexPath.row]
        return cell
    }
}
