//
//  ModelLifeCycle.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import Foundation

protocol ModelLifeCycle {
    mutating func deinitialize()
}
