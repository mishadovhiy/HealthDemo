//
//  SwitchCell.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import UIKit

class SwitchCell: ClearCell {
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    private var data:SwitchData?
    func set(_ data:SwitchData?) {
        switcher.isOn = data?.isOn ?? false
        titleLabel.text = data?.title
        self.data = data
    }
    @IBAction func switchChanged(_ sender: Any) {
        data?.switched((sender as! UISwitch).isOn)
    }
}


