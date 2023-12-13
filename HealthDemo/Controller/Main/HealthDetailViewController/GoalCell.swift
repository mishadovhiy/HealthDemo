//
//  GoalCell.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import UIKit

class GoalCell: ClearCell {

    @IBOutlet weak var achivedLineView: UIView!
    @IBOutlet weak var baseView: BaseView!
    @IBOutlet weak var achivedLabel: UILabel!
    @IBOutlet weak var avarageTitleLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setSelectionBackground(view: baseView)
    }
    
    func set(goal:Double, avarage:Double) {
        let percent = avarage / goal
        achivedLabel.text = (percent * 100).string(decimalsCount: 0) + "%"
        avarageTitleLabel.text = goal.string
        achivedLineView.addOvalProgress(percent: percent)
        
    }

}
