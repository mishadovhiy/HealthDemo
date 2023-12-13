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
        case .stepCount:return .init(title: "Steps count", imageName: "figure.walk")
        case .distanceWalkingRunning: return .init(title: "Distance walking", imageName: "figure.run")
        case .distanceCycling: return .init(title: "Distance Cycling", imageName: "figure.roll")
        case .activeEnergyBurned: return .init(title: "Energy Burned", imageName: "figure.cooldown")
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
