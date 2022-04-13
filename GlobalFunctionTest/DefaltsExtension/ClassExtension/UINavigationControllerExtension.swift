//
//  UINavigationControllerExtension.swift
//  GlobalFunctionTest
//
//  Created by Defalt Lee on 2022/3/20.
//

import Foundation
import UIKit

extension UINavigationController {
    
    // push with completion handler
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    // pop with completion handler
    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
}
