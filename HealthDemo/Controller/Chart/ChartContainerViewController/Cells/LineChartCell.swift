//
//  LineChartCell.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class LineChartCell: ChartBaseCell {
    
    override func set(chartData:[Double], canAnimate:Bool, verticalCount:Int, goal:Double?, avarage:Double?, selected: @escaping (Int) -> ()) {
        let chart = LineChart(superView: self, chartData: chartData, vericalCount: verticalCount, canAnimate: canAnimate, goal:goal, avarage: avarage)
        chartModel = chart.viewModel
        super.set(chartData: chartData, canAnimate: canAnimate, verticalCount: verticalCount, goal: goal, avarage: avarage, selected: selected)
    }
}

