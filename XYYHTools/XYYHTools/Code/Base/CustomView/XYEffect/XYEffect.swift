//
//  XYEffect.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/14.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

struct XYEffect {
    
    static func CreateBlurEffect(style : UIBlurEffect.Style = .light) -> UIVisualEffectView {
        
        //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: style)
        
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        return blurView
    }
    
    static func ShowImgViewEffect(showedView showedViewOrNil: UIView? = ProgressHudView, imgUrl urlOrNil : URL?, img imgOrNil : UIImage?) -> XYResult<UIVisualEffectView, XYError> {
        
        guard let showedView = showedViewOrNil else {
            
            return XYResult.Error( XYErrorCustomType.NotCreateView.error() )
        }
        
        let showImg : UIImage
        
        if let img = imgOrNil {
            
            showImg = img
        }else if let imgUrl = urlOrNil,
            imgUrl.absoluteString.isNotEmpty,
            let imgData = try? Data(contentsOf: imgUrl, options: Data.ReadingOptions.dataReadingMapped),
            let img = UIImage(data: imgData) {
            
            showImg = img
            
        }else {
            
            return XYResult.Error( XYErrorCustomType.NotCreateView.error() )
        }

        //create
        let imgView = BaseImageView.newAutoLayout()
        imgView.setContentMode(.scaleAspectFit)
        imgView.image = showImg
        
        let effectView = self.CreateBlurEffect()
        
        effectView.addSubview(imgView)
        
        imgView.autoAlignAxis(.horizontal, toSameAxisOf: effectView)
        imgView.autoPinView(otherView: effectView, edges: .leading, .trailing)
        
        
        
        //show
        showedView.addSubview(effectView)
        
        effectView.autoEdgesPinView(otherView: showedView)
        
        
        
        return XYResult.Success(effectView)
    }

}
