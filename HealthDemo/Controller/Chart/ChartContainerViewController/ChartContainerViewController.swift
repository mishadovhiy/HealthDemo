//
//  ChartViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 09.12.2023.
//

import UIKit

class ChartContainerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartSelectionView: BaseView!
    @IBOutlet weak var selectedDescrLabel: UILabel!
    @IBOutlet weak var selectedTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var avarageLabel: UILabel!
    
    var scrollModel:ScrollModel!
    var viewModel:ChartViewModelContainer!
    var chartData:InitialChartData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel = .init(monthChanged: graphScrollChanged(_:))
        scrollModel = .init(delegate: self)
        scrollModel.collectionView = collectionView
        scrollModel.dataCount = viewModel.numberOfRows
        
        let date = (parent as! HealthDetailViewController).chartDateComponent
        viewModel.middleDate = .init(year: date?.year ?? 0,
                                     month: date?.month ?? 0)
        viewModel.scrollIndxUpdated(scrollModel.selectedInt)
        chartSelectionView.rotate(rotation: -90)
    }

    
    func updateChartData(data:InitialChartData?) {
        var new = data
        let sorted = Array(data?.healthData.sorted(by: {$1.key >= $0.key}) ?? [])
        var sum:Double = 0
        var valueCount = 0
        let date = (parent as! HealthDetailViewController).chartDateComponent

        sorted.forEach({
            let component = $0.key.dateComponents
            if component.year == date?.year && component.month == date?.month {
                sum += $0.value
                valueCount += 1
            }
            new?.healthValues.append($0.value)
        })
        let avarage = sum / Double(valueCount)
        print(sum, " grbef")
        print(valueCount, " valueCountvalueCount")


        let superVC = parent as! HealthDetailViewController
        superVC.viewModel.avarage = avarage
        superVC.tableView.reloadData()
        
        avarageLabel.text = avarage.string
        durationLabel.text = "\((date?.month ?? 0).stringMonth ?? "-"), \(date?.year ?? 0)"
        chartData = new
        collectionView.scrollToItem(at: .init(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        collectionView.reloadData()
        if sum != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.viewModel.animateChart = false
            })
        }
    }
    
    func chartValueSelected(_ at:Int) {
        let dataSorted = chartData?.healthData.sorted{$1.key >= $0.key} ?? []
        if let data = chartData,
        data.healthData.keys.count - 1 >= at {
            let key = dataSorted[at].key
            updateSelectionView(date: key, value: data.healthData[key] ?? 0, barRow: at)
        }
    }
    
    func updateSelectionView(date:Date? = nil, value:Double? = nil, barRow:Int? = nil) {
        let show = barRow != nil
        chartSelectionView.animatedTransition()
        chartSelectionView.alpha = show ? 1 : 0
        selectedTitleLabel.text = date?.string(neededComponents: [.day, .month])
        selectedDescrLabel.text = value?.string
        let step = self.view.frame.width / CGFloat(viewModel.verticalChartCount)
        let newX = step * CGFloat(barRow ?? 0)
        let viewWidthA = chartSelectionView.frame.width / 2
        var resulX = (newX - viewWidthA) + 10
        if resulX <= 0 {
            resulX = 0
        } else if resulX >= (self.view.frame.width - viewWidthA) {
            resulX = (self.view.frame.width - viewWidthA)
        }
        UIView.animate(withDuration: Styles.pressedAnimation08) {
            self.chartSelectionView.layer.move(.left, value: resulX)
        }
    }
        
    func graphScrollChanged(_ newData:[CalendarModel]) {
        if let vc = parent as? HealthDetailViewController,
           let data = newData.first
        {
            vc.chartDateComponent = .init(year:data.year, month: data.month)
        }
    }

}


extension ChartContainerViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateSelectionView()
        scrollModel.scrollViewDidScroll(scrollView)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollModel.scrollViewWillBeginDecelerating(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollModel.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollModel.scrollViewDidEndScrollingAnimation(scrollView)
        viewModel.scrollIndxUpdated(scrollModel.selectedInt)
    }
}

extension ChartContainerViewController:ScrollModelProtocol {
    func selectedRowChanged(new row: Int) {
        print(row, " jutyhrgef")
    }
}


extension ChartContainerViewController {
    static func addContainerView(_ vc:UIViewController, containerView:UIView, data:InitialChartData? = nil) {
        let newvc = ChartContainerViewController.configure(data: data)
        vc.addChild(newvc)
        guard let childView = newvc.view else { return }
        containerView.addSubview(childView)
        childView.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: containerView)
        newvc.didMove(toParent: vc)
    }
    
    static func configure(data:InitialChartData? = nil) -> ChartContainerViewController {
        let vc = UIStoryboard(name: "Chart", bundle: nil).instantiateViewController(withIdentifier: "ChartContainerViewController") as! ChartContainerViewController
        vc.chartData = data
        return vc
    }
    
    
}
