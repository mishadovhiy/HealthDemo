//
//  UIImageView.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import UIKit

extension UIImageView {
    func setImage(_ string:String?, toggleHidden:Bool = true) {
        if let str = string,
            let image = UIImage(named: str) {
            self.image = image
        } else {
            self.image = nil
        }
        
        if toggleHidden {
            self.isHidden = self.image == nil
        }
    }
}

