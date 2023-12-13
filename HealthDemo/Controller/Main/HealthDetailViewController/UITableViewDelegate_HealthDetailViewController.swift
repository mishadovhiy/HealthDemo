//
//  UITableViewDelegate_HealthDetailViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import UIKit

extension HealthDetailViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.accessDenied ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:return 1
        case 1: return viewModel.sectionChart.tableData.count
        case 2:return 0//viewModel.accessDenied ? 1 : 0
        default:return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
            cell.set(goal: viewModel.goal, avarage: viewModel.avarage)
            return cell
        case 1: 
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            let data = viewModel.sectionChart.tableData
            cell.set(data[indexPath.row].switcherType)
            
            cell.setCornered(indexPath: indexPath, dataCount: data.count, for: cell.contentView.subviews.first(where: {$0 is BaseView}) ?? .init())
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            let data = viewModel.sectionChart.tableData
            cell.set(.init(title: "Requst access to Health data", isOn: false, switched: { isOn in
                self.appDelegate?.health?.requestHealthAccess(key: self.healthKey)
            }))
            
            cell.setCornered(indexPath: indexPath, dataCount: 1, for: cell.contentView.subviews.first(where: {$0 is BaseView}) ?? .init())
            return cell
        default:return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            changeGoalPressed()
        }
    }
    
}
