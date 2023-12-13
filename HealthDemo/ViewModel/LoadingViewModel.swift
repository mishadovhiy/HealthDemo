//
//  LoadingViewModel.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import Foundation
import UIKit

struct LoadingViewModel {
    let loadingData:LoadingData
    func nextPressed() {
        loadingData.pressed()
    }
}



struct HealthViewModel:LoadingProtocol {

    var displayData: LoadingData {
        return .init(title: "We need access to your Health & Activity data",
                     description: """
To provide you with a personalized and rewarding health
experience, we request your permission to access your health and activity
data. Enable access to your health data now.
""", nextTitle: "Request", pressed: {
            (UIApplication.shared.delegate as? AppDelegate)?.health?.requestHealthAccess()
        })
    }
    
    var healthNotGranded:LoadingData {
        return .init(title: "We need access to your Health & Activity data",
                     description: """
To provide you with a personalized and rewarding health
experience, we request your permission to access your health and activity
data. Enable access to your health data now.
""", nextTitle: "Try again", pressed: {
         //   UIApplication.shared.open(<#T##URL#>) // settings
        })
    }
    
    
}

protocol LoadingProtocol {
    var displayData:LoadingData { get }
}

struct LoadingData {
    let title:String
    var description:String? = nil
    var imageName:String? = nil
    var nextTitle:String? = nil
    var nextEnabled:Bool = false
    let pressed:()->()
}
