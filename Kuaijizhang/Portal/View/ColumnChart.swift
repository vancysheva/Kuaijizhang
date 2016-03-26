//
//  Chart.swift
//  Chart
//
//  Created by 范伟 on 15/6/1.
//  Copyright (c) 2015年 范伟. All rights reserved.
//

import UIKit

enum LabelDisplayStyle {
    case AUTO, WRAP, STAGGER, ROTATE, NONE
}

@IBDesignable
class ColumnChart: UIView {
    // 数值
    var value: [Double]? {
        didSet {
            if value != nil {
                colors = ColorBox.randomColors(value!.count)
            }
        }
    }
    // 标题
    var caption: String?
    private var captionRect: CGRect?
    // 子标题
    var subCaption: String?
    private var subCaptionRect: CGRect?
    // 水平线
    var trendLines: [Double]?
    // x轴名字
    var xaxisName: String?
    // y轴名字
    var yaxisName: String?
    var showXAxis: Bool = true
    var showYAxis: Bool = true
    var xAxisLabels: [String]?
    var yaxisMaxValue: Double {
        get {
            if let v = value {
                return v.maxElement()!
            } else {
                return 0
            }
        }
    }
    // y轴名字单位
    var yaxisNameUnit: String?
    var yaxisDivide: Int = 3
    
    var showYAxisValues: Bool = true
    var showDivLineValues: Bool = true
    var showColumnTitle: Bool = true
    var showColumnLabel: Bool = true
    var columnLabelValue: [String]?
    // x轴值显示方式
    var labelDisplay: LabelDisplayStyle = LabelDisplayStyle.NONE
    // x轴步长
    var labelStep: Int = 1
    // 背景图片
    var bgColor: UIColor = UIColor.whiteColor()
    var colors: [UIColor]?
    
    var originPoint: CGPoint {
        return CGPoint(x: 30, y: bounds.size.height - 20)
    }
    
    var xDirectionPoint: CGPoint {
        return CGPoint(x: bounds.size.width - 20, y: bounds.size.height - 20)
    }
    var yDirectionPoint: CGPoint {
        return CGPoint(x:30, y: 10)
    }
    
    var xaxisLength: CGFloat {
        return xDirectionPoint.x - originPoint.x
    }
    
    var yaxisHeight: CGFloat {
        return  originPoint.y - yDirectionPoint.y
    }
    
    override func prepareForInterfaceBuilder() {
        var value = [Double]()
        for _ in 1...31 {
            value.append(Double(min(max(arc4random()%800, 1), 800)))
        }
        self.value = value
        let color = UIColor(red: 33/255, green: 211/255, blue: 158/255, alpha: 1.0)
        self.colors = [UIColor](count: self.value!.count, repeatedValue: color)
        self.showColumnTitle = false
        self.showYAxis = false
        var labelValues = [String]()
        for index in 1...31 {
            labelValues.append("\(index)")
        }
        self.columnLabelValue = labelValues
    }
   
    
    override func drawRect(rect: CGRect) {

        if value != nil && value?.count > 0 {
            clearLayers()
            drawCoordinate()
            captionRect = drawCaption()
            subCaptionRect = drawSubCaption()
            let (columnWidth, columnStartPoints) = analysisColumnPosition(value!.count)
            let columnOverPoints = analysisColumnHeight(value!, startPoint: columnStartPoints)
            drawAllColumns(columnWidth, columnStartPoints: columnStartPoints, columnOverPoints: columnOverPoints, columnTitle: value!)
        }
    }
    
    // 清除柱状图 标签等
    func clearLayers() {
        if let lay = layer.sublayers {
            for l in lay {
                l.removeFromSuperlayer()
            }
        }
    }
    
    func drawCaption() -> CGRect{
        if caption == nil { return CGRectZero }
        let text = NSMutableAttributedString(string: caption!)
        text.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: NSMakeRange(0, text.length))
        let point = CGPointMake((bounds.width-text.size().width)/2, 15)
        text.drawAtPoint(point)
        return CGRect(origin: point, size: text.size())
    }
    
    func drawSubCaption() -> CGRect {
        if subCaption == nil { return CGRectZero }
        
        let text = NSMutableAttributedString(string: subCaption!)
        text.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange(0, text.length))
        let point = CGPointMake((bounds.width-text.size().width)/2, captionRect == nil ? 15 : (captionRect!.width == 0 ? 15 : captionRect!.origin.y + captionRect!.height + 10))
        text.drawAtPoint(point)
        return CGRect(origin: point, size: text.size())
    }

    
    // MARK: 画坐标轴
    func drawCoordinate() {
        if value == nil || value?.count == 0 { return }
        
        let maxValue = value?.maxElement()
        
        let linePath = UIBezierPath()
        if showXAxis {
            let color = UIColor(red: 33/255, green: 211/255, blue: 158/255, alpha: 1.0)
            color.setStroke()
            linePath.moveToPoint(originPoint)
            linePath.addLineToPoint(xDirectionPoint)
        }
        if showYAxis {
            linePath.moveToPoint(originPoint)
            linePath.addLineToPoint(yDirectionPoint)
        }
        linePath.stroke()
        
        // 画Y轴标题
        if let yaxisTitle = yaxisName {
            if originPoint.x > 25 {
                let sizeForYaxisName = NSAttributedString(string: yaxisTitle).size()
                let index = 0
                for c in yaxisTitle.characters {
                    index.successor()
                    let yTitle = NSAttributedString(string: "\(c)")
                    let x = (yDirectionPoint.x - yTitle.size().width)/2
                    let y = yDirectionPoint.y + (yaxisHeight - sizeForYaxisName.width)/2 + yTitle.size().height * CGFloat(index) + 1
                    let yTitlePoint = CGPoint(x: x, y: y)
                    yTitle.drawAtPoint(yTitlePoint)
                    
                }

            }
        }
        if yaxisDivide != 0 {
            // 画横断线和y轴标值
            let divideHeight = round(yaxisHeight / CGFloat(yaxisDivide+1))
            let maxNum = value?.maxElement()
            let divideValue = round(CGFloat(maxNum!) / CGFloat(yaxisDivide+1))
            for index in  1...(yaxisDivide+1) {
                let startPoint = CGPoint(x: originPoint.x, y: originPoint.y - CGFloat(index) * divideHeight)
                let endPoint = CGPoint(x: xDirectionPoint.x, y: startPoint.y)
                
                if showDivLineValues {
                    let dividePath = UIBezierPath()
                    dividePath.moveToPoint(startPoint)
                    dividePath.addLineToPoint(endPoint)
                    UIColor.lightGrayColor().setStroke()
                    dividePath.stroke()
                }
                
                // 保留整数处理
                let string = String(format: "%.0f", divideValue * CGFloat(index))
                let yAxisValue = NSMutableAttributedString(string: string)
                yAxisValue.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(0, yAxisValue.length))
                yAxisValue.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: NSMakeRange(0, yAxisValue.length))
                let point = CGPoint(x: startPoint.x - 2 - yAxisValue.size().width, y: startPoint.y - yAxisValue.size().height/2)
                yAxisValue.drawAtPoint(point)
            }
        } else {
            let yNumber = NSMutableAttributedString(string: "\(maxValue)")
            let size = yNumber.size()
            let yNumberPoint = CGPoint(x: yDirectionPoint.x - size.width/2, y: yDirectionPoint.y - size.height - CGFloat(10))
            yNumber.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11), range: NSMakeRange(0, yNumber.length))
            yNumber.drawAtPoint(yNumberPoint)
        }

    }
    
    // MARK: 画所有柱状图
    func drawAllColumns(columnWidth: CGFloat, columnStartPoints: [CGPoint], columnOverPoints: [CGPoint], columnTitle: [Double]) {
        for let i=0; i<columnStartPoints.count; i.successor() {
            
            let lineStartPoint = columnStartPoints[i]
            let lineOverPoint = columnOverPoints[i]
            drawAColumn(lineStartPoint: lineStartPoint, lineOverPoint: lineOverPoint, lineWidth: columnWidth, color: colors![i])
            if showColumnTitle {
                drawAcolumnTitle(colors![i], columnOverPoint: lineOverPoint, title: columnTitle[i])
            }
            
            if i%2 != 0 { continue }
            if showColumnLabel && columnLabelValue != nil {
                drawAcolumnLabel(colors![i], columnStartPoint: lineStartPoint, title: columnLabelValue![i])
            }
            
        }
    }
    
    // MARK: 画柱状图标题
    func drawAcolumnTitle(color: UIColor, columnOverPoint: CGPoint, title: AnyObject) {
        let title = NSMutableAttributedString(string: "\(title)")
        let size = title.size()
        let point = CGPoint(x: columnOverPoint.x - size.width/2, y: columnOverPoint.y - 5 - size.height)
        
        title.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11), range: NSMakeRange(0, title.length))
        title.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, title.length))
        title.drawAtPoint(point)
        
    }
    
    // MARK: - 画柱状图的x轴的标签
    func drawAcolumnLabel(color: UIColor, columnStartPoint: CGPoint, title: AnyObject) {
        let title = NSMutableAttributedString(string: "\(title)")
        let size = title.size()
        let point = CGPoint(x: columnStartPoint.x - size.width/2, y: columnStartPoint.y + 5 )
        
        title.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11), range: NSMakeRange(0, title.length))
        title.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, title.length))
        title.drawAtPoint(point)
    }

    
    // MARK: 画柱状图
    func drawAColumn(lineStartPoint lineStartPoint: CGPoint, lineOverPoint: CGPoint, lineWidth: CGFloat, color: UIColor) {
        
        let columnPath = UIBezierPath()
        columnPath.moveToPoint(lineStartPoint)
        columnPath.addLineToPoint(lineOverPoint)
        
        let pathlayer = CAShapeLayer()
        pathlayer.frame = bounds
        pathlayer.path = columnPath.CGPath
        pathlayer.strokeColor = color.CGColor
        pathlayer.fillColor = nil
        pathlayer.lineWidth = lineWidth
        pathlayer.lineJoin = kCALineJoinBevel
        layer.addSublayer(pathlayer)

        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        
        pathlayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        
    }
    
    
    // MARK: 分析柱状图,返回柱状图宽度和柱状图位置点
    func analysisColumnPosition(columnCount: Int) -> (CGFloat, [CGPoint]) {
        let offsetX = CGFloat(5)
        let xAxisLength = xDirectionPoint.x - originPoint.x - offsetX
        let yForColumn = originPoint.y
        
        let contentWidth = CGFloat(convertNSNumber2Int(xAxisLength.native) / columnCount)
        let columnWith = CGFloat(contentWidth) * 0.85
        var columns = [CGPoint]()
        for index in 0..<columnCount {
            let x = originPoint.x + offsetX + contentWidth * CGFloat(index) + columnWith/2
            let point = CGPoint(x: x , y: yForColumn)
            columns.append(point)
        }
        return (columnWith, columns)
    }
    
    // MARK: 分析柱状图高度
    func analysisColumnHeight(data: [Double], startPoint: [CGPoint]) -> [CGPoint] {
        let num = data.maxElement()
        let tinyHeightForColumn = (originPoint.y - yDirectionPoint.y) / CGFloat(num! + 5)
        var points = [CGPoint]()
        for (index, el) in data.enumerate() {
            let point = CGPoint(x: startPoint[index].x, y: startPoint[index].y - CGFloat(el) * tinyHeightForColumn)
            points.append(point)
        }
        return points
    }
    
    func convertNSNumber2Int(num: NSNumber) -> Int{
        let formatter = NSNumberFormatter()
        formatter.roundingMode = NSNumberFormatterRoundingMode.RoundCeiling
        return Int(formatter.stringFromNumber(num)!)!
    }
}