//
//  HKQuantityTypeIdentifier.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 11.12.2023.
//

import HealthKit

extension HKQuantityTypeIdentifier {
    var message:MessageData? {
        switch self {
        case .activeEnergyBurned:return .init(title: "Energy burned")
        case .stepCount:return .init(title: "Steps count")
        case .distanceWalkingRunning: return .init(title: "Distance walking")
        case .distanceCycling: return .init(title: "Distance Cycling")
        case .activeEnergyBurned: return .init(title: "Energy Burned")
        default:return nil
        }
    }
    
    var chartType:ChartType {
        switch self {
        case .activeEnergyBurned:return .line
        default: return .bar
        }
    }
}
