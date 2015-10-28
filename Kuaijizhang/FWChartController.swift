//
//  FWChartController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/27.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import Charts

enum FWChartStyle {
    case PieChart(label: String?, sliceSpace: CGFloat, colors: [UIColor]?)
    case BarChart(label: String?)
    
    func chartViewWithStyle() -> ChartViewBase {
        var chart: ChartViewBase?
        switch self {
        case .PieChart(let label, _, _):
            var piechart: PieChartView?  = PieChartView()
            piechart?.centerText = label
            chart = piechart!
            piechart = nil
        case .BarChart:
            chart = BarChartView()
        }
        return chart!
    }
    
    func chartDataSetWithStyle(dataEntrys: [ChartDataEntry]) -> ChartDataSet {
        var dataSet: ChartDataSet?
        switch self {
        case .PieChart(let label, let sliceSpace, let colors):
            var pieset: PieChartDataSet?  = PieChartDataSet(yVals: dataEntrys, label: label)
            pieset!.sliceSpace = sliceSpace
            if let c = colors {
                pieset!.colors = c
            }
            dataSet = pieset
            pieset = nil
        case .BarChart(let label):
            dataSet = BarChartDataSet(yVals: dataEntrys, label: label)
        }
        return dataSet!
    }
}


class FWChartController: ChartViewDelegate {
    
    var title: String
    var data: [String: Double]
    var charDataSet: ChartDataSet
    var charData: ChartData
    var chart: ChartViewBase
    var chartStyle: FWChartStyle
    
    var chartValueSelected: ((chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) -> Void)?
    
    init(viewForChart view: UIView, chartStyle: FWChartStyle, data: [String: Double], title: String) {
        
        self.title = title
        self.data = data
        self.chartStyle = chartStyle
        
        var labels = [String]()
        var dataEntrys = [ChartDataEntry]()
        
        var index = 0
        for (k, v) in data {
            labels.append(k)
           dataEntrys.append(ChartDataEntry(value: v, xIndex: index++))
        }
        
        self.charDataSet =  chartStyle.chartDataSetWithStyle(dataEntrys)
        self.charData = ChartData(xVals: labels, dataSet: self.charDataSet)
        self.chart = chartStyle.chartViewWithStyle()
        self.setValueFormatter(nil)
        self.chart.data = self.charData
        
        embedChartForView(view)
        
        self.chart.delegate = self
    }
    
    private func embedChartForView(view: UIView) {
        
        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 9.0, *) {
            let margins = view.layoutMarginsGuide
            chart.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
            chart.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
            chart.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
            chart.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
            
        } else {
            var constraints = [NSLayoutConstraint]()
            constraints.append(NSLayoutConstraint(item: chart, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: chart, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: chart, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: chart, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
            
            view.addConstraints(constraints)
        }
    }
    
    func setValueFormatter(formatter: NSNumberFormatter?) {
        if let f = formatter {
            self.charData.setValueFormatter(f)
        } else {
            switch self.chartStyle {
            case .PieChart:
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .PercentStyle
                numberFormatter.maximumFractionDigits = 1
                numberFormatter.multiplier = 1
                numberFormatter.percentSymbol = " %"
                self.charData.setValueFormatter(numberFormatter)
            default:
                break
            }
        }
    }
    
    func animate() {
        self.chart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .EaseInOutBack)
    }
    
    func addChartValueSelectedHandler( chartValueSelected: (chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) -> Void) {
        self.chartValueSelected = chartValueSelected
    }
    
    //MARK: - Delegate
    @objc func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        self.chartValueSelected?(chartView: chartView, entry: entry, dataSetIndex: dataSetIndex, highlight: highlight)
    }
}