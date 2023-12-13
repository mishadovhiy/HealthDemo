//
//  ChartBaseCell.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import UIKit

class ChartBaseCell:ClearCollectionCell {
    
    var chartModel:Chart.ChartViewModel?
    var chartSelected:((_ at:Int)->())?
    
    func set(chartData:[Double], canAnimate:Bool, verticalCount:Int, goal:Double?, avarage:Double?, selected:@escaping(_ at:Int)->()) {
        chartSelected = selected
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first?.location(in: self) else {
            return
        }
        let step = contentView.frame.width / CGFloat(chartModel?.dataCount ?? 0)
        let i = touch.x / step
        print(i, " hfgd")
        chartSelected?(Int(i))

    }
}


