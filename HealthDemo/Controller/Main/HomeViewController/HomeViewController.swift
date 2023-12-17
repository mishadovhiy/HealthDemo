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
    
    var ovalsModel:DragOvalViewModel!
    var tableData:[TodayAllHealthData] = []
    var chartData:[TodayAllHealthData:[Double]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "home"
        ovalsModel = .init(ovalsStack: ovalsStack, ovalViews: ovalViews, data: DataBase.db.general.favoritesOrder.compactMap({.init(percent: 0, key: .init(rawValue: $0))}), view: view)
        ovalViews.forEach({
            $0.animatedTransition(0.6)
        })
        healthUpdated()
        ovalsModel.reordered = {
            self.vibrate()
        }

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
            if let key = results?.allValues($0.key?.rawValue ?? ($0.category?.rawValue ?? ""), date: Date().dateComponents) {
                chartData.updateValue(key.compactMap({$0.value}), forKey: $0)

            }
        })

        ovalsModel.data = []
        let all = chartData.sorted {
            ($0.key.category?.rawValue ?? "") >= ($1.key.category?.rawValue ?? "")
        }
        all.forEach {
            let key = $0.key.key?.rawValue ?? ($0.key.category?.rawValue ?? "unkn")
            let percentFirst = ($0.value.reduce(0, +)) / Double($0.value.count)
            let percent = percentFirst / (DataBase.db.general.goals[key] ?? 35)
            let percentValue = !percent.isFinite || percent == 0 || percent.isNaN ? 0 : Int(percent * 100)
            if !($0.key.key?.notFavorite ?? false) {
                let perresult:OvalFavoriteData = .init(percent: percentValue, key: $0.key.key, category:$0.key.category)
                ovalsModel.data.append(perresult)
            }
            
        }
        ovalsModel.updateAll()
        tableView.reloadData()
    }

}

extension HomeViewController {
    static func configure() -> HomeViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
}
