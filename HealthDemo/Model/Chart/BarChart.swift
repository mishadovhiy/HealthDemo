//
//  BarChart.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class BarChart:Chart {
    
    weak var stackView:UIStackView!
    
    init(stackView: UIStackView!, superView:UIView, isPreview:Bool = false, chartData:[Double], vericalCount:Int, canAnimate:Bool, avarage:Double? = nil, goal:Double? = nil) {
        self.stackView = stackView
        super.init(superView: superView, canAnimate: canAnimate, viewModel: .init(dataCount: vericalCount, horizontalSeparetorCount: 4, chartData: chartData), isPreview: isPreview, avarage: avarage, goal: goal)
    }
    
    deinit {
        super.deinitialize()
        stackView = nil
    }
    
    override func create() {
        super.create()
        stackView.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        for i in 0..<viewModel.dataCount {
            let value:CGFloat = viewModel.chartData.count - 1 >= i ? viewModel.chartData[i] : 0
            let percent = value / viewModel.max
            addView(percent: percent)
        }
        
        if let value = avarage {
            drawAdditional(value: value, color: K.Colors.Multicolor.blue, key: .additional1)
        }
        
        if let value = goal {
            drawAdditional(value: value, color: K.Colors.Multicolor.red, key: .additional2)
        }
    }
    
    
    
    private func addView(percent:CGFloat) {
        let new = UIView()
        if !isPreview {
            drawVerticalSeparetors(view: new)
        }
        stackView.addArrangedSubview(new)
        drawIn(view: new, percent: percent)
    }
    
    private func drawIn(view:UIView, percent:CGFloat) {
        let color:UIColor = Styles.Graph.tint
        
        let lineWidth:CGFloat = isPreview ? 3 : 6
        let viewWidth = superView.frame.width / CGFloat(viewModel.dataCount)
        let x = viewWidth / 2 - (lineWidth / 2)
        let primaryView = view.layer.drawLine([
            .init(x: x, y: superView.frame.height),
            .init(x: x, y: superView.frame.height - (superView.frame.height * percent))
        ], color: color, width: lineWidth, opacity: 1, background: .clear, name: ChartKeys.primary.rawValue)
        if isPreview || canAnimate {
            primaryView?.strokeEnd = 0
            primaryView?.animate(value: (from: 0, to: 1), key: .strokeEnd, duration: Styles.pressedAnimation, completion: {
                
            })
            primaryView?.cornerRadius(at: .top, value: 2)
        }
        
        if !isPreview {
            primaryView?.shadow(opasity: Styles.Graph.shadowOpacity)
        }
    }
}
