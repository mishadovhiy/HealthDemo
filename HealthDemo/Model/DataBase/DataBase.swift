//
//  DataBase.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit


struct DataBase {
    
    static var db:DB {
        get {
            if let value = dbHolder {
                return .init(dict: value)
            } else {
                let delegate = UIApplication.shared.delegate as? AppDelegate
                
                let db = delegate?.coreDataManager?.fetch(.general)?.data?.toDict
                dbHolder = db
                return .init(dict: db ?? [:])
            }
            
        }
        set {
            dbHolder = newValue.dict
            if #available(iOS 11.0, *) {
                if let core:Data = .create(from: newValue.dict) {
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    
                    DispatchQueue(label: "db", qos: .userInitiated).async {
                        delegate?.coreDataManager?.update(.init(db: core))
                    }
                }
            }
        }
    }
    
}

struct DB {
    var dict:[String:Any]
    init(dict: [String : Any]) {
        self.dict = dict
    }
    
    var settings:Settings {
        get {
            return .init(dict: dict["Settings"] as? [String:Any] ?? [:])
        }
        set {
            dict.updateValue(newValue.dict, forKey: "Settings")
        }
    }
    
    var general:DB.General {
        get {
            return .init(dict: dict["General"] as? [String:Any] ?? [:])
        }
        set {
            dict.updateValue(newValue.dict, forKey: "General")
        }
    }
    
}


extension DB {
    struct Settings {
        var dict:[String:Any]
        init(dict: [String : Any]) {
            self.dict = dict
        }
    }
}


extension DB {
    struct General {
        var dict:[String:Any]
        init(dict: [String : Any]) {
            self.dict = dict
        }
        
        var dataLoaded:Bool {
            get {
                return dict["dataLoaded"] as? Bool ?? false
            }
            set {
                dict.updateValue(newValue, forKey: "dataLoaded")
            }
        }
        
        var goals:[String:Double] {
            get {
                return dict["goals"] as? [String:Double] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: "goals")
            }
        }
        
        var showGoal:[String:Bool] {
            get {
                return dict["showGoal"] as? [String:Bool] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: "showGoal")
            }
        }
        
        var showAvarage:[String:Bool] {
            get {
                return dict["showAvarage"] as? [String:Bool] ?? [:]
            }
            set {
                dict.updateValue(newValue, forKey: "showAvarage")
            }
        }
        
        var favoritesOrder:[String] {
            get {
                return dict["favoritesOrder"] as? [String] ?? HealthKitManager.keyListQnt.compactMap({$0.rawValue})
            }
            set {
                dict.updateValue(newValue, forKey: "favoritesOrder")
            }
        }
    }
}

fileprivate extension DataBase {
    static var dbHolder:[String:Any]?
}
