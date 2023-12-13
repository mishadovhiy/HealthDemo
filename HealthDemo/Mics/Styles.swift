//
//  Styles.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import Foundation

struct Styles {
    static let shadow:Float = 0.09
    static let shadow1:Float = 0.2
    static let shadow2:Float = 0.2
    static let shadow3:Float = 0.35
    static let shadow4:Float = 0.45
    static let shadow5:Float = 0.8


    static let buttonPressedComponentDelta:CGFloat = 0.01
    static let viewPressedComponentDelta:CGFloat = 0.25
    static let pressedAnimation:CGFloat = 0.3
    static let pressedAnimation1:CGFloat = 0.45
    static let pressedAnimation2:CGFloat = 0.65
    static let pressedAnimation09:CGFloat = 0.25
    static let pressedAnimation08:CGFloat = 0.20
    static let pressedAnimation07:CGFloat = 0.15


    static let borderWidth05:CGFloat = 0.5

    static let borderWidth:CGFloat = 2


    static let opacityBackground09:CGFloat = 0.1

    static let opacityBackground:CGFloat = 0.15
    static let opacityBackground1:CGFloat = 0.23

    static let buttonRadius:CGFloat = 5
    static let buttonRadius1:CGFloat = 9
    static let buttonRadius2:CGFloat = 12
    static let viewRadius:CGFloat = 9
    static let viewRadius1:CGFloat = 10
    static let viewRadius2:CGFloat = 15

    
    
    static let viewRadius5:CGFloat = 25


    struct TabBar {
        static let background = K.Colors.primaryBackground
        static let selection = K.Colors.Multicolor.red
        static let shadow = K.Colors.shadow
        static let radius = Styles.viewRadius2
        static let shadowOpacity = Styles.shadow2

    }
    
    static let launchAnimation1 = 0.5
    static let launchAnimation2 = 0.43

    
    struct Graph {
        static let lineWidth:CGFloat = 2
        static let ovalSize:CGFloat = 8

        static let bar1:CGFloat = 2
        static let bar2:CGFloat = 2
        static let bar3:CGFloat = 2
        
        static let separetor = K.Colors.separetor1
        
        static let tint = K.Colors.link
        static let shadowOpacity:Float = 0.2
    }

}
