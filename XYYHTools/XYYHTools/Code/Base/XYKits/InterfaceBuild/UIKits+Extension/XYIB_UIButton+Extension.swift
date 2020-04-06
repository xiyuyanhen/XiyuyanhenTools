//
//  XYIB_UIButton+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/23.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

@IBDesignable extension UIButton {
    
    /// 字体颜色
    @IBInspectable var xyIBTitleTextColorText : String? {
        
        get {
            
            return nil
        }
        
        set {
            
            if let cColor = APP_CurrentTarget.targetColorBy(newValue) {
                
                self.setTitleColor(XYColor(custom: cColor).uicolor, for: .normal)
                
                return
            }
            
            guard let argb = XYColorARGBBy(argbText: newValue) else { return }
            
            self.setTitleColor(XYColor(argb: argb).uicolor, for: .normal)
        }
    }
}
