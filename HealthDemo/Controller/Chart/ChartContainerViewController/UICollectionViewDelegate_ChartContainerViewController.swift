//
//  UICollectionViewDelegate_ChartContainerViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 09.12.2023.
//

import UIKit

extension ChartContainerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = chartData?.healthValues ?? []

        let perant = self.parent as! HealthDetailViewController
        let db = DataBase.db.general
        let goal = (db.showGoal[perant.viewModel.key] ?? false) ? perant.viewModel.goal : nil
        let avarage = (db.showAvarage[perant.viewModel.key] ?? false) ? perant.viewModel.avarage : nil
        switch chartData?.healthKeyData?.key.chartType {
        case .bar:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarChartCell", for: indexPath) as! BarChartCell
            cell.set(chartData: data, canAnimate: viewModel.animateChart, verticalCount: viewModel.verticalChartCount, goal: goal, avarage: avarage, titledData: chartData?.healthData, selected: chartValueSelected(_:))
            return cell
        case .line:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LineChartCell", for: indexPath) as! LineChartCell

            cell.set(chartData: data, canAnimate: viewModel.animateChart, verticalCount: viewModel.verticalChartCount, goal: goal, avarage: avarage, titledData: chartData?.healthData ?? [:], selected: chartValueSelected(_:))
            return cell
        default:return UICollectionViewCell()
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width,
                     height: collectionView.frame.height)
    }
    

}
