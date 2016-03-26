//
//  FWChartController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 15/10/27.
//  Copyright © 2015年 范伟. All rights reserved.
//

import Foundation
import Charts
import SnapKit

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
            let bar = chart as! BarChartView
            bar.drawGridBackgroundEnabled = false
            bar.drawMarkers = false
            
            
            let xAxis = bar.xAxis
            xAxis.labelPosition = .Bottom
            xAxis.drawGridLinesEnabled = false
            xAxis.setLabelsToSkip(1)
            bar.legend.enabled = false
            bar.getAxis(.Right).enabled = false
            bar.leftAxis.setLabelCount(4, force: true)
            bar.rightAxis.setLabelCount(4, force: true)
        }
        
        chart?.descriptionText = ""
        return chart!
    }
    
    func chartDataWithStyle(data: [(day: String, value: Double)]) -> ChartData {
        
        var chartData: ChartData?
        
        switch self {
        case .PieChart(let label, let sliceSpace, let colors):
            var labels = [String]()
            var dataEntrys = [ChartDataEntry]()
            
            let index = 0
            for (k, v) in data {
                labels.append(k)
                dataEntrys.append(ChartDataEntry(value: v, xIndex: index.successor()))
            }
            let pieset: PieChartDataSet?  = PieChartDataSet(yVals: dataEntrys, label: label)
            pieset!.sliceSpace = sliceSpace
            if let c = colors {
                pieset!.colors = c
            }
            chartData = PieChartData(xVals: labels, dataSet: pieset)
        case .BarChart(let label):
            var labels = [String]()
            var dataEntrys = [BarChartDataEntry]()
            
            let index = 0
            for (k, v) in data {
                labels.append(k)
                dataEntrys.append(BarChartDataEntry(value: v, xIndex: index.successor()))
            }

            let dataSet = BarChartDataSet(yVals: dataEntrys, label: label)
            chartData = BarChartData(xVals: labels, dataSet: dataSet)
        }
        return chartData!
    }
}


class FWChartController: ChartViewDelegate {
    
    var title: String
    var data: [(day: String, value: Double)]
    var charData: ChartData
    var chart: ChartViewBase
    var chartStyle: FWChartStyle
    
    var chartValueSelected: ((chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) -> Void)?
    
    init(viewForChart view: UIView, chartStyle: FWChartStyle, data: [(day: String, value: Double)], title: String) {
        
        self.title = title
        self.data = data
        self.chartStyle = chartStyle
        
        self.charData = chartStyle.chartDataWithStyle(data)
        self.chart = chartStyle.chartViewWithStyle()
        self.setValueFormatter(nil)
        self.chart.data = self.charData
        
        embedChartForView(view)
        
        self.chart.delegate = self
    }
    
    private func embedChartForView(view: UIView) {
        
        if view.subviews.count == 1 {
            view.subviews[0].removeFromSuperview()
        }
        view.addSubview(chart)
        
        chart.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
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
        self.chart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .Linear)
    }
    
    func addChartValueSelectedHandler( chartValueSelected: (chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) -> Void) {
        self.chartValueSelected = chartValueSelected
    }
    
    //MARK: - Delegate
    @objc func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        self.chartValueSelected?(chartView: chartView, entry: entry, dataSetIndex: dataSetIndex, highlight: highlight)
    }
}