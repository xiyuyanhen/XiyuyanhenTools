//
//  ProcessView.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/7/16.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class ProgressView : UIView {
    
    enum ProgressType {
        case horizontal
        case vertical
    }
    
    class func Create(type:ProgressType, progress:CGFloat, lineColor:UIColor, bgColor:UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)) -> ProgressView {
    
        let progressView = ProgressView.newAutoLayout()
        progressView.backgroundColor = bgColor
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = UIH(4.0)
        progressView.layer.borderWidth = 0.5
        progressView.layer.borderColor = UIColor.FromRGB(0xe5e5e5).cgColor

        progressView.update(process: progress, type: type)
        
        return progressView
    }

    private var animationLineView:UIView?
    private var animationEdgeLC:NSLayoutConstraint? = nil
    private var progressType:ProgressType = .horizontal
    private var process:CGFloat = 0.0
    
    func update(process:CGFloat, type:ProgressType, animationViewColor:UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)) {
        
        self.removeSubviews()
        
        let animationLineView = UIView.newAutoLayout()
        animationLineView.backgroundColor = animationViewColor
        animationLineView.layer.masksToBounds = true
        animationLineView.layer.cornerRadius = UIH(4.0)
        
        self.animationLineView = animationLineView

        self.addSubview(animationLineView)
        
        animationLineView.autoPinView(otherView: self, edges: .leading, .bottom)
        
        self.process = process
        self.progressType = type
        
        let allLength = (type == .horizontal) ? self.bounds.size.width : self.bounds.size.height
        let length = allLength * process
        
        if type == .horizontal {
            
            animationLineView.autoPinEdge(.top, to: .top, of: self)
            self.animationEdgeLC = animationLineView.autoSetDimension(.width, toSize: length)
        }else{
            
            animationLineView.autoPinEdge(.trailing, to: .trailing, of: self)
            self.animationEdgeLC = animationLineView.autoSetDimension(.height, toSize: length)
        }
        
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard self.bounds.size.width > 0 else { return }
        
        let allLength = (self.progressType == .horizontal) ? self.bounds.size.width : self.bounds.size.height
        let length = allLength * process
        
        if let lc = self.animationEdgeLC {
            
            lc.constant = length
        }
    }
    
}

