//
//  GlobalFunctions.swift
//  GlobalFunctionTest
//
//  Created by Defalt Lee on 2022/3/10.
//

import Foundation
import UIKit

/// 字串的尺寸
/// - Parameters:
///   - string: 字串
///   - font: 字型
/// - Returns: 字串的尺寸
func sizeOfString(_ string: String, withFont font:UIFont) -> CGSize {
    let textSize = NSString(string: string).size(withAttributes: [.font: font])
    return textSize
}

/// 清除畫面堆疊
/// - Parameter viewController: 最上層的畫面 (通常是 push 的目的地)
func clearViewControllers(viewController: UIViewController) {
    guard viewController.navigationController?.viewControllers != nil else { return }
    
    var vcs = viewController.navigationController!.viewControllers
    for _ in 0 ..< vcs.count - 1 { vcs.remove(at: 0) }
    DispatchQueue.main.async {
        viewController.navigationController!.viewControllers = vcs
    }
}
