//
//  LineChart.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class LineChart:Chart {
    
    init(superView: UIView!, isPreview:Bool = false, chartData:[Double], vericalCount:Int, canAnimate:Bool, goal:Double? = nil, avarage:Double? = nil, titledData:[Date:Double]? = nil) {
        
        super.init(superView: superView, canAnimate: canAnimate, viewModel: .init(dataCount: vericalCount, horizontalSeparetorCount: 4, chartData: chartData, titledData: titledData), isPreview: isPreview, avarage: avarage, goal: goal)
        
    }
    
    override func create() {
        super.create()
        let color:UIColor = Styles.Graph.tint
        let viewWidth = superView.frame.width / CGFloat(viewModel.dataCount)
        let lineWidth:CGFloat = Styles.Graph.lineWidth
        
        var yValues:[CGPoint] = []
        for i in 0..<viewModel.dataCount {
            let value:CGFloat = viewModel.chartData.count - 1 >= i ? viewModel.chartData[i] : 0
            let percent = viewModel.max == 0 ? 0 : ((value) / viewModel.max)
            yValues.append(.init(x: viewWidth * (CGFloat(i) + 0.5), y: superView.frame.height - (percent * superView.frame.height)))
        }
        
        if !isPreview {
            drawSeparetors()
        }
        
        drawChart(color: color, lineWidth: lineWidth, yValues: yValues, viewWidth: viewWidth)
        
        if let value = avarage {
            drawAdditional(value: value, color: K.Colors.Multicolor.blue, key: .additional1)
        }
        
        if let value = goal {
            drawAdditional(value: value, color: K.Colors.Multicolor.red, key: .additional2)
        }
    }
    
    private func drawSeparetors() {
        for i in 0..<viewModel.dataCount {
            drawVerticalSeparetors(i:i)
        }
    }
    
    private func drawChart(color:UIColor,
                           lineWidth:CGFloat,
                           yValues:[CGPoint], viewWidth:CGFloat) {
        let primary = superView.layer.drawLine(yValues, color: color, width: lineWidth, opacity: 1, background: .clear, name: ChartKeys.primary.rawValue)
        if !isPreview {
            primary?.shadow(opasity: Styles.Graph.shadowOpacity)
        }
        if isPreview || canAnimate {
            primary?.strokeEnd = 0
            primary?.animate(value: (from: 0, to: 1), key: .strokeEnd, duration: 1, completion: {
                
            })
        }
        if !isPreview {
            yValues.forEach({
                let view = UIView()
                let size:CGFloat = Styles.Graph.ovalSize
                view.frame = .init(origin: .init(x: $0.x - size / 2, y: $0.y - size / 2), size: .init(width: size, height: size))
                view.layer.cornerRadius = size / 2
                view.backgroundColor = K.Colors.primaryBackground
                view.layer.borderWidth = lineWidth
                view.layer.borderColor = color.cgColor
                view.layer.name = ChartKeys.oval.rawValue
                view.layer.shadow(opasity: Styles.Graph.shadowOpacity)
                superView.addSubview(view)
            })
        }
        
    }
    
}
