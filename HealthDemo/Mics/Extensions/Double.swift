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
        let valid = self.isFinite && !self.isNaN
        if self.isFinite && !self.isNaN {
            
        } else {
            return "0"
        }
        return String(format: "%.\(decimalsCount)f", (valid ? self : 0))
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
    
    var shortMonth:String? {
        let dict = [
            1:"Jan",2:"Feb", 3:"Mar",
            4:"Apr", 5:"May", 6:"Jun",
            7:"Jul", 8:"Aug", 9:"Sept",
            10:"Oct", 11:"Nov", 12:"Dec"
        ]
        return dict[self]
    }
    
    var twoDecimals:String {
        if self <= 9 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
}
extension DateComponents {
    var stringMonth:String {
        return stringMonth(short: true)
    }
    func stringMonth(short:Bool) -> String {
        return month?.shortMonth ?? "" + (short ? "" : " \(year ?? 0)")
    }
}
