//
//  OvalView.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import UIKit

class OvalView:TouchView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        removeTouchView()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        titleLabel.textAlignment = .center
        titleLabel.frame = .init(origin: !isSmall ? .zero : .init(x: 0, y: -25), size: self.frame.size)
        titleLabel.font = .systemFont(ofSize: isSmall ? 11 : 17, weight: .semibold)
        self.addOvalProgress(percent: 0.3, width: isSmall ? 3 : 5, canDivide: false, isSmall: isSmall)
        titleLabel.numberOfLines = 0
    }
    
    
    var isSmall:Bool {
        return self.frame.width <= 80
    }
    var data:OvalFavoriteData? {
        didSet {
            let percent = CGFloat(CGFloat(data?.percent ?? 0) / CGFloat(100))
            titleLabel.text = isSmall ? "\(data?.percent ?? 0)" : "\(data?.key.message?.title ?? "?")\n\(data?.percent ?? 0)"
            let progLayer = self.layer.sublayers?.first(where: {$0.name == "achiveIndicator"})
            print(percent, " htyrgfvc")
            (progLayer as? CAShapeLayer)?.strokeEnd = percent
        }
    }
    
    var titleLabel:UILabel {
        return subviews.first(where: {$0 is UILabel}) as? UILabel ?? .init()
    }
    

}
