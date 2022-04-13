//
//  UIViewControllerExtension.swift
//  GlobalFunctionTest
//
//  Created by Defalt Lee on 2022/3/10.
//

import Foundation
import UIKit

let screenFrame = UIScreen.main.bounds

extension UIViewController{
    
    /// 吐司訊息
    /// - Parameters:
    ///   - string: 訊息內容
    ///   - font: 字型
    ///   - duration: 持續時間
    func showToastMessage(_ string: String, font: UIFont = UIFont.systemFont(ofSize: 17), duration: CGFloat = 3) {
        // 移除畫面上舊有的吐司訊息
        for subView in view.subviews {
            if subView.layer.name == "TOAST" {
                subView.removeFromSuperview()
                break
            }
        }
        
        // 單行文字最寬寬度
        let maxWidthOfText = screenFrame.width - 100
        // 文字的尺寸
        let sizeOfText = sizeOfString(string, withFont: font)
        // 文字的行數
        let linesOfText = ceil(Double(sizeOfText.width / maxWidthOfText))   // ceil -> 無條件進位
        // 訊息匡的寬度
        let toastWidth = (sizeOfText.width > maxWidthOfText) ? screenFrame.width - 80 : sizeOfText.width + 20
        
        let toastView = UIView(frame: CGRect(x: (screenFrame.width - toastWidth) / 2,
                                             y: view.frame.height - (30 + ((sizeOfText.height + 1) * linesOfText + 20)),
                                             width: toastWidth,
                                             height: (sizeOfText.height + 1) * linesOfText + 20))
        
        let toastLabel = UILabel(frame: CGRect(x: 10,
                                               y: 10,
                                               width: toastWidth - 20,
                                               height: (sizeOfText.height + 1) * linesOfText))
        
        toastView.layer.name = "TOAST"
        toastView.backgroundColor = .darkGray
        toastView.layer.cornerRadius = 5
        
        toastLabel.font = font
        toastLabel.textColor = .white
        toastLabel.backgroundColor = .clear
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = (linesOfText > 1) ? NSTextAlignment.left : NSTextAlignment.center
        toastLabel.text = string
        
        toastView.addSubview(toastLabel)
        view.addSubview(toastView)
        
        // Fade
        UIView.animate(withDuration: duration) {
            toastView.alpha = 0
        } completion: { bool in
            toastView.removeFromSuperview()
        }
    }
    
    /// 提示窗
    /// - Parameters:
    ///   - title: 標題
    ///   - message: 訊息內容
    ///   - confirmTitle: 確認按鈕標題
    ///   - cancelTitle: 取消按鈕標題
    ///   - handler: 確認事件
    ///   - cancel: 取消事件
    func showAlert(_ title: String, message: String, confirmTitle: String = "OK", cancelTitle: String = "Cancel", handler: (()->Void)?, cancel: (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: confirmTitle, style: .default) { action in
            guard handler != nil else { return }
            handler!()
        }
        
        var cancelAction: UIAlertAction!
        if cancel == nil {
            cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        } else {
            cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
                guard cancel != nil else { return }
                cancel!()
            }
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    /// 推進到下一個畫面
    /// - Parameters:
    ///   - viewController: 下一個畫面
    ///   - animation: 動畫
    ///   - completion: 完成之後做的事
    ///   - clearNavigationStack: 是否清除堆疊的畫面
    func push(_ viewController: UIViewController, animation: Bool, clearNavigationStack: Bool = false, completion: (()->Void)? = nil) {
        guard self.navigationController != nil else { return }
        
        guard clearNavigationStack else {
            if completion == nil {
                self.navigationController?.pushViewController(viewController, animated: animation)
            } else {
                self.navigationController?.pushViewController(viewController, animated: animation, completion: completion!)
            }
            return
        }
        
        if completion == nil {
            self.navigationController?.pushViewController(viewController, animated: animation, completion: {
                clearViewControllers(viewController: viewController)
            })
        } else {
            self.navigationController?.pushViewController(viewController, animated: animation) {
                clearViewControllers(viewController: viewController)
                completion!()
            }
        }
    }
    
    /// 返回到上一個畫面
    /// - Parameters:
    ///   - animation: 動畫
    ///   - completion: 完成之後要做的事
    func pop(animation: Bool, completion: (()->Void)? = nil) {
        guard self.navigationController != nil else { return }
        
        if completion == nil {
            self.navigationController?.popViewController(animated: animation)
        } else {
            self.navigationController?.popViewController(animated: animation, completion: completion!)
        }
    }
    
}
