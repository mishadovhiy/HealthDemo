//
//  OvalView.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 13.12.2023.
//

import UIKit

class OvalView:TouchView {
    
    private var drawed = false

    override func didMoveToWindow() {
        super.didMoveToWindow()
        removeTouchView()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateUI()

        if !drawed {
            drawed = true
            self.addOvalProgress(percent: 0.3, width: isSmall ? 3 : 5, canDivide: false, isSmall: isSmall)
        }
    }
    
    
    func updateUI() {
        titleLabel.textAlignment = .center
        titleLabel.frame = .init(origin: !isSmall ? .zero : .init(x: 0, y: -25), size: self.frame.size)
        titleLabel.font = .systemFont(ofSize: isSmall ? 11 : 17, weight: .semibold)
        titleLabel.numberOfLines = 0
    }
    
    var isCopy:Bool = false
    var isSmall:Bool {
        return self.frame.width <= 80
    }
    
    var data:OvalFavoriteData? {
        didSet {
            let percent = CGFloat(data?.percent ?? 0) / CGFloat(100)
            let text:NSMutableAttributedString = .init(string: "")
            if let img = (data?.key?.message ?? data?.keyResult.1?.message)?.imageName, #available(iOS 13.0, *) {
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(systemName: img)?.withTintColor(K.Colors.link)
                attachment.bounds = .init(origin: .zero, size: .init(width:isSmall ? 15 : 40, height: isSmall ? 15 : 40))
                text.append(.init(attachment: attachment))
                if !isSmall {
                    text.append(.init(string: "\n\n"))
                }
            }
            if !isSmall || isCopy {
                text.append(.init(string: ((data?.key?.message ?? data?.keyResult.1?.message)?.title ?? "?") + "\n"))
                text.append((.init(string: "\(data?.percent ?? 0)%", attributes: [
                    .font:UIFont.systemFont(ofSize: 12, weight: .semibold)
                ])))
            }
            titleLabel.attributedText = text
            let progLayer = self.layer.sublayers?.first(where: {$0.name == "achiveIndicator"})
            (progLayer as? CAShapeLayer)?.strokeEnd = percent
        }
    }
    
    var titleLabel:UILabel {
        return subviews.first(where: {$0 is UILabel}) as? UILabel ?? .init()
    }
    

}
