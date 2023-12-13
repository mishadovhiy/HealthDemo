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
    
    static let keyListQnt:[HKQuantityTypeIdentifier] = [.stepCount, .distanceWalkingRunning, .distanceCycling, .activeEnergyBurned]
    
    func checkAuthorizationGranded(key:HKQuantityTypeIdentifier? = nil) -> Bool {
        var has = false
        if let key = key {
            if self.healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: key)!) == .sharingAuthorized {
                has = true
            }
            
        } else {
                HealthKitManager.keyListQnt.forEach {
                    if self.healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: $0)!) == .sharingAuthorized {
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
                print(error, " htgrfdc")
                if granded {
                    self.readAll()
                } 
               
            }
        } else {
            print("health not availible")
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

