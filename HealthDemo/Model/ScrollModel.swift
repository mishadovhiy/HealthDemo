//
//  ScrollModel.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 09.12.2023.
//

import UIKit

protocol ScrollModelProtocol {
    func selectedRowChanged(new row:Int)
}

struct ScrollModel {
    weak var collectionView:UICollectionView!
    var dataCount:Int = 0
    let delegate:ScrollModelProtocol
    init(delegate:ScrollModelProtocol) {
        self.delegate = delegate
    }
    mutating func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        scrolled = false

    }
    
    mutating func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scroll = scrollView.contentOffset.x
        let pos = getFromScroll(scroll)
        
        if pos != scrollPos {
            scrollPos = pos
        }
        
    }
    
    
    mutating func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if waitDeclar {
            waitDeclar = false
            completeScrolling(scrollView.contentOffset.x)
        }
    }
    
    private mutating func scrollDirection(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView)
        scrollDirection = velocity.x > 0 ? .right : .left
    }
    
    mutating func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollDirection(scrollView)

        waitDeclar = decelerate
        if !decelerate {
            completeScrolling(scrollView.contentOffset.x)
        }
        
    }
    
    private mutating func completeScrolling(_ position:CGFloat) {
        let selected = getFromScroll(position)
        scrolled = true
        if selected <= dataCount - 1 {
            collectionView.scrollToItem(at: .init(item: selected, section: 0), at: .centeredHorizontally, animated: true)
            delegate.selectedRowChanged(new: selected)
        } else {
            collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            delegate.selectedRowChanged(new: 0)
        }
        
    }
    
    mutating func getFromScroll(_ position:CGFloat) -> Int {
        let cellWindth = self.collectionView.frame.width
        let pos = position + (cellWindth / 2)
        let selectedFloat = pos / cellWindth
        let n = selectedFloat - CGFloat(Int(selectedFloat))
        let err = selectedFloat >= 2 || selectedFloat <= 1

        let toScroll = scrollDirection == .left ? 0.9 : 0.34
        let rN = n >= 0.68 && !err ? selectedFloat + 1 : (n <= toScroll && !err ? (selectedFloat - 1) : selectedFloat)

        var selectedIntResult = Int(rN != 0 && rN < CGFloat(Int.max) ? rN : 1)
        
        if selectedIntResult <= dataCount - 1 {
            selectedInt = selectedIntResult
        } else {
            selectedIntResult = selectedIntResult > 0 ? (dataCount - 1) : selectedIntResult
            selectedInt = selectedIntResult
        }
        return selectedIntResult
    }
    
    var selectedInt = 0
    private var scrollPos:Int = 0
    private var waitDeclar = false
    private var scrolled = false
    
    private var scrollDirection:ScrollDirection = .left
    enum ScrollDirection {
        case left
        case right
    }
    
    
}


