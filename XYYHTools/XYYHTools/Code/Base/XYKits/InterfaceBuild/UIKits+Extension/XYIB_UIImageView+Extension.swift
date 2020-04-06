//
//  XYIB_UIImageView+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/23.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

@IBDesignable extension UIImageView {
    
    /// 字体颜色
    @IBInspectable var xyIBImage : String? {
        
        get { return nil }
        
        set {
            
            guard let imgName = newValue,
                imgName.isNotEmpty else { return }
            
            let tag : String = APP_CurrentTarget.filter(sts: "", xy: "_KL")
            
            self.setImageByName("\(imgName)\(tag)")
        }
    }
}
