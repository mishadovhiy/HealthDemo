//
//  ViewModelHealthDetail.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import UIKit

class ViewModelHealthDetail {
    let key:String
    var chartData:ChartContainerViewController.InitialChartData?
    
    var goal:Double {
        return DataBase.db.general.goals[key] ?? 35
    }
    var avarage:Double = 0
    var reloadTable:(()->())?
    init(key:String) {
        self.key = key
        self.showGoal = DataBase.db.general.showGoal[key] ?? false
        self.showAvarage = DataBase.db.general.showAvarage[key] ?? false
        chartData = .with({
            $0.healthKey = key
        })
    }
    
    var accessDenied = false
    func updateHealthData(appDelegate:AppDelegate?, dateComponent:DateComponents?, completion:@escaping()->()) {
        let health = appDelegate?.health
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let strKey = self.chartData?.healthKey
            let key = health?.read.results.allForToday().first(where: {$0.key?.rawValue == self.chartData?.healthKey ?? ""})
            self.chartData?.healthKeyData = key
            self.chartData?.healthData = appDelegate?.health?.read.results.allValues(strKey, date: dateComponent ?? .init()) ?? [:]
            DispatchQueue.main.async {
                completion()
            }

        }
    }
 
    var showAvarage:Bool = false
    var showGoal:Bool = false
    
    var sectionChart:TableData {
        .init(title: "", tableData: [
            .init(switcherType: .init(title: "Show Avarage", isOn: DataBase.db.general.showAvarage[self.key] ?? false, switched: { isOn in
                self.showAvarage = isOn
                DataBase.db.general.showAvarage.updateValue(isOn, forKey: self.key)
                self.reloadTable?()
            })),
            .init(switcherType: .init(title: "Show Goal", isOn: DataBase.db.general.showGoal[self.key] ?? false, switched: { isOn in
                self.showGoal = isOn
                DataBase.db.general.showGoal.updateValue(isOn, forKey: self.key)
                self.reloadTable?()
            }))
        ])
    }
    
    struct TableData {

        let title:String
        var tableData:[TableRows]
        struct TableRows {
            let switcherType:SwitchData?
            
        }
    }
}
