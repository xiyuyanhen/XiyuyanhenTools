//
//  XYIB_UILabel+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/23.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

@IBDesignable extension UILabel {
    
    /// 字体颜色
    @IBInspectable var xyIBTextColorText : String? {
        
        get {
            
            return self.textColor.toXYColor.argbText()
        }
        
        set {
            
            if let cColor = APP_CurrentTarget.targetColorBy(newValue) {
                
                self.setTextColor(customColor: cColor)
                
                return
            }
            
            guard let argb = XYColorARGBBy(argbText: newValue) else { return }
            
            self.setTextColor(uiColor: XYColor(argb: argb).uicolor)
        }
    }
}
