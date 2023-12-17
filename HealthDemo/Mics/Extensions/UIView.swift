//
//  UIView.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 09.12.2023.
//

import UIKit

extension UIView {
    func addConstaits(_ constants:[NSLayoutConstraint.Attribute:CGFloat], superV:UIView) {
        let layout = superV
        constants.forEach { (key, value) in
            let keyNil = key == .height || key == .width
            let item:Any? = keyNil ? nil : layout
            superV.addConstraint(.init(item: self, attribute: key, relatedBy: .equal, toItem: item, attribute: key, multiplier: 1, constant: value))
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addBluer(frame:CGRect? = nil, style:UIBlurEffect.Style = (.init(rawValue: -1000) ?? .regular), insertAt:Int? = nil) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)//prominent//dark//regular
        let bluer = UIVisualEffectView(effect: blurEffect)
        //bluer.frame = frame ?? .init(x: 0, y: 0, width: frame?.width ?? self.frame.width, height: frame?.height ?? self.frame.height)
        // view.insertSubview(blurEffectView, at: 0)
        let vibracity = UIVisualEffectView(effect: blurEffect)
        // vibracity.contentView.addSubview()
        bluer.contentView.addSubview(vibracity)
        let constaints:[NSLayoutConstraint.Attribute : CGFloat] = [.leading:0, .top:0, .trailing:0, .bottom:0]
        vibracity.addConstaits(constaints, superV: bluer)
        if let at = insertAt {
            self.insertSubview(bluer, at: at)
        } else {
            self.addSubview(bluer)
        }
        
        bluer.addConstaits(constaints, superV: self)
        
        return bluer
    }
    
    func animatedTransition(_ duration:CFTimeInterval = Styles.pressedAnimation, type:CATransitionType = .fade) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
                .linear)
        animation.type = type
        animation.duration = duration
        layer.add(animation, forKey: type.rawValue)
    }
    
    
    
    func contains(_ touches: Set<UITouch>) -> Bool {
        if let loc = touches.first?.location(in: self),
           frame.contains(loc) {
            return true
        } else {
            return false
        }
    }
    func removeWithAnimation(animation:CGFloat = Styles.pressedAnimation, complation:(()->())? = nil) {
        UIView.animate(withDuration: animation, animations: {
            self.alpha = 0
            self.layer.zoom(value: 1.4)
        }) {
            if !$0 {
                return
            }
            self.isHidden = true
            
            if let com = complation {
                com()
            }
            self.removeFromSuperview()
        }
    }
    func hideWithAnimation(_ hidden:Bool, animation:CGFloat = Styles.pressedAnimation) {
        UIView.animate(withDuration: animation, animations: {
            self.isHidden = hidden
        })
    }
}


extension UIView {
    func addOvalProgress(percent:CGFloat, width:CGFloat? = nil, color:UIColor? = nil, canDivide:Bool = true, isSmall:Bool = false) {
        addShape(percent: 1, main: false, canDivide: canDivide, color: color, width: width, isSmall: isSmall)
        addShape(percent: percent, canDivide: canDivide, color: color, width: width, isSmall: isSmall)
    }
    
    private func addShape(percent:Double, main:Bool = true, canDivide:Bool, color:UIColor?, width:CGFloat?, isSmall:Bool = false) {
        if let shape = self.layer.sublayers?.first(where: {$0.name == (main ? "achiveIndicator" : "achiveIndicator1")}) {
            if main {
                (shape as! CAShapeLayer).strokeEnd = canDivide ? ((percent / 2) + 0.5) : percent

            }
        } else {
            let shape:CAShapeLayer = .init()
            shape.backgroundColor = UIColor.clear.cgColor
            shape.lineWidth = width ?? 2
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeColor = main ? (color ?? K.Colors.link).cgColor : K.Colors.link.withAlphaComponent(0.1).cgColor
            if main {
                shape.strokeEnd = main ? (canDivide ? ((percent / 2) + 0.5) : percent) : 1

            }
            shape.name = main ? "achiveIndicator" : "achiveIndicator1"
            shape.createOvalPath(.init(origin: canDivide ? .zero : .init(x: 2, y: 2), size: canDivide ? self.frame.size : .init(width: frame.width - (isSmall ? 10 : 20), height: frame.width - (isSmall ? 10 : 20))))
            self.layer.addSublayer(shape)
        }
        
    }
    func rotate(rotation:CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: rotation * .pi / 180)
    }
    func createTouchView() {
        if self.subviews.first(where: {$0.layer.name == "createTouchView"}) != nil {
            return
        }
        let isBig = self.frame.width >= 50 ? true : false
        let size:CGSize = .init(width: isBig ? 64 : 44, height: isBig ? 64 : 44)
        let view = UIView(frame:.init(origin: .zero, size: size))
        let color = K.Colors.white.withAlphaComponent(Styles.opacityBackground1)
        view.backgroundColor = color
        view.layer.cornerRadius = size.width / 2
        view.layer.shadow(color: K.Colors.white, radius: 15)
        view.layer.name = "createTouchView"
        self.addSubview(view)
        view.alpha = 0
        self.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
    }
    
    func moveTouchView(show:Bool, at:(UITouch?, UIView)? = nil) {
        guard let view = self.subviews.first(where: {$0.layer.name == "createTouchView"}) else { return }
        if !show {
            view.animatedTransition(Styles.pressedAnimation)
        }
        view.alpha = show ? 1 : 0
        if let at = at {
            let touch = at.0?.location(in: at.1) ?? .zero
            UIView.animate(withDuration: show ? 0 : Styles.pressedAnimation) {
                view.frame.origin = .init(x: touch.x - 23, y: touch.y - 18)
            }
        }
    }
    
    func removeTouchView() {
        guard let view = self.subviews.first(where: {$0.layer.name == "createTouchView"}) else { return }
        view.removeFromSuperview()
    }
    
    
    
    func copy<T: UIView>(toView:UIView?, frame:CGRect?) -> T {
        let new = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
        if let toView = toView {
            toView.addSubview(new)
            new.frame = frame ?? self.frame
            new.subviews.forEach({
                $0.frame = .init(origin: .zero, size: new.frame.size)
            })
        }
        return new
    }
}
