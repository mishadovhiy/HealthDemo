//
//  SettingsViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class SettingsViewController: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Other screen"
    }
    
}
extension SettingsViewController {
    static func configure() -> SettingsViewController {
        return UIStoryboard(name: "Reusable", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
    }
}
