//
//  K.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit

struct K {
    struct ImageName {
        static let error = ""
    }
    struct Colors {
        static let primaryBackground = UIColor(named: "primary")!
        static let secondaryBackground = UIColor(named: "secondary")!
        static let containerBackground = UIColor(named: "container")!

        static var separetor:UIColor = UIColor(named: "separetor")!
        static var separetor1:UIColor = UIColor(named: "separetor1")!

        static let selection = UIColor(named: "selection")!
        static let shadow = UIColor(named: "shadow")!
        static let shadowGray = UIColor(named: "shadowGray")!

        static let link = UIColor(named: "link")!
        static let white = UIColor(named: "white")!
        static let black = UIColor.init(named: "black")!

        static let grey = UIColor(named: "gray")!
        static let forceWhite = UIColor(named: "forceWhite")!
        
        struct Text {
            static let primary = UIColor(named: "Text/primary")!
            static let secondary = UIColor(named: "Text/secondary")!
            static let buttonTitle = UIColor(named: "forceWhite")!
        }
        struct Multicolor {
            static let red = UIColor(named: "Colored/red")!
            static let green = UIColor(named: "Colored/green")!
            static let blue = UIColor(named: "Colored/blue")!
            static let blue2 = UIColor(named: "Colored/blue2")!
            static let green1 = UIColor(named: "Colored/green1")!
            static let orange = UIColor(named: "Colored/orange")!
            static let pink = UIColor(named: "Colored/pink")!

        }
    }
}

