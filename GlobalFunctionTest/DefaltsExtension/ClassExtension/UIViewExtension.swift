//
//  UIViewExtension.swift
//  GlobalFunctionTest
//
//  Created by Defalt Lee on 2022/3/31.
//

import Foundation
import UIKit

extension UIView {
    
    /// UI 最底層的 View
    /// - Returns: UI 最底層的 View
    func superSuperView() -> UIView {
        var superView = self
        
        guard superView.superview != nil else { return self }
        
        while true {
            superView = superView.superview!
            if superView.superview == nil { break }
        }
        
        return superView
    }
    
    /// UI 在螢幕上的位置
    /// - Returns: UI 在螢幕上的位置
    func superFrame() -> CGRect {
        var superFrame: CGRect = self.frame
        var superView = self.superview
        var superViewFrame = self.superview?.frame
        
        guard superView != nil else { return self.frame }
        
        while true {
            superFrame = CGRect(x: superFrame.minX + superViewFrame!.minX,
                                y: superFrame.minY + superViewFrame!.minY,
                                width: superFrame.width,
                                height: superFrame.height)
            
            superView = superView?.superview
            superViewFrame = superView?.frame
            if superView == nil { break }
        }
        
        return superFrame
    }
    
}
