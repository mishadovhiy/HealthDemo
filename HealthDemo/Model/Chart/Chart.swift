//
//  Chart.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class Chart {
    
    weak var superView:UIView!
    let viewModel:ChartViewModel
    let isPreview:Bool
    var canAnimate = true
    init(superView: UIView!, canAnimate:Bool, viewModel:ChartViewModel, isPreview:Bool = false, avarage:Double? = nil, goal:Double? = nil) {
        self.superView = superView
        self.viewModel = viewModel
        self.isPreview = isPreview
        self.canAnimate = canAnimate
        self.avarage = avarage
        self.goal = goal
        if !canAnimate {
            superView.animatedTransition(0.15)
        }
        create()
    }
    var avarage:Double? = nil
    var goal:Double? = nil
    deinit {
        deinitialize()
    }
    
    func deinitialize() {
        // removeDrawed()
        superView = nil
    }
    
    func create() {
        removeDrawed()
        if !isPreview {
            drawHorizontalSeparetors()
        }
    }
    
    private func removeDrawed() {
        superView.subviews.forEach({
            if $0.layer.name == ChartKeys.primary.rawValue || $0.layer.name == ChartKeys.separetor.rawValue || $0.layer.name == ChartKeys.oval.rawValue {
                $0.removeFromSuperview()
            }
        })
        superView.layer.sublayers?.forEach({
            if $0.name == ChartKeys.primary.rawValue || $0.name == ChartKeys.separetor.rawValue || $0.name == ChartKeys.oval.rawValue || $0.name == ChartKeys.additional1.rawValue || $0.name == ChartKeys.additional2.rawValue {
                $0.removeFromSuperlayer()
            }
        })
        
        
    }
    
    func drawVerticalSeparetors(view:UIView? = nil, i:Int = 0) {
        let step = superView.frame.width / CGFloat(viewModel.dataCount)
        let x = view == nil ? (CGFloat(i) * step) : 0
        let _ = (view ?? superView).layer.drawLine([
            .init(x: x, y: 0), .init(x: x, y: superView.frame.height)
        ], color: separetorColor, opacity: 1, background: .clear, name: ChartKeys.separetor.rawValue, isMultiple: true)
        
//        if let days = viewModel.titledData?.keys.sorted(by: { $0 >= $1}), (days.count - 1) >= i {
//            let day = days[i].dateComponents.stringMonth
//            print(day, " rterfcd")
//            let label = UILabel(frame: .init(origin: .init(x: x, y: 50), size: .init(width: step + 20, height: 20)))
//         //   let date =
//            label.textAlignment = .center
//            label.text = day
//            label.textColor = K.Colors.Text.primary
//            label.font = .systemFont(ofSize: 9, weight: .medium)
//            (superView)?.addSubview(label)
//        }
        
        
        
    }
    
    func drawHorizontalSeparetors() {
        let step:CGFloat = superView.frame.height / CGFloat(viewModel.horizontalSeparetorCount)
        for i in 0..<viewModel.horizontalSeparetorCount {
            let y = step * CGFloat(i)
            let _ = superView.layer.drawLine([
                .init(x: 0, y: y),
                .init(x: superView.frame.width, y: y)
            ], color: separetorColor, opacity: 1, background: .clear, name:ChartKeys.separetor.rawValue, isMultiple: true)
        }
    }
    
    private var separetorColor:UIColor {
        Styles.Graph.separetor
    }
    
    
    func drawAdditional(value:Double, color:UIColor, key:ChartKeys) {
        let y =  superView.frame.height - (superView.frame.height * (value / viewModel.max))
        let primaryView = superView.layer.drawLine([
            .init(x: 0, y: y),
            .init(x: superView.frame.width, y: y)
        ], color: color, width: 2, opacity: 0.5, background: .clear, name: key.rawValue)
        primaryView?.shadow(opasity: Styles.shadow3)
    }
    
}


extension Chart {
    enum ChartKeys:String {
        case primary = "chartline"
        case separetor = "chartSeparetor"
        case oval = "ovalchart"
        case additional1 = "additional1"
        case additional2 = "additional2"

    }
    
    struct ChartViewModel {
        
        let dataCount:Int
        let horizontalSeparetorCount:Int
        let chartData:[Double]
        var max:Double {
            return chartData.max() ?? 0
        }
        
        var horizontalTitles:[String]?
        var titledData:[Date:Double]?
    }
}

