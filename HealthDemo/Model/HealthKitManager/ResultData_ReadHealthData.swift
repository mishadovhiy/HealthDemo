//
//  ResultData_ReadHealthData.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 11.12.2023.
//

import HealthKit

struct TodayAllHealthData:Hashable {
    let key:HKQuantityTypeIdentifier
    let value:Double?
}

extension ReadHealthData {
    struct ResultData {
        var dict:[String:[Date:Any]]
        init(dict: [String : [Date : Any]]) {
            self.dict = dict
        }
        
        func allForToday() -> [TodayAllHealthData] {
            return HealthKitManager.keyListQnt.compactMap({
                .init(key: $0, value: today($0))
            })
        }
        
        func allValues(_ key:String?, date:DateComponents) -> [Date:Double] {
            guard let key = key else { return [:] }
            if let month = date.month,
               let year = date.year
            {
                return allValues(.init(rawValue: key)).filter({
                    $0.key.dateComponents.month == month && $0.key.dateComponents.year == year
                })
            } else if let year = date.year {
                return allValues(.init(rawValue: key)).filter({
                    $0.key.dateComponents.year == year
                })
            } else {
                return [:]
            }
        }
        
        private func sortFiltered(_ data:[Date:Double]) -> [Date:Double] {
            let values = data.sorted {$0.key >= $1.key}
            return Dictionary(uniqueKeysWithValues: values)
        }
        
        func today(_ key:HKQuantityTypeIdentifier) -> Double? {
            let today = Date()
            return allValues(key)[today]
        }
        
        private func allValues(_ key:HKQuantityTypeIdentifier) -> [Date:Double] {
            switch key {
            case .activeEnergyBurned:return energyBurned
            case .distanceCycling: return distance
            case .distanceWalkingRunning: return distanceRunning
            case .activeEnergyBurned: return energyBurned
            case .stepCount: return steps
            default: return [:]
            }
        }
        
        var distance:[Date:Double] {
            get {
                return dict[HKQuantityTypeIdentifier.distanceCycling.rawValue] as? [Date:Double] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: HKQuantityTypeIdentifier.distanceCycling.rawValue)
            }
        }
        var distanceRunning:[Date:Double] {
            get {
                return dict[HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue] as? [Date:Double] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue)
            }
        }
        var energyBurned:[Date:Double] {
            get {
                return dict[HKQuantityTypeIdentifier.activeEnergyBurned.rawValue] as? [Date:Double] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: HKQuantityTypeIdentifier.activeEnergyBurned.rawValue)
            }
        }
        var steps:[Date:Double] {
            get {
                return dict[HKQuantityTypeIdentifier.stepCount.rawValue] as? [Date:Double] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: HKQuantityTypeIdentifier.stepCount.rawValue)
            }
        }
        
    }

}
