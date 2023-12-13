//
//  ChartFullScreenCell.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 09.12.2023.
//

import UIKit

class BarChartCell: ChartBaseCell {

    @IBOutlet weak var stackView: UIStackView!
    
    override func set(chartData:[Double], canAnimate:Bool, verticalCount:Int, goal:Double?, avarage:Double?, selected: @escaping (Int) -> ()) {

        super.set(chartData: chartData, canAnimate: canAnimate, verticalCount: verticalCount, goal: goal, avarage: avarage, selected: selected)
        let chart = BarChart(stackView: stackView, superView: self, chartData: chartData, vericalCount: verticalCount, canAnimate: canAnimate, avarage: avarage, goal: goal)
        chartModel = chart.viewModel
    }

}

