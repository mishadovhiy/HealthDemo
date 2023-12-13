//
//  UITabBarController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

extension UITabBarController {
    func removeBackground() {
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = UIColor.clear
    }
}

extension UINavigationController {
    func removeBackground() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    func createBackground(_ color:UIColor, bluer:Bool = false) {
        let view = UIView()
        view.backgroundColor = color
        self.view.insertSubview(view, at: 1)
        if bluer {
            let _ = view.addBluer()
        }
        if #available(iOS 11.0, *) {
            view.addConstaits([
                .left:0, .right:0, .top:0, .height:self.view.safeAreaInsets.top + 44//self.navigationBar.frame.height
            ], superV: self.view)
        }
    }
}
