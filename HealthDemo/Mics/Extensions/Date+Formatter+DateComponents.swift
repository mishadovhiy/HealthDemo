//
//  Date.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import Foundation

extension Date {
    var dateComponents: DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    }
    
    func string(neededComponents:[DateComponentKeys] = [.month, .day]) -> String {
        var str = ""
        let date = self.dateComponents
        neededComponents.forEach({
            switch $0 {
            case .day:
                str.append("\(date.day ?? 0)")
            case .month:
                str.append("\(date.month ?? 0)")
            case .year:
                str.append("\(date.year ?? 0)")
            default:
                break
            }
            if $0 != neededComponents.last {
                str.append(", ")
            }
        })
        return str
    }
    
    enum DateComponentKeys {
        case year
        case day
        case month
    }
}

