//
//  CALayer.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit

extension CALayer {
    
    
    enum CornerPosition {
        case top
        case btn
        case left
        case right
    }
    
    @available(iOS 11.0, *)
    func cornerRadius(at:CornerPosition, value:CGFloat?) {
        switch at {
        case .top:
            self.cornerRadius = value ?? (self.frame.height / 2)
            self.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .btn:
            self.cornerRadius = value ?? (self.frame.height / 2)
            self.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .left:
            self.cornerRadius = value ?? (self.frame.height / 2)
            self.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .right:
            self.cornerRadius = value ?? (self.frame.height / 2)
            self.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    enum MoveDirection {
        case top
        case left
    }
    
    func move(_ direction:MoveDirection, value:CGFloat) {
        switch direction {
        case .top:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, 0, value, 0)
        case .left:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, value, 0, 0)
        }
    }
    
    func zoom(value:CGFloat) {
        self.transform = CATransform3DMakeScale(value, value, 1)
    }
    
    func createPath(_ lines:[CGPoint]) -> UIBezierPath {
        let linePath = UIBezierPath()
        var liness = lines
        guard let lineFirst = liness.first else { return .init() }
        linePath.move(to: lineFirst)
        liness.removeFirst()
        liness.forEach { line in
            linePath.addLine(to: line)
        }
        return linePath
    }
    
    func drawLine(_ lines:[CGPoint], color:UIColor? = K.Colors.separetor, width:CGFloat = Styles.borderWidth05, opacity:Float = Float(Styles.opacityBackground09), background:UIColor? = nil, insertAt:UInt32? = nil, name:String? = nil, isMultiple:Bool = false) -> CAShapeLayer? {
        
        let line = CAShapeLayer()
        let contains = !isMultiple ? self.sublayers?.contains(where: { $0.name == (name ?? "")} ) : false
        let canAdd = name == nil ? true : !(contains ?? false)
        if canAdd {
            line.path = createPath(lines).cgPath
            line.opacity = opacity
            line.lineWidth = width
            line.strokeColor = (color ?? .red).cgColor
            line.name = name
            if let background = background {
                line.backgroundColor = background.cgColor
                line.fillColor = background.cgColor
            }
            if let at = insertAt {
                self.insertSublayer(line, at: at)
            } else {
                self.addSublayer(line)
            }
            
            return line
        } else {
            return nil
        }
        
    }
    
    
    func shadow(opasity:Float = Styles.shadow, color:UIColor? = nil, radius:CGFloat? = nil) {
        let col = K.Colors.shadow
        self.shadowColor = (color ?? col).cgColor
        self.shadowOffset = .zero
        self.shadowRadius = radius ?? 10
        self.shadowOpacity = opasity
    }
    
    
}

extension CAShapeLayer {
    func createOvalPath(_ frame:CGRect) {
        self.path = UIBezierPath(ovalIn: .init(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)).cgPath
    }
}

extension CAShapeLayer {
    func animate(value:(from: CGFloat, to: CGFloat), key:animationKeys, duration:CFTimeInterval, completion:@escaping() -> ()) {//stoke

        addAnimation(value: value, key: key, duration: duration) {
            self.strokeEnd = value.to
            self.removeAllAnimations()
        }
    }
    
    func animatePath(value:(from: CGPath?, to: CGPath), key:animationKeys, duration:CFTimeInterval, completion:@escaping() -> ()) {
        let from:CGPath = value.from ?? .init(rect: .zero, transform: nil)
        addAnimation(value: (from:from, to:value.to), key: key, duration: duration) {
            self.path = value.to
            self.removeAllAnimations()
            completion()
        }
    }
    
    private func animation(value:(from:Any, to:Any), for key:animationKeys, diration:CFTimeInterval = 5) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: key.rawValue)
        animation.fromValue = value.from
        animation.toValue = value.to
        animation.duration = diration
        animation.autoreverses = false
        animation.repeatCount = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        return animation
    }
    
    private func addAnimation(value:(from: Any, to: Any), key:animationKeys, duration:CFTimeInterval, completion:@escaping() -> ()) {
        CATransaction.begin()
        let animation = self.animation(value: (from:value.from,to:value.to), for: key, diration:duration)
        CATransaction.setCompletionBlock {
            completion()
        }
        self.add(animation, forKey: "line")
        CATransaction.commit()
    }
    enum animationKeys:String {
        case strokeEnd = "strokeEnd"
        case path = "path"
    }
    
    func animationFill(for key:animationKeys,
                       data:String,
                       completion:@escaping(_ data:String) -> ()) {
        let result: CGFloat = 1
        if self.strokeEnd < result {
            let newValue:CGFloat = 1
            CATransaction.begin()
            let animation = self.animation(value: (from:0,to:newValue), for: key)
            CATransaction.setCompletionBlock {
                completion(data)
            }
            self.add(animation, forKey: "line")
            CATransaction.commit()
        } else {
            self.strokeEnd = 1
            self.removeAllAnimations()
            completion(data)
        }
    }
    
}


extension CALayer {
    func gradientWithClear(_ color:UIColor, size:CGSize? = nil, x:CGFloat = 0) {
        
        let colors = [
            color.withAlphaComponent(0).cgColor,
            color.cgColor
        ]
        let frame = CGRect(x: x, y: -30, width: size?.width ?? (self.frame.width - 40), height: size?.height ?? 40)
        let _ = gradient(colors: colors,
                         points: (start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1)),
                         locations: [0.0, 0.7, 1.0],
                         frame: frame,
                         insertAt: 0)
        
    }
    
    func gradientVertical(_ color:UIColor, superSize:CGSize, gradientWidth:CGFloat = 50, isRight:Bool = true) {
        
        let colors = [
            color.withAlphaComponent(!isRight ? 1 : 0).cgColor,
            color.withAlphaComponent(isRight ? 1 : 0).cgColor
        ]
        
        let frame = CGRect(x: superSize.width, y: 0, width: gradientWidth, height: superSize.height)
        let _ = gradient(colors: colors,
                         points: (start: .init(x: 0, y: 0.5), end: .init(x: 1, y: 0.5)),
                         locations: nil,//[0.0, 0.6, 1.0],
                         frame: frame,
                         type: .axial
        )
        
    }
    func gradient(colors:[CGColor], points:(start:CGPoint, end:CGPoint), locations:[NSNumber]?, frame:CGRect? = nil, type:CAGradientLayerType? = nil, insertAt:UInt32? = nil, zpozition:Int? = nil, radious:CGFloat? = nil, opasity:Float? = nil) -> CAGradientLayer? {
        let l = CAGradientLayer()
        l.colors = colors
        if let type = type {
            l.type = type
        }
        if let radious = radious {
            l.cornerRadius = radious
        }
        if let locations = locations {
            l.locations = locations
        }
        
        l.startPoint = points.start
        l.endPoint = points.end
        l.frame = frame ?? .init(x: frame?.midX ?? 0, y: frame?.midY ?? 0, width: self.frame.width, height: self.frame.height)
        //.init(x: 0, y: 0, width: frame.width, height: frame.height)
        if let at = insertAt {
            self.insertSublayer(l, at: at)
        } else {
            self.addSublayer(l)
        }
        if let zpozition = zpozition {
            l.zPosition = CGFloat.init(integerLiteral: zpozition)
        }
        if let opasity = opasity {
            l.opacity = opasity
        }
        return l
    }
    
    func mulltippleGradient(_ type: MulltippleGradientType, dark:Bool, width:CGFloat? = nil, height:CGFloat? = nil) {
        let alpha = dark ? 0.4 : 1
        let frame:CGRect = .init(x: 0, y: 0, width: width ?? self.bounds.width + 20, height: (height ?? self.bounds.height) + 50)
        let gradientColors = typeToColorsMulttiple(type, alpha: alpha)
        let name = "MulltippleGradientType"
        self.sublayers?.removeAll(where: { layer in
            return layer.name == name
        })
        let gradient = self.gradient(colors: gradientColors.background,
                                     points: (start: .init(x: 0, y: 0.5), end: .init(x: 1, y: 0)),
                                     locations: [0.0, 0.6, 1.0],
                                     frame: frame,
                                     insertAt: 0)
        gradient?.name = name
        let oval = ovalGradient(frame: frame, color: gradientColors.oval)
        oval?.name = name
        
    }
    
    func ovalGradient(frame:CGRect, color: [CGColor], insert:UInt32? = 1, middle:Bool = false, radous:CGFloat? = nil) -> CAGradientLayer? {
        return self.gradient(colors: color,
                             points: (start: .init(x: 0.8, y: !middle ? 0.1 : 0.5), end: .init(x: 1, y: 1)),
                             locations: [0.0, 0.75, 1.0],
                             frame: frame,
                             type: .radial,
                             insertAt: insert,
                             radious: radous
        )
    }
    
    
    func typeToColorsMulttiple(_ type:MulltippleGradientType, alpha:CGFloat) -> (background: [CGColor], oval:[CGColor]) {
        switch type {
        case .bluePurpure:
            return (background: [
                UIColor.init(red: 82/255, green: 159/255, blue: 231/255, alpha: alpha).cgColor,
                UIColor.init(red: 211/255, green: 58/255, blue: 245/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: alpha).cgColor,
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: 0).cgColor,
                    ])
        case .orangeBlue:
            return (background: [
                UIColor.init(red: 250/255, green: 141/255, blue: 12/255, alpha: 1).cgColor,
                K.Colors.link.cgColor,
            ],
                    oval:[
                        UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 0.6).cgColor,
                        UIColor.init(red: 254/255, green: 12/255, blue: 99/255, alpha: 0).cgColor,
                    ])
        case .blueViolet:
            return (background: [
                UIColor.init(red: 107/255, green: 187/255, blue: 139/255, alpha: alpha).cgColor,
                UIColor.init(red: 88/255, green: 40/255, blue: 190/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 213/255, green: 80/255, blue: 104/255, alpha: alpha).cgColor,
                        UIColor.init(red: 213/255, green: 80/255, blue: 104/255, alpha: 0).cgColor
                    ])
        case .greenBlue:
            return (background: [
                UIColor.init(red: 213/255, green: 184/255, blue: 80/255, alpha: alpha).cgColor,
                UIColor.init(red: 26/255, green: 54/255, blue: 58/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 80/255, green: 93/255, blue: 213/255, alpha: alpha).cgColor,
                        UIColor.init(red: 80/255, green: 93/255, blue: 213/255, alpha: 0).cgColor,
                    ])
        case .pinkYellow:
            return (background: [
                UIColor.init(red: 82/255, green: 159/255, blue: 231/255, alpha: alpha).cgColor,
                UIColor.init(red: 211/255, green: 58/255, blue: 245/255, alpha: alpha).cgColor
            ],
                    oval:[
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: alpha).cgColor,
                        UIColor.init(red: 194/255, green: 45/255, blue: 143/255, alpha: 0).cgColor,
                    ])
        }
    }
    
    enum MulltippleGradientType:Int {
        case bluePurpure = 0
        case blueViolet = 1
        case greenBlue = 2
        case pinkYellow = 3
        case orangeBlue = 4
        

        init?(rawValue: Int?) {
            switch rawValue ?? -1 {
            case 0: self = .bluePurpure
            case 1: self = .blueViolet
            case 2: self = .greenBlue
            case 3: self = .pinkYellow
            case 4: self = .orangeBlue
            default:
                self = .init(rawValue: Int.random(in: 0..<4)) ?? .bluePurpure
            }
        }
    }
    
    func createGradient(_ type:GradientType, zpozition:Int? = nil, radius:CGFloat? = nil, frame:CGRect? = nil) {
        let name = "GradientType"
        self.sublayers?.removeAll(where: { layer in
            return layer.name == name
        })
        let frame:CGRect = frame ?? .init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let gradient = self.gradient(colors: type.colors,
                                     points: (start: .init(x: 0, y: 0), end: .init(x: 1, y: 1)),
                                     locations: nil,
                                     frame: frame,
                                     insertAt: zpozition != nil ? 0 : nil,
                                     zpozition: zpozition
        )
        gradient?.name = name
        if let radius = radius {
            gradient?.masksToBounds = true
            gradient?.cornerRadius = radius
        }
    }
    
    func removeGradients() {
        let name = "GradientType"
        self.sublayers?.removeAll(where: { layer in
            return layer.name == name
        })
    }
    func typeToColors(_ type:GradientType) -> [CGColor] {
        return type.colors
    }
    
    enum GradientType:String {
        case red = "red"
        case orange = "orange"
        case yellow = "yellow"
        case green = "green"
        case blue = "blue"
        case gold = "gold"
        case silver = "silver"
        case bronze = "bronze"
        
        case darkGreen = "darkGreen"
        case darkRed = "darkRed"
        case menuBlue = "menuBlue"
        
        init(string:String) {
            switch string {
            case "red": self = .red
            case "orange": self = .orange
            case "yellow": self = .yellow
            case "green": self = .green
            case "blue": self = .blue
            case "gold": self = .gold
            case "silver": self = .silver
            case "bronze": self = .bronze
            case "menuBlue": self = .menuBlue
            default: self = .red
            }
        }
        
        static func random() -> GradientType {
            let vals:[GradientType] = [.red, .orange, .green, .yellow, .blue, .gold, .silver, .bronze]
            return vals.randomElement() ?? .red
        }
        
        init() {
            let names = ["red", "orange", "yellow", "green", "blue", "gold", "silver", "bronze"]
            self = .init(string: names.randomElement() ?? "")
        }
        
        
        var colors:[CGColor] {
            switch self {
            case .red:
                return [
                    UIColor.init(red: 248/255, green: 39/255, blue: 77/255, alpha: 1).cgColor,
                    UIColor.init(red: 238/255, green: 141/255, blue: 158/255, alpha: 1).cgColor
                ]
            case .orange:
                return [
                    UIColor.init(red: 255/255, green: 102/255, blue: 54/255, alpha: 1).cgColor,
                    UIColor.init(red: 234/255, green: 120/255, blue: 104/255, alpha: 1).cgColor
                ]
            case .yellow:
                return [
                    UIColor.init(red: 222/255, green: 172/255, blue: 76/255, alpha: 1).cgColor,
                    UIColor.init(red: 242/255, green: 202/255, blue: 123/255, alpha: 1).cgColor
                ]
            case .green:
                return [
                    UIColor.init(red: 16/255, green: 173/255, blue: 2/255, alpha: 1).cgColor,
                    UIColor.init(red: 36/255, green: 209/255, blue: 21/255, alpha: 1).cgColor
                ]
            case .blue:
                return [
                    UIColor.init(red: 55/255, green: 170/255, blue: 253/255, alpha: 1).cgColor,
                    UIColor.init(red: 98/255, green: 187/255, blue: 252/255, alpha: 1).cgColor
                ]
            case .gold:
                return [
                    UIColor.init(red: 221/255, green: 152/255, blue: 66/255, alpha: 1).cgColor,
                    UIColor.init(red: 224/255, green: 175/255, blue: 89/255, alpha: 1).cgColor
                ]
            case .silver:
                return [
                    UIColor.init(red: 174/255, green: 174/255, blue: 197/255, alpha: 1).cgColor,
                    UIColor.init(red: 105/255, green: 105/255, blue: 130/255, alpha: 1).cgColor
                ]
            case .bronze:
                return [
                    UIColor.init(red: 212/255, green: 116/255, blue: 26/255, alpha: 1).cgColor,
                    UIColor.init(red: 237/255, green: 164/255, blue: 72/255, alpha: 1).cgColor
                ]
                
            case .darkGreen:
                return [
                    K.Colors.primaryBackground.withAlphaComponent(0.05).cgColor,
                    K.Colors.primaryBackground.lighter().withAlphaComponent(0.05).cgColor
                ]
            case .darkRed:
                return [
                    UIColor.init(red: 228/255, green: 35/255, blue: 116/255, alpha: 1).cgColor,
                    UIColor.init(red: 228/255, green: 24/255, blue: 24/255, alpha: 1).cgColor
                ]
            case .menuBlue:
                return [
                    UIColor.init(red: 52/255, green: 113/255, blue: 226/255, alpha: 1).cgColor,
                    UIColor.init(red: 91/255, green: 151/255, blue: 223/255, alpha: 1).cgColor
                ]
            }
        }
    }
}
