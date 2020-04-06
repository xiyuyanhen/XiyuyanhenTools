//
//  XYIB_UIView+Extension.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/12/31.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

@IBDesignable extension UIView {
    
    /// 圆角
    @IBInspectable var xyIBCornerRadius : CGFloat {
        
        get {
            return self.layer.cornerRadius
        }
        
        set {
            
            guard 0 < newValue else { return }
            
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }
    
    /// 边框线条宽度
    @IBInspectable var xyIBBorderWidth : CGFloat {
        
        get {
            return self.layer.borderWidth
        }
        
        set {
            
            guard 0 < newValue else { return }
            
            self.layer.borderWidth = newValue
            self.layer.masksToBounds = true
        }
    }
    
//    /// 边框颜色
//    @IBInspectable var xyIBBorderColor : UIColor? {
//
//        get {
//
//            guard let cgColor = self.layer.borderColor else { return nil }
//
//            return UIColor(cgColor: cgColor)
//        }
//
//        set {
//
//            guard let color = newValue else { return }
//
//            self.layer.borderColor = color.cgColor
//
//            self.layer.masksToBounds = true
//        }
//    }
    
    /// 边框颜色
    @IBInspectable var xyIBBorderColorText : String? {
        
        get { return nil }
        
        set {
            
            if let cColor = APP_CurrentTarget.targetColorBy(newValue) {
                
                self.layer.borderColor = XYColor(custom: cColor).cgcolor
                self.layer.masksToBounds = true
                
                return
            }

            guard let argb = XYColorARGBBy(argbText: newValue) else { return }
        
            self.layer.borderColor = XYColor(argb: argb).cgcolor
            self.layer.masksToBounds = true
        }
    }
    
    /// 背景色
    @IBInspectable var xyIBBackgroundColorText : String? {
        
        get {
            
            guard let bgColor = self.backgroundColor else { return nil }
        
            return bgColor.toXYColor.argbText(include0x: true)
        }
        
        set {
            
            if let cColor = APP_CurrentTarget.targetColorBy(newValue) {

                self.setBackgroundColor(customColor: cColor)
                return
            }
            
            guard let argb = XYColorARGBBy(argbText: newValue) else { return }
            
            self.setBackgroundColor(argb: argb)
        }
    }
}

@IBDesignable extension UIView {
    
    static private let XYFitSizeForNibViewByPadNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYFitSizeForNibViewByPad_Key".hashValue)
    
    /// 是否需要针对Pad设备重新计算值
    fileprivate var xyNeedFitSizeForNibViewByPad: Bool {
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYFitSizeForNibViewByPadNameKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get{
            
            guard let need = objc_getAssociatedObject(self, UIView.XYFitSizeForNibViewByPadNameKey!) as? Bool else { return false }
            
            return need
        }
    }
    
    /// 是否需要针对Pad设备重新计算值
    @IBInspectable var xyIBNeedFitSizeForNibViewByPad : Bool {
        
        get {
        
            return self.xyNeedFitSizeForNibViewByPad
        }
        
        set {
            
            self.xyNeedFitSizeForNibViewByPad = newValue
        }
    }

}

@IBDesignable extension NSLayoutConstraint {

    /// 自动调整底部的安全间距
    @IBInspectable var xyIBSafeAreaBottomByAutoFit : Bool {
        
        get { return false }
        
        set {
            
            guard newValue else { return }
            
            let newHeight = SafeAreaBottomHeight()
            
            guard 0 < newHeight else { return }
            
            self.constant = newHeight
        }
    }
    
    /// 添加以状态栏底部为参考的间距距离
    @IBInspectable var xyAddStatusBarHeightForIB : CGFloat {
        
        get { return self.constant }
        
        set {
            
            self.constant = newValue + XYUIAdjustment.Share().statusBarHeight
        }
    }

}


