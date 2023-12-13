//
//  HomeViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class HomeViewController: BaseVC {

    @IBOutlet var ovalViews: [OvalView]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ovalsStack: UIStackView!
    
   // var viewModel:HomeViewModel!
    var ovalsModel:DragOvalViewModel!
    var tableData:[TodayAllHealthData] = []
    var chartData:[TodayAllHealthData:[Double]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   viewModel = .init()
        tableView.delegate = self
        tableView.dataSource = self
        title = "home"
        ovalsModel = .init(ovalsStack: ovalsStack, ovalViews: ovalViews, data: DataBase.db.general.favoritesOrder.compactMap({.init(percent: 0, key: .init(rawValue: $0))}), view: view)
        ovalViews.forEach({
            $0.animatedTransition(0.6)
        })
        healthUpdated()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        healthUpdated()
    }
    
    override func healthUpdated() {
        super.healthUpdated()
        let results = appDelegate?.health?.read.results
        tableData = results?.allForToday() ?? []
        tableData.forEach({
            chartData.updateValue((results?.allValues($0.key.rawValue, date: Date().dateComponents) ?? [:]).compactMap({$0.value}), forKey: $0)
        })

        ovalsModel.data = []
        let all = chartData
        all.forEach {
            print($0.value, " hgfbdfv")

            let percent = (($0.value.reduce(0, +) ?? 0) / Double($0.value.count)) / (DataBase.db.general.goals[$0.key.key.rawValue] ?? 35)
            print(percent, " grterfde")
            let perresult:OvalFavoriteData = .init(percent: !percent.isFinite || percent == 0 || percent.isNaN ? 0 : Int(percent * 100), key: $0.key.key)
            ovalsModel.data.append(perresult)
            let k = $0.key.key
            
            (ovalViews.sorted{$0.tag <= $1.tag}).forEach({
                if $0.data!.key == k {
                    $0.data = perresult
                }

            })
        }
//        HealthKitManager.keyListQnt.forEach { key in
//            let all = results?.allValues(key.rawValue, date: Date().dateComponents) ?? [:]
//            var sum:Double = 0
//            var valCount = 0
//            all.forEach {
//                sum += $0.value
//                print(sum, " ytferdes")
//                valCount += 1
//            }
//            let percent = (sum / Double(valCount)) / (DataBase.db.general.goals[key.rawValue] ?? 35)
//            let perresult:OvalFavoriteData = .init(percent: !percent.isFinite || percent == 0 || percent.isNaN ? 0 : Int(percent * 100), key: key)
//            ovalsModel.data.append(perresult)
//            ovalViews.forEach({
//                if $0.data!.key == key {
//                    $0.data = perresult
//                }
//                
//            })
//        }

        tableView.reloadData()
    }

}

extension HomeViewController {
    static func configure() -> HomeViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
}
