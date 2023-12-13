//
//  UIImageView.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import UIKit

extension UIImageView {
    func setImage(_ string:String?, toggleHidden:Bool = true, system:Bool = false) {
        if #available(iOS 13.0, *) {
            if let str = string,
               let image = (system ? UIImage(systemName: str) : UIImage(named: str)) {
                self.image = image
            } else {
                self.image = nil
            }
        } else {
            if let str = string,
               let image = UIImage(named: str) {
                self.image = image
            } else {
                self.image = nil
            }
        }
        
        if toggleHidden {
            self.isHidden = self.image == nil
        }
    }
}

