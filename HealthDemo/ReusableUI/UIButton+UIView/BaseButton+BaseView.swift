//
//  BaseButton.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit

@IBDesignable
class BaseView:UIView {
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {

            self.layer.cornerRadius = cornerRadius == -1 ? Styles.viewRadius : self.cornerRadius
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable open var lineColor: UIColor? = nil {
        didSet {
            if let color = lineColor {
                self.layer.borderWidth = borderWidth == 0 ? 2 : borderWidth
                self.layer.borderColor = color.cgColor
            }
        }
    }
    

    @IBInspectable open var shadowOpasity: Float = 0 {
        didSet {
            if shadowOpasity != 0 {
                switch cornerRadius {
                case -1:
                    self.layer.shadow(opasity: Styles.shadow)
                case -5:
                    self.layer.shadow(opasity: Styles.shadow5)
                case -10:
                    self.layer.shadow(opasity: 1, radius: 4)
                default:
                    self.layer.shadow(opasity: shadowOpasity)
                }
            }
        }
    }
    
    @IBInspectable open var isOval: Bool = false {
        didSet {
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
    }
}

@IBDesignable
class BaseButton:UIButton {
    @IBInspectable open var isPrimary: Bool = false {
        didSet {
            setStyle(primary: true)
        }
    }
    
    @IBInspectable open var isSecondary: Bool = false {
        didSet {
            setStyle(primary: false)
        }
    }
    
    private func setStyle(primary:Bool) {

        self.backgroundColor = primary ? K.Colors.link : K.Colors.grey
        self.tintColor = primary ? K.Colors.Text.buttonTitle : K.Colors.black
        self.layer.cornerRadius = Styles.buttonRadius1
        //self.layer.masksToBounds = !backgroundShadow
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius == -1 ? Styles.buttonRadius1 : self.cornerRadius
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable open var lineColor: UIColor? = nil {
        didSet {
            if let color = lineColor {
                self.layer.borderWidth = borderWidth == 0 ? 2 : borderWidth
                self.layer.borderColor = color.cgColor
            }
        }
    }
    

    @IBInspectable open var shadowOpasity: Float = 0 {
        didSet {
            if shadowOpasity != 0 {
                self.layer.shadow(opasity: shadowOpasity == -1 ? Styles.shadow : shadowOpasity)
            }
        }
    }
    
    @IBInspectable open var isOval: Bool = false {
        didSet {
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
    }
}
