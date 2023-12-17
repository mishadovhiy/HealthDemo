//
//  HomeHealthDataCell.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class HomeHealthDataCell: ClearCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var chartStack:UIStackView!
    @IBOutlet weak var chartSuperView:UIView!
    weak var chart:Chart?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.setSelectionBackground(view: contentView.subviews.first(where: {$0 is BaseView})!)
        createTouchView()
    }
    
    func set(_ initialData:InitialData, chartData:[Double]) {
        let message = (initialData.data.key?.message ?? initialData.data.category?.message)
        categoryTitleLabel.text = message?.title
        categoryImageView.setImage(message?.imageName, system: true)
        valueLabel.text = chartData.reduce(0, +).string

        switch chartType(initialData) {
        case .bar:
            chartSuperView.subviews.forEach({
                if !($0 is UIStackView) {
                    $0.removeFromSuperview()
                }
            })
            let _ = BarChart(stackView: chartStack, superView: chartSuperView, isPreview: true, chartData: chartData, vericalCount: 30, canAnimate: true)
        case .line:
            chartStack.arrangedSubviews.forEach({$0.removeFromSuperview()})
            let _ = LineChart(superView: chartSuperView, isPreview: true, chartData: chartData, vericalCount: 30, canAnimate: true)
        }
    }
    
    private func chartType(_ initialData:InitialData) -> ChartType {
        return (initialData.data.key?.chartType ?? ((initialData.data.category)?.chartType ?? .default))
    }

}

extension HomeHealthDataCell {
    struct InitialData {
        let data:TodayAllHealthData
    }
}
