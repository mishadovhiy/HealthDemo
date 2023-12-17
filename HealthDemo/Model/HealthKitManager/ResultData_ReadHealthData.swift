//
//  ResultData_ReadHealthData.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 11.12.2023.
//

import HealthKit

struct TodayAllHealthData:Hashable {
    let key:HKQuantityTypeIdentifier?
    var category:HKCategoryTypeIdentifier? = nil
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
                if let key = $0 as? HKQuantityTypeIdentifier
                {
                    return .init(key: key, value: todayValue(key) ?? 0)
                    
                } else if let category  = $0 as? HKCategoryTypeIdentifier {
                    return .init(key: nil, category:category, value: todayValue(nil, categoryKey:category))

                } else {
                    return .init(key: nil, value: nil)
                }
            })
        }
        
        func allValues(_ key:String?, date:DateComponents) -> [Date:Double] {
            guard let key = key else { return [:] }
            if let month = date.month,
               let year = date.year
            {
                return allValues(.init(rawValue: key), categoryKey: .init(rawValue: key)).filter({
                    $0.key.dateComponents.month == month && $0.key.dateComponents.year == year
                })
            } else if let year = date.year {
                return allValues(.init(rawValue: key), categoryKey: .init(rawValue: key)).filter({
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
        
        func todayValue(_ key:HKQuantityTypeIdentifier? = nil, categoryKey:HKCategoryTypeIdentifier? = nil) -> Double? {
            let today = Date()
            return allValues(key)[today]
        }
        
        private func allValues(_ key:HKQuantityTypeIdentifier? = nil, categoryKey:HKCategoryTypeIdentifier? = nil) -> [Date:Double] {

            if let qKey = key {
                switch qKey {
                case .activeEnergyBurned:return energyBurned
                case .distanceCycling: return distance
                case .distanceWalkingRunning: return distanceRunning
                case .activeEnergyBurned: return energyBurned
                case .stepCount: return steps
                default: 
                    if let categoryKey = categoryKey {
                        switch categoryKey {
                        case .sleepAnalysis:
                            return sleep
                        default: 
                            return [:]
                        }
                    } else {
                        return [:]
                    }
                }
            } else if let categoryKey = categoryKey {
                switch categoryKey {
                case .sleepAnalysis: 
                    return sleep
                default: return [:]
                }
            } else {
                return [:]
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
        
        var sleep:[Date:Double] {
            get {
                return dict[HKCategoryTypeIdentifier.sleepAnalysis.rawValue] as? [Date:Double] ?? [:]
            }
            set {
                var results:[Date:Double] = [:]
                newValue.forEach {
                    let dateComp = $0.key.dateComponents
                    let resultDate:DateComponents = .init(calendar:.current, year:dateComp.year, month: dateComp.month, day: dateComp.day)
                    if let date = Calendar.current.date(from: resultDate) {
                        let values = results[date] ?? 0
                        results.updateValue(values + $0.value, forKey: date)
                        
                    }
                }
                dict.updateValue(results, forKey: HKCategoryTypeIdentifier.sleepAnalysis.rawValue)
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
