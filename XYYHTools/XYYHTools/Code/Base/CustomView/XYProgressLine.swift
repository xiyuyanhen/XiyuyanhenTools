//
//  XYProgressLine.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/14.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@IBDesignable class XYProgressLine : UIView {
    
    var animationLineColor:UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)
    
    /// 进度百分比 (0.0 ~ 1.0)
    fileprivate var progressPercent:Float = 0.0
    
    /**
     *    @description 刷新进度
     *
     *    @param    progressPercent    进度(0.0 ~ 1.0)
     *
     */
    func update(progressPercent:Float, animation: Bool = true) {
        
        defer {

            // 监听视图大小变更，实际只一次有效执行
            let _ = self.handleSizeChange
        }

        guard progressPercent != self.progressPercent else {
            
            return
        }
        
        self.progressPercent = progressPercent
        
        self.updateProgress(progressPercent: progressPercent, animation: animation)
    }
    
    fileprivate func updateProgress(progressPercent: Float, animation: Bool = true) {
        
        let viewWidth = self.bounds.size.width
        
        guard 0 < viewWidth,
            let trailingLC = self.progressLine.xyLayoutConstraints.trailing else { return }
        
        let percent = 1.0 - progressPercent
        let width = viewWidth * CGFloat(percent)
        
        guard animation,
            let popAnimation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant) else {
            
            trailingLC.constant = -width
            self.progressLine.updateConstraintsIfNeeded()
                
            return
        }
        
        popAnimation.name = "POPAnimation_XYProgressLine_Animation"
        popAnimation.fromValue = trailingLC.constant
        popAnimation.toValue = -width
        popAnimation.beginTime = CACurrentMediaTime()
        popAnimation.duration = 0.35
        
        popAnimation.completionBlock = { [weak self] (anim, finished) in
            
            self?.progressLine.updateConstraintsIfNeeded()
        }
        
        trailingLC.pop_add(popAnimation, forKey: popAnimation.name)
    }
    
    lazy var progressLine: UIView = {
        
        let view = BaseView.newAutoLayout()
        view.backgroundColor = self.animationLineColor
        
        self.addSubview(view)
        
        view.autoEdgesPinView(otherView: self)
        
        return view
    }()
    
    fileprivate lazy var handleSizeChange: Bool = {
        
        self.rx.observe(CGRect.self, "bounds")
            .takeUntil(self.rx.sentMessage(#selector(self.removeFromSuperview)))
            .subscribe(onNext: { [weak self] (frameOrNil) in
                
                guard let newSize = frameOrNil?.size,
                    let weakSelf = self,
                    weakSelf.cacheSize != newSize else { return }
                
                weakSelf.cacheSize = newSize
                
                weakSelf.updateProgress(progressPercent: weakSelf.progressPercent, animation: false)
                
            }).disposed(by: self.disposeBag)
        
        return true
    }()
    
    /// 记录最近的一次大小
    var cacheSize : CGSize = CGSize.zero
}
