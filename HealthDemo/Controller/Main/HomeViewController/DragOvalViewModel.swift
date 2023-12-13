//
//  DragOvalModel.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 12.12.2023.
//

import HealthKit
import UIKit

struct OvalFavoriteData {
    let percent:Int
    let key:HKQuantityTypeIdentifier
}

class DragOvalViewModel {
    
    weak var ovalsStack:UIStackView!
    var ovalViews: [OvalView]!
    weak var view:UIView!
    
    private var ovalInitialFrame:CGRect = .zero
    private weak var copiedView:UIView?
    private var frames:[Int:CGRect] = [:]
    
    var data:[OvalFavoriteData]!
    
    init(ovalsStack: UIStackView, ovalViews: [OvalView], data:[OvalFavoriteData], view:UIView) {
        self.ovalsStack = ovalsStack
        self.ovalViews = ovalViews
        self.view = view
        self.data = data

        setupUI()

        updateAll()
    }
    
    private func updateAll() {
        ovalViews.forEach({
                $0.animatedTransition(Styles.pressedAnimation09, type: .fade)
            if data.count - 1 >= $0.tag {
                $0.data = data[$0.tag]

            }
        })
    }
    
    func dragChanged(tag:Int, newTag:Int, force:Bool = false) {
        if tag != newTag {
            print("Tagchanged from: ", tag, " newTag: ", newTag)
            copiedView?.tag = newTag
            let color = data[tag]
            data.remove(at: tag)
            data.insert(color, at: newTag)
            ovalViews.forEach({
              //  let animated = $0.backgroundColor != data[$0.tag]
                //if animated {
                    $0.animatedTransition(Styles.pressedAnimation09, type: .fade)
                //}
                $0.data = data[$0.tag]
                print(data[$0.tag], " yuthgrytvefrgt")
              //  $0.backgroundColor = data[$0.tag]
                $0.alpha = newTag == $0.tag ? (force ? 1 : 0) : 1
            })
            DataBase.db.general.favoritesOrder = data.compactMap({$0.key.rawValue})
            
        }
    }
    
    
}

fileprivate extension DragOvalViewModel {
    func setupUI() {
        setupOvals()
        ovalViews.forEach({
            let frame = $0.convert($0.bounds, to: ovalsStack)
            frames.updateValue(frame, forKey: $0.tag)
            print(frame, " rtegrf")
        })
    }
    
    private func setupOvals() {
        ovalViews.forEach({
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(ovalPanGesture(_:)))
            $0.addGestureRecognizer(gesture)
        })
    }
    
    private func checkContains(_ frame:CGRect) {
        frames.forEach({
            if $0.value.contains(.init(origin: frame.origin, size: .init(width: 5, height: 5))) {
                print("sfgda ", $0.key)
                dragChanged(tag: copiedView?.tag ?? -1, newTag: $0.key)
            }
        })
    }
    
    @objc func ovalPanGesture(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:
            let view = sender.view ?? UIView()
            let smallViewOrigin:CGPoint = .init(x: view.superview!.frame.minX + ovalsStack.arrangedSubviews.first!.frame.minX, y: view.frame.minY)
            let subStack = ovalsStack.arrangedSubviews.first(where: {$0 is UIStackView}) as! UIStackView
            let size = subStack.arrangedSubviews.last!.frame.size
            //view.frame.size
            let bigViewOrigin:CGPoint = .init(x: view.frame.width / 2, y: view.frame.height / 2)
            let frame:CGRect = .init(origin: view.tag == 0 ? bigViewOrigin : smallViewOrigin, size: size)
            ovalInitialFrame = frame
            print(ovalInitialFrame, " rtefdwefrtrg")
            copiedView = sender.view?.copy(toView: ovalsStack, frame:  frame)
            copiedView?.backgroundColor = sender.view?.backgroundColor
            copiedView?.layer.shadow()
         //   copiedView?.subviews.forEach({$0.removeFromSuperview()})
            copiedView?.layer.masksToBounds = false
            sender.view?.alpha = 0
        case .changed:
            let newOriginX = ovalInitialFrame.origin.x + translation.x
            let newOriginY = ovalInitialFrame.origin.y + translation.y
            
            let newFrame = CGRect(x: newOriginX, y: newOriginY, width: ovalInitialFrame.width, height: ovalInitialFrame.height)
            let frameInSuper = copiedView!.convert(copiedView!.bounds, to: ovalsStack)
            print(frameInSuper, " rtegfwd")
            checkContains(frameInSuper)
            copiedView?.frame = newFrame
        case .ended, .cancelled:
            copiedView?.removeWithAnimation()
            ovalViews.forEach({
                $0.animatedTransition(type: .fade)
                $0.alpha = 1})
            updateAll()
        default:
            break
        }
    }
}
