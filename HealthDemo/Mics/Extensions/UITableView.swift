//
//  UITableView.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import UIKit

extension UITableView {
    func registerCell(_ types:[XibCell]) {
        types.forEach({
            self.register(UINib(nibName: $0.rawValue, bundle: nil), forCellReuseIdentifier: $0.rawValue)
        })
    }
    
    enum XibCell:String {
        case header = "AmountToPayCell"
        case switcher = "SwitchCell"
    }
}
