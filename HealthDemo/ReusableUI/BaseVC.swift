//
//  BaseVC.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit

class BaseVC:UIViewController {
    var canUpateUI:Bool = false
    
    var coodinator:Coordinator? {
        return appDelegate?.coodinator
    }
    
    var appDelegate:AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    
    func applicationBecomeActive() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        canUpateUI = true
    }
    func updateUI() {
        
    }
    
    func healthUpdated() {
        
    }
    
   

}

