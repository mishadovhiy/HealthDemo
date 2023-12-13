//
//  Double.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import Foundation

extension Double {
    var string:String {
        return string()
    }
    func string(decimalsCount:Int = 2) -> String {
        return String(format: "%.\(decimalsCount)f", self)
    }
    
}

extension Int {
    var stringMonth:String? {
        let dict = [
            1:"January",2:"February", 3:"March",
            4:"April", 5:"May", 6:"June",
            7:"July", 8:"August", 9:"September",
            10:"October", 11:"November", 12:"December"
        ]
        return dict[self]
    }
    
}
