//
//  BaseAlertProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/1/31.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseAlertProtocol: UIView {
    
    var bgViewOrNil : UIView? { set get }
    
    var disAppearBlockOrNil :DisAppearBlock? { set get }
    
    func disAppearCompletion()
}

extension BaseAlertProtocol {
    
    typealias DisAppearBlock = (_ alertView: UIView) -> Void
    
    func setDisAppearBlock(block:@escaping DisAppearBlock){
        
        self.disAppearBlockOrNil = block
    }
    
    var defaultBgBtn : UIButton {
        
        let bgBtn = UIButton.newAutoLayout()
        bgBtn.backgroundColor = UIColor.FromRGB(0x000000)
        bgBtn.alpha = 0.5
        
        bgBtn.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] () in
                
                self?.disAppear()
                
            }).disposed(by: self.disposeBag)
        
        return bgBtn
    }
    
    func show(supView:UIView){
        
        let showBgView : UIView
        
        if let bgView = self.bgViewOrNil {
            
            showBgView = bgView
        }else {
            
            let bgView = self.defaultBgBtn
            
            showBgView = bgView
            self.bgViewOrNil = bgView
        }
        
        supView.addSubview(showBgView)
        
        showBgView.autoEdgesPinView(otherView: supView)
        
        supView.addSubview(self)
        
        self.autoAlignAxis(.horizontal, toSameAxisOf: supView)
        self.autoAlignAxis(.vertical, toSameAxisOf: supView)
    }
    
    func disAppear() {
        
        if let bgView = self.bgViewOrNil,
            bgView.superview != nil {
            
            bgView.removeFromSuperview()
        }
        
        guard self.superview != nil else { return }
        
        self.removeFromSuperview()
        
        self.disAppearCompletion()
        
        guard let disAppearBlock = self.disAppearBlockOrNil else { return }
        
        disAppearBlock(self)
    }
    
    //移除后调用的方法，用来自定义处理视图移除后的操作
    func disAppearCompletion() {
        
        
    }
    
}
