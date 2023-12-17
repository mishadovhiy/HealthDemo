//
//  HKQuantityTypeIdentifier.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 11.12.2023.
//

import HealthKit

extension HKCategoryTypeIdentifier {
    var message:MessageData? {
        if #available(iOS 13.6, *) {
            switch self {
            case .sleepAnalysis:return .init(title: "Sleep Changes", imageName: "bed.double.fill")
            default:
                return nil
            }
        } else {
            return .init(title: "Available from iOS 13.6 and hidher", description: "Please, update your iOS device")
        }
    }
    
    var chartType:ChartType {
        switch self {
        case .sleepAnalysis:return .line
        default: return .line
        }
    }
    
    var goalMultiplier:Double {
        switch self {
        case .sleepAnalysis:return 24
        default: return 0
        }
    }

}

extension HKQuantityTypeIdentifier {
    var message:MessageData? {
        switch self {
        case .stepCount:return .init(title: "Steps count", imageName: "figure.walk")
        case .distanceWalkingRunning: return .init(title: "Distance walking", imageName: "figure.run")
        case .distanceCycling: return .init(title: "Distance Cycling", imageName: "figure.roll")
        case .activeEnergyBurned: return .init(title: "Energy Burned", imageName: "figure.cooldown")
        default:return nil
        }
    }
    
    var notFavorite:Bool {
        return self == .distanceCycling
    }
    
    var chartType:ChartType {
        switch self {
        case .activeEnergyBurned:return .line
        default: return .bar
        }
    }
    
    var goalMultiplier:Double {
        switch self {
        case .stepCount:return 20000
        case .distanceWalkingRunning:return 1000
        case .activeEnergyBurned:return 1000
        default: return 2500
        }
    }
}
