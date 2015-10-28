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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartController = FWChartController(viewForChart: containerView, chartStyle: .PieChart(label: "消费类型", sliceSpace: 2, colors: ChartColorTemplates.joyful()), data: getData(), title: "Test")
        chartController.addChartValueSelectedHandler { (chartView, entry, dataSetIndex, highlight) -> Void in
            print(dataSetIndex, "closure")
        }
        
        chartController.animate()
        
    }
    
    @IBAction func tapPieChartBtn(sender: UIButton) {
        
        updateButtonStateWith(sender, otherBtn: columnChartBtn)
    }
    
    @IBAction func tapColumnChartBtn(sender: UIButton) {
        
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
        
    }
    
    func getData() -> [String: Double] {
        
        var data = [String: Double]()
        var labels = ["吃", "穿", "住", "行", "其他"]
        
        for i in 0...4 {
           data[labels[i]] = Double(100 + ((i+1) * 25))
        }
        return data
    }
}
