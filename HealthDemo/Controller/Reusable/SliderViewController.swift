//
//  SliderViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class SliderViewController: BaseVC {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    var data:SliderData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = data?.title
        slider.value = (data?.value ?? 0) / 2500
        valueLabel.text = Double(data?.value ?? 0).string
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed(_:)))
        ]

    }
    
    @objc private func donePressed(_ sender:UIBarButtonItem) {
        let value = data?.value
        data?.changed(value ?? 0)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
       // data?.changed((sender as! UISlider).value)
        data?.value = (sender as! UISlider).value * 2500
        valueLabel.text = Double(data?.value ?? 0).string

    }
    
    struct SliderData {
        let title:String
        var value:Float
        var changed:(_ newValue:Float)->()
    }

}

extension SliderViewController {
    static func configure(data:SliderData?) -> SliderViewController {
        let vc = UIStoryboard(name: "Reusable", bundle: nil).instantiateViewController(withIdentifier: "SliderViewController") as! SliderViewController
        vc.data = data
        return vc
    }
}
