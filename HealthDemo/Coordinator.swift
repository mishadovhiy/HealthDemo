//
//  Coordinator.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit

struct Coordinator {
    
    private var appDelegate:AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    private var navigationController:UINavigationController? {
        return appDelegate?.window?.rootViewController as? UINavigationController
    }
    
    func start() -> UIViewController {
        if DataBase.db.general.dataLoaded {
            print("grandeddfeds")
            return TabBarController.configure()
        } else {
            print("notgrandeddfeds")
            let vc = MessageViewController.configure()
            vc.messageType = .health
            return vc
        }
      //  return TabBarController.configure()
    }
    
    func push(_ viewController:UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popTo(presenting viewController:UIViewController) {
        navigationController?.popToViewController(viewController, animated: true)
    }
    
    func presentModally(viewController:UIViewController) {
        navigationController?.present(viewController, animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}


extension Coordinator {
    
    func toHomeVC() {
        
    }
    
    func toFetchHealth() {
        appDelegate?.fetchComplited(.init(dict: [:]))
     /*   if appDelegate?.health?.checkPermition() ?? false {
            let vc = LoadingViewController.configure()
            push(vc)
            appDelegate?.health?.startFetching()
        } else {
            if let messageVC = navigationController?.viewControllers.contains(where: {$0 is MessageViewController}) as? MessageViewController,
               messageVC.messageType?.isHealth ?? false {
                
                messageVC.messageType = .healphError
                messageVC.updateUI()
            } else {
                let vc = MessageViewController.configure()
                vc.messageType = .healphError
                self.push(vc)
            }
            
        }*/
        
        
    }
    
    
}


