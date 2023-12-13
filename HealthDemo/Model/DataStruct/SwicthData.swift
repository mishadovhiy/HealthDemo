//
//  SwicthData.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import Foundation

struct SwitchData {
    let title:String
    let isOn:Bool
    let switched:(_ isOn:Bool)->()
}
