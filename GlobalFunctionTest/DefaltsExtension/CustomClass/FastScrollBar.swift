//
//  FastScrollWheel.swift
//  UITest0214
//
//  Created by Defalt Lee on 2022/3/21.
//

import Foundation
import UIKit

class FastScrollBar: UIView {
    
    // ScrollBar 的圖片
    var imageView: UIImageView?
    
    // ScrollBar 的底層
    var baseView: UIView!
    // ScrollBar 的目標
    var scrollView: UIScrollView!
    
    // SafeArea 的的高度
    var safeAreaInset: UIEdgeInsets = UIApplication.shared.windows.first!.safeAreaInsets
    
    // ScrollBar 在螢幕上的活動範圍
    var topPosition: CGFloat!
    var bottomPosition: CGFloat!
    
    // ScrollBar 在 BaseView 上的活動範圍
    var topPositionInBaseView: CGFloat?
    var bottomPositionInBaseView: CGFloat?
    
    // 顯示狀態
    var scrollBarAppearance: Bool = true
    // 是否淡出
    var doFade: Bool = false
    // 淡出計時
    var fadeCountDown: Int = 2
    // 淡出計時器
    var fadeTimer: Timer?
    
    /// 初始化
    /// - Parameters:
    ///   - baseView: 手勢的底層
    ///   - scrollView: 配合的 ScrollView
    ///   - frame: ScrollBar 的 Frame
    ///   - top: ScrollBar移動的頂部
    ///   - bottom: ScrollBar移動的底部
    init(baseView: UIView, scrollView: UIScrollView, frame: CGRect, top: CGFloat, bottom: CGFloat, fade: Bool) {
        super.init(frame: frame)
        self.baseView = baseView
        self.scrollView = scrollView
        self.topPosition = top
        self.bottomPosition = bottom
        self.doFade = fade
        
        // 轉換活動範圍
        self.topPositionInBaseView = topPosition - baseView.superFrame().minY
        self.bottomPositionInBaseView = bottomPosition - baseView.superFrame().minY
        
        setInit()
    }
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /// 初始設定
    func setInit() {
        // 加入拖曳手勢
        let pan = UIPanGestureRecognizer(target: self, action: #selector(scrollBarPanFunction(_:)))
        self.addGestureRecognizer(pan)
        
        // 設置 ScrollView 委任
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        
        // 設置背景顏色
        self.backgroundColor = .lightGray
        
        guard doFade else { return }
        guard fadeTimer == nil else { return }
        
        // 設定淡出計時器
        fadeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fadeCountDownAction), userInfo: nil, repeats: true)
    }
    
    /// 設置圖片
    /// - Parameters:
    ///   - image: ScrollBar 的圖片
    ///   - contentMode: 顯示模式
    func setImage(image: UIImage, contentMode: UIView.ContentMode = .scaleAspectFill) {
        if self.imageView == nil {
            self.imageView = UIImageView(
                frame:CGRect(x: 0,
                             y: 0,
                             width: self.frame.width,
                             height: self.frame.height))
            self.addSubview(imageView!)
        }
        imageView!.contentMode = contentMode
        imageView!.image = image
    }
    
    /// 顯示 ScrollBar
    func showFastScrollBar() {
        guard doFade else { return }
        self.alpha = 1
        scrollBarAppearance = true
        fadeCountDown = 2
    }
    
    /// 淡出 ScrollBar
    func fadeFastScrollBar() {
        UIView.animate(withDuration: 1) {
            self.alpha = 0
        } completion: { [self] bool in
            scrollBarAppearance = false
        }
    }
    
    /// 滾動 ScrollView 至指定位置
    /// - Parameter percent: %
    func scrollScrollViewToPercent(_ percent: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: (scrollView.contentSize.height - scrollView.frame.height) * percent),
                                    animated: false)
    }
    
    /// 滾動 ScrollBar 至指定位置
    /// - Parameter percent: %
    func moveScrollBarToPercent(_ percent: CGFloat) {
        self.frame = CGRect(x: self.frame.minX,
                            y: (bottomPosition - topPosition - self.frame.height) * percent + topPositionInBaseView!,
                            width: self.frame.width,
                            height: self.frame.height)
    }
    
    /// ScrollBar 被拖曳
    @objc func scrollBarPanFunction(_ recognizer:UIPanGestureRecognizer) {
        guard let scrollBar = recognizer.view else { print("recognizer.view is nil"); return }
        
        showFastScrollBar()
        
        // 手指在BaseView點擊的位置
        let panY = recognizer.location(in: baseView).y
        
        // ScrollView 及 ScrollBar 應該顯示的百分比
        var percent: CGFloat = 0
        
        /// 移至 0%
        func moveToTop() {
            UIView.animate(withDuration: 0.1) { [self] in
                scrollBar.frame = CGRect(x: scrollBar.frame.minX,
                                         y: topPositionInBaseView!,
                                         width: scrollBar.frame.width,
                                         height: scrollBar.frame.height)
                percent = 0
                scrollScrollViewToPercent(percent)
            }
        }
        
        /// 移至 100%
        func moveToBottom() {
            UIView.animate(withDuration: 0.1) { [self] in
                scrollBar.frame = CGRect(x: scrollBar.frame.minX,
                                         y: bottomPositionInBaseView! - scrollBar.frame.height,
                                         width: scrollBar.frame.width,
                                         height: scrollBar.frame.height)
                percent = 1
                scrollScrollViewToPercent(percent)
            }
        }
        
        // 手指拖曳超過手勢偵測範圍，就將顯示百分比移至極值
        guard panY - (scrollBar.frame.height / 2) >= topPositionInBaseView! else { moveToTop(); return }
        guard panY + (scrollBar.frame.height / 2) <= bottomPositionInBaseView! else { moveToBottom(); return }
        
        // 設置顯示百分比
        scrollBar.frame = CGRect(x: scrollBar.frame.minX,
                                 y: panY - (scrollBar.frame.height / 2),
                                 width: scrollBar.frame.width,
                                 height: scrollBar.frame.height)
        
        percent = (scrollBar.superFrame().minY - topPosition) / (bottomPosition - topPosition - scrollBar.frame.height)
        
        scrollScrollViewToPercent(percent)
    }
    
    /// 淡出計時器 action
    @objc func fadeCountDownAction() {
        guard fadeCountDown <= 0 else { fadeCountDown -= 1; return }
        guard scrollBarAppearance else { return }
        
        fadeFastScrollBar()
    }
    
}

extension FastScrollBar: UIScrollViewDelegate {
    
    // ScrollView 被滾動
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        showFastScrollBar()
        let percent = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height)
        moveScrollBarToPercent(percent)
    }
    
}
