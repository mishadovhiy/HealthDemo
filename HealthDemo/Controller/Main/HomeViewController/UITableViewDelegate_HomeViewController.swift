//
//  UITableViewDelegate_HomeViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHealthDataCell", for: indexPath) as! HomeHealthDataCell
        cell.set(.init(data: tableData[indexPath.row]), chartData: chartData[tableData[indexPath.row]] ?? [])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //to detail
        self.coodinator?.push(HealthDetailViewController.configure(chart: .with({
            $0.healthKey = tableData[indexPath.row].key.rawValue
        })))
    }
    
    
}

