//
//  UITableViewCell+UICollectionViewCell.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import UIKit

extension UITableViewCell {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        setSelectedColor(K.Colors.selection)
    }

    func setSelectedColor(_ color:UIColor) {
        if self.selectedBackgroundView?.layer.name != "setSelectedColor" {
            let selected = UIView(frame: .zero)
            selected.layer.name = "setSelectedColor"
            selected.backgroundColor = color
            self.selectedBackgroundView = selected
        } else {
            self.selectedBackgroundView?.backgroundColor = color
        }
    
    }
    
    
    func setCornered(indexPath:IndexPath, dataCount:Int, for view:UIView, needCorners:Bool = true, value:CGFloat = Styles.viewRadius2) {
        let needCorners = needCorners ? (indexPath.row == 0 || indexPath.row == (dataCount - 1)) : false
        let isFullyCornered = dataCount == 1
        let topRadius = indexPath.row == 0
        
        if needCorners {
            if isFullyCornered {
                view.layer.cornerRadius = value
                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            } else {
                if topRadius {
                    view.layer.cornerRadius(at: .top, value: value)
                } else {
                    view.layer.cornerRadius(at: .btn, value: value)
                }
            }
            
        } else {
            view.layer.maskedCorners = []
        }
    }
}

extension UICollectionViewCell {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        setSelectedColor(K.Colors.selection)
    }

    func setSelectedColor(_ color:UIColor) {
        if self.selectedBackgroundView?.layer.name != "setSelectedColor" {
            let selected = UIView(frame: .zero)
            selected.layer.name = "setSelectedColor"
            selected.backgroundColor = color
            self.selectedBackgroundView = selected
        } else {
            self.selectedBackgroundView?.backgroundColor = color
        }
    }
}


