//
//  XYBannerViewCell.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/21.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class XYBannerViewCell: BaseCollectionViewCell {
    
    override func initProperty() {
        super.initProperty()
        
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.cellView.addSubview(self.bgImgView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard 0 < self.bounds.size.height,
            let model = self.bannerModelOrNil else { return }
        
        self.bgImgView.setImageFromURL(URLString: model.photoUrlStr)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.bgImgView.autoEdgesPinView(otherView: self.cellView)
    }
    
    var bannerModelOrNil : XYBannerModel?
    func setContent(model : XYBannerModel, mode : XYBannerView.Mode) {
        
        self.bannerModelOrNil = model
        
        self.bgImgView.setImageFromURL(URLString: model.photoUrlStr)
        
        if mode == .Default {
            
            self.bgImgView.layer.masksToBounds = true
        }else{
            
            self.bgImgView.layer.masksToBounds = false
        }
    }
    
    lazy var bgImgView: BaseImageView = {
        
        let imgView = BaseImageView.newAutoLayout()
        imgView.backgroundColor = UIColor.clear
        
        imgView.layer.contentsScale = APPScreen.scale
        imgView.contentMode = .scaleAspectFill
        
        imgView.layer.cornerRadius = UIW(8)
        
        return imgView
    }()
    
    class func ItemSize() -> CGSize {
        
        var width : CGFloat
        
        switch APP_CurrentTarget {
        case .ShiTingShuo, .Xiyou:
            width = ScreenWidth() - UIW(30)
            break
            
        @unknown default: fatalError()
        }
        
        var height = UIW(150)
        
        if XYDevice.Model() == .iPad {
            
            let rate = XYUIAdjustment.ScalePadByiPhone
            
            height = rate * height
        }
        
        return CGSize(width: width, height: height)
    }
}
