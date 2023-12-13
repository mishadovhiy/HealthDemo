//
//  TapAnimationView.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import UIKit

class TapAnimationView:UIView {
    func removeTapView() {
        guard let view = self.subviews.first(where: {$0.layer.name == "addTapView"}) else {
            return
        }
        view.removeWithAnimation()
    }
    
    func addTapView() {
        if let view = self.subviews.first(where: {$0.layer.name == "addTapView"}) {
            self.performAnimateTap(view: view, show: false, completion: {
                self.animateTap()
            })
        } else {
            let view = UIView()
            let w:CGFloat = 30
            view.isUserInteractionEnabled = false
            view.backgroundColor = K.Colors.white
            view.alpha = Styles.opacityBackground1
            view.layer.cornerRadius = w / 2
            view.layer.name = "addTapView"
            self.addSubview(view)
            view.addConstaits([.width:w, .height:w, .centerX:0, .centerY:0], superV: self)
            view.layer.shadow(color: K.Colors.white)
            self.performAnimateTap(view: view, show: false, completion: {
                self.animateTap()
            })
        }
        
    }
    
    private func animateTap() {
        guard let view = self.subviews.first(where: {$0.layer.name == "addTapView"}) else {
            return
        }
        
        self.tapAnimationGroup(view: view) {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
                self.animateTap()
            })
        }
    }
    
    private func tapAnimationGroup(view:UIView, completion:@escaping()->()) {
        performAnimateTap(view: view, show: true, completion: {
            self.performAnimateTap(view: view, completion: {
                
                
                self.performAnimateTap(view: view, show: true, delay: 0.05, completion: {
                    self.performAnimateTap(view: view, completion: {
                        completion()
                    })
                    
                })
                
                
                
            })
            
        })
        
    }
    
    private func performAnimateTap(view:UIView, show:Bool = false,delay:TimeInterval = 0, completion:@escaping()->()) {
        UIView.animate(withDuration: Styles.pressedAnimation09, delay: delay, options: .curveEaseInOut, animations: {
            view.alpha = show ? Styles.opacityBackground : 0
        }, completion: {
            if !$0 {
                return
            }
            completion()
        })
    }
}
