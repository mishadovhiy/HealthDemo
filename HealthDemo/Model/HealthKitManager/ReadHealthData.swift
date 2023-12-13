//
//  ReadHealthData.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 11.12.2023.
//

import HealthKit
import UIKit

class ReadHealthData {
    
    let healthStore:HKHealthStore!
    private let calendar:CalendarDate!
    var results:ResultData = .init(dict: [:])

    init(healthStore: HKHealthStore!) {
        self.calendar = .init()
        self.healthStore = healthStore
    }
    
    func all(completion:@escaping()->()) {
        DispatchQueue(label: "health", qos: .userInitiated).async {
            self.steps() {
                print("fdsadsa stepCount")
                self.distance() {
                    print("fdsadsa distance")
                    self.distanceRunning() {
                        print("fdsadsa distanceRunning")
                        self.energyBurned() {
                            print("fdsadsa activeEnergyBurned")
                            completion()
                        }
                    }
                }
            }
        }
    }

    private func steps(completion:@escaping()->()) {
        results.steps.removeAll()
        quantityType(for: .stepCount, resultsCompletion: { statistics in
            guard let sum = statistics.sumQuantity() else {
                print("erfwds")
                return
            }
            
            let steps = sum.doubleValue(for: HKUnit.count())
            self.results.steps.updateValue(steps, forKey: statistics.startDate)
            print("sdfDate: \(statistics.startDate), stepCount : \(steps)")
        }, completion: completion)
    }
    
    private func distance(completion:@escaping()->()) {
        results.distance.removeAll()
        quantityType(for: .distanceCycling, resultsCompletion: { statistics in
            let value = statistics.sumQuantity()?.doubleValue(for: HKUnit.meterUnit(with: .kilo))
            print("asdadsDate: \(statistics.startDate), distance : \(value)")

            self.results.distance.updateValue(value ?? 0, forKey: statistics.startDate)

        }, completion: completion)
    }
    
    private func distanceRunning(completion:@escaping()->()) {
        results.distanceRunning.removeAll()
        quantityType(for: .distanceWalkingRunning, resultsCompletion: { statistics in
            let value = statistics.sumQuantity()?.doubleValue(for: HKUnit.meterUnit(with: .kilo))
            print("asdadsDate: \(statistics.startDate), distanceRunning : \(value)")
            self.results.distanceRunning.updateValue(value ?? 0, forKey: statistics.startDate)

        }, completion: completion)
    }
    
    private func energyBurned(completion:@escaping()->()) {
        results.energyBurned.removeAll()
        quantityType(for: .activeEnergyBurned, resultsCompletion: { statistics in
            let value = statistics.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie())

            print("asdadsDate: \(statistics.startDate), energyBurned : \(value)")
            self.results.energyBurned.updateValue(value ?? 0, forKey: statistics.startDate)

        }, completion: completion)
    }
    
    
    
    
    
    private func quantityType(for type:HKQuantityTypeIdentifier, resultsCompletion:@escaping(_ statistics:HKStatistics)->(), completion:@escaping()->()) {
        let qntType = HKQuantityType.quantityType(forIdentifier: type)!
        
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: qntType,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: calendar.startDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            guard let results = results else {
                if let error = error {
                    print("Error retrieving step count data: \(error.localizedDescription)")
                    if !DataBase.db.general.dataLoaded {
                        DispatchQueue.main.async {
                            let appdel = UIApplication.shared.delegate as! AppDelegate
                            appdel.coodinator.toFetchHealth()
                        }
                    }
                    //here
                }
                return
            }
            if !DataBase.db.general.dataLoaded {
                DispatchQueue.main.async {
                    DataBase.db.general.dataLoaded = true
                }
            }
            
            results.enumerateStatistics(from: self.calendar.startDate, to: self.calendar.endDate) { statistics, _ in
                resultsCompletion(statistics)
                if statistics.startDate == self.calendar.endDate {
                    print("egfsda ")
                    completion()
                }
            }
        }
        
        healthStore.execute(query)
    }

    
    func predictType(for type:HKQuantityTypeIdentifier, resultsCompletion:@escaping(_ statistics:HKStatistics)->(), completion:@escaping()->()) {
        let stepType = HKQuantityType.quantityType(forIdentifier: type)!

        var currentDate = calendar.startDate
                
        while currentDate <= calendar.endDate {
            let predicate = HKQuery.predicateForSamples(withStart: currentDate, end: calendar.calendar.date(byAdding: .day, value: 1, to: currentDate), options: .strictStartDate)
                    
                    let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
                        
                        if let result = result {
                            resultsCompletion(result)
                            if result.startDate == self.calendar.endDate {
                                completion()
                            }
                        } else {
                            if let error = error {
                                print("Error retrieving step count data: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    healthStore.execute(query)
                    
                    // Move to the next day
            currentDate = calendar.calendar.date(byAdding: .day, value: 1, to: currentDate)!
                }
    }
    
    
    
}

extension ReadHealthData {
    struct CalendarDate {
        let calendar = Calendar.current
        var endDate:Date {
            let endDate = Date()
            return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: endDate) ?? .init()
        }
        var startDate:Date {
            return calendar.date(byAdding: .year, value: -2, to: endDate)!
        }
    }
}
