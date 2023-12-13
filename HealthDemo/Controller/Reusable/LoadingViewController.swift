//
//  LoadingViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit

class LoadingViewController: BaseVC {

    var screenData:LoadingData?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func updateProgress(_ newValue:CGFloat) {
        
    }

}

extension LoadingViewController {
    static func configure() -> LoadingViewController {
        return UIStoryboard(name: "Reusable", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
    }
}
