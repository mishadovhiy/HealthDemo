//
//  TabBarController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 10.12.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            HomeViewController.configure(),
            SettingsViewController.configure()
        ]
        navigationController?.navigationBar.prefersLargeTitles = true
        prepareUI()
        updateTitle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    private func prepareUI() {
        removeBackground()
        navigationController?.removeBackground()
        navigationController?.createBackground(.clear, bluer: true)
        createBackground()
        createSelectionView()
        self.viewControllers?.forEach({
            $0.additionalSafeAreaInsets.bottom = 19
            $0.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: $0 == selectedViewController ? 15 : 50)
        })

    }
    
    
    private func createBackground() {
        let whiteBack = UIView()
        whiteBack.backgroundColor = K.Colors.containerBackground.withAlphaComponent(0.6)
        whiteBack.layer.cornerRadius(at: .top, value: Styles.viewRadius5)
        let newView = UIView()
        newView.backgroundColor = Styles.TabBar.background
        view.insertSubview(newView, at: 1)
        newView.layer.shadow(opasity: Styles.TabBar.shadowOpacity, color: Styles.TabBar.shadow)
        newView.layer.cornerRadius = Styles.TabBar.radius
        newView.layer.name = "Background"
        let helper = UIView()
        helper.layer.masksToBounds = true
        helper.layer.cornerRadius = Styles.TabBar.radius
        newView.addSubview(helper)
        let safeArea = navigationController?.view.safeAreaInsets.bottom ?? 0
        let tabHeight = tabBar.frame.height + 14
        if #available(iOS 11.0, *) {
            newView.addConstaits([.left:5, .right:-5, .bottom:(safeArea - 2) * -1, .height:tabHeight], superV: view)
            helper.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: newView)
            
        }
        let backFrame:CGRect = .init(origin: .zero, size: .init(width: self.view.frame.width, height: safeArea + tabHeight))
        helper.layer.createGradient(.darkGreen, frame: backFrame)
        self.view.insertSubview(whiteBack, at: 1)

        whiteBack.addConstaits([.left:0, .right:0, .bottom:0, .height:54 + safeArea], superV: self.view)
        let _ = whiteBack.addBluer(frame: backFrame)
    }
    private func createSelectionView() {
        guard let toView = self.view.subviews.first(where: {$0.layer.name == "Background"}) else { return }
        let width:CGFloat = 50
        let view = UIView(frame: .init(origin: .init(x: 50, y:7), size: .init(width: width, height: width)))
        view.backgroundColor = Styles.TabBar.selection
        view.layer.cornerRadius = width / 2
        view.layer.name = "SelectionView"
        view.layer.shadow(opasity: Styles.shadow1)
        toView.addSubview(view)
        moveSelectionView(0)

    }
    
    private func moveSelectionView(_ selectedTab:Int) {
        guard let backView = self.view.subviews.first(where: {$0.layer.name == "Background"}),
              let selectionView = backView.subviews.first(where: {$0.layer.name == "SelectionView"}) else { return }
        let step = self.view.frame.width / CGFloat(self.viewControllers?.count ?? 0)

        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7) {
            selectionView.frame.origin = .init(x: CGFloat(step * CGFloat(selectedTab)) + (CGFloat.random(in: (50 + 2)..<(50 + 14))), y: 7)

        }
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            super.selectedViewController = selectedViewController
            moveSelectionView(selectedIndex)
            updateTitle() 
            viewControllers?.forEach({
                $0.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: $0 == selectedViewController ? 15 : 50)

            })


        }
    }

    func updateTitle() {
        title = viewControllers?[selectedIndex].title
    }
    
}




extension TabBarController {
    static func configure() -> TabBarController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
    }
}
