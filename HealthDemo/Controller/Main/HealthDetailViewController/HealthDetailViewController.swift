//
//  HealthDetailViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 09.12.2023.
//

import UIKit
import HealthKit

class HealthDetailViewController: BaseVC {

    @IBOutlet weak var chartContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:ViewModelHealthDetail!
    var healthKey:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        viewModel = .init(key: healthKey ?? "")
        title = (HKQuantityTypeIdentifier.init(rawValue: healthKey ?? "").message ?? HKCategoryTypeIdentifier.init(rawValue: healthKey ?? "").message)?.title
        let date = Calendar.current.date(byAdding: .month, value: 2, to: Date())
        chartDateComponent = (date ?? Date()).dateComponents
        tableView.registerCell([.switcher, .header])
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.reloadTable = {
            self.chartContainerView.animatedTransition()
            self.updateHealthData()
        }
        
        if !(appDelegate?.health?.checkAuthorizationGranded(key: .init(rawValue: healthKey ?? "")) ?? false ){
            viewModel.accessDenied = true
            tableView.reloadData()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (children.first(where: {$0 is ChartContainerViewController}) as? ChartContainerViewController)?.updateSelectionView()

    }
    
    func updateHealthData() {
        viewModel.updateHealthData(appDelegate: self.appDelegate, dateComponent: self.chartDateComponent ?? .init()) {
            self.updateGraphUI()
        }
    }
    
    func updateGraphUI() {
        if let chart = self.children.first(where:{$0 is ChartContainerViewController}) as? ChartContainerViewController {
            chart.updateChartData(data: viewModel.chartData)
        } else {
            ChartContainerViewController.addContainerView(self,containerView: chartContainerView,data: viewModel.chartData)
        }
    }
    
    var chartDateComponent:DateComponents? {
        didSet {
            updateHealthData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        (children.first(where: {$0 is ChartContainerViewController}) as? ChartContainerViewController)?.updateSelectionView()
    }
    
    func changeGoalPressed() {
        let key = viewModel.chartData?.healthKeyData?.key?.message?.title ?? (viewModel.chartData?.healthKeyData?.category?.message?.title ?? "")
        
        let keyType = HKQuantityTypeIdentifier(rawValue: viewModel.chartData?.healthKey ?? "")
        var maximum = keyType.goalMultiplier
        if !HealthKitManager.keyListQntTypes.contains(keyType) {
            maximum = HKCategoryTypeIdentifier(rawValue: keyType.rawValue).goalMultiplier
        }
        navigationController?.pushViewController(SliderViewController.configure(data: .init(title: "New goal for \n\( key)", value: Float(DataBase.db.general.goals[viewModel.key] ?? 0), max:Float(maximum), changed: { newValue in
            
            DataBase.db.general.goals.updateValue(Double(newValue), forKey: self.viewModel.key)
            self.tableView.reloadData()
            self.viewModel.reloadTable?()
        })), animated: true)
    }
}

extension HealthDetailViewController {
    static func configure(chart:ChartContainerViewController.InitialChartData? = nil) -> HealthDetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HealthDetailViewController") as! HealthDetailViewController
        vc.healthKey = chart?.healthKey
        return vc
    }
}
