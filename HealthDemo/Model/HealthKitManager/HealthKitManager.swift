//
//  HealthKitManager.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import HealthKit

protocol HealthKitManagerProtocol {
    func progressUpdated(_ progress:CGFloat)
    func fetchComplited(_ result: ReadHealthData.ResultData)
}

class HealthKitManager:ModelLifeCycle {
    
    var delegate:HealthKitManagerProtocol!
    var healthStore:HKHealthStore!
    
    init(delegate: HealthKitManagerProtocol) {
        self.delegate = delegate
        self.healthStore = .init()
        self.read = .init(healthStore: healthStore)
        self.setUpHealthRequest()
    }
    var progrecing:Bool = false
    var read:ReadHealthData!
    func setUpHealthRequest(){
        if HKHealthStore.isHealthDataAvailable() {
           // readAll()
            requestHealthAccess()
        }
    }
    
    
    private func readAll() {
        read.all(completion: {
            DispatchQueue.main.async {
                self.delegate.fetchComplited(self.read.results)
            }
        })
    }
    
    static var keyListQnt:[Any] {
        return keyListQntTypes + keyListSampleTypes
    }
    
    static let keyListQntTypes:[HKQuantityTypeIdentifier] = [
        HKQuantityTypeIdentifier.stepCount,
        HKQuantityTypeIdentifier.distanceWalkingRunning,
        HKQuantityTypeIdentifier.activeEnergyBurned,
        HKQuantityTypeIdentifier.distanceCycling
    ]
    
    static let keyListSampleTypes:[HKCategoryTypeIdentifier] = [ HKCategoryTypeIdentifier.sleepAnalysis]
    
    func checkAuthorizationGranded(key:HKQuantityTypeIdentifier? = nil, category:HKCategoryTypeIdentifier? = nil) -> Bool {
        var has = false
        let resultKey = key?.rawValue ?? category?.rawValue
        if let resultKey = resultKey {
            if self.healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .init(rawValue: resultKey)) ?? (HKQuantityType.categoryType(forIdentifier: .init(rawValue: resultKey))!)) == .sharingAuthorized {
                has = true
            }
            
        } else {
                HealthKitManager.keyListQnt.forEach {
                    if let category = $0 as? HKCategoryTypeIdentifier,
                       #available(iOS 15.0, *),
                       self.healthStore.authorizationStatus(for: HKCategoryType(category)) == .sharingAuthorized
                    {
                        has = true
                    } else if let key = $0 as? HKQuantityTypeIdentifier,
                              self.healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: key) ?? (HKQuantityType.categoryType(forIdentifier: category!)!)) == .sharingAuthorized
                    {
                        has = true
                    }

                }
        }
        
        return has
    }
    var requestingAccess = false
    func requestHealthAccess(key:String? = nil) {
        if HKHealthStore.isHealthDataAvailable() {
            self.requestingAccess = true
            let infoToRead = Set([
                HKQuantityType.quantityType(forIdentifier: .stepCount)!,
                HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
                HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
                HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            ])
            let single:Set<HKSampleType> = key == nil ? [] : [HKQuantityType.quantityType(forIdentifier: .init(rawValue: key!))!]
            healthStore.requestAuthorization(toShare: [], read: key != nil ? single : infoToRead) { granded, error in
                print(error, " health error")
                if granded {
                    self.readAll()
                } 
               
            }
        } else {
            print("health not availible error")
        }
    }
    
    
    func startFetching() {
        
    }
    
    func checkPermition() -> Bool {
        return false
    }
    
    
    func deinitialize() {
        delegate = nil
    }
    
}

