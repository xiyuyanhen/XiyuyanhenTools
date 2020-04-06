//
//  XYViewNewByNibProtocol.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2019/1/2.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

extension UIView {
    
    static private let XYNibContentViewNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYNibContentView_Key".hashValue)
    var xyNibContentViewOrNil : UIView? {
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYNibContentViewNameKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get{
            
            guard let contentView = objc_getAssociatedObject(self, UIView.XYNibContentViewNameKey!) as? UIView else { return nil }
            
            return contentView
        }
    }
    
    static private let XYFitSizeByNibViewConstraintsNameKey = UnsafeRawPointer.init(bitPattern: "UIView_FitSizeByNibViewConstraints_Key".hashValue)
    
    /// 是否已经修正过约束值
    fileprivate var xyIsFitSizeByNibViewConstraints: Bool {
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYFitSizeByNibViewConstraintsNameKey!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get{
            
            guard let fited = objc_getAssociatedObject(self, UIView.XYFitSizeByNibViewConstraintsNameKey!) as? Bool else { return false }
            
            return fited
        }
    }
}

protocol XYNibLoadViewProtocol {
    
    
}

extension XYNibLoadViewProtocol where Self : UIView {
    
    func loadNibView() -> UIView? {
        
        let nibName : String = self.className
        
        guard let nibArr = Bundle.main.loadNibNamed(nibName, owner: self, options: nil),
            let firstView = nibArr.first as? UIView else {
                
                return nil
        }
        
        return firstView
    }
}

protocol XYViewNewByNibProtocol : XYViewNewAutoLayoutProtocol {
    
    func xyDidAddNibContentView()
}

extension XYViewNewByNibProtocol where Self : UIView {
    
    static func NewByNib() -> Self {
        
        let view = Self.newAutoLayout()
        
        view.xyAddContentViewByNib()
        
        return view
    }
    
    func xyAddContentViewByNib() {
        
        if let xibContentView = self.loadNibView() {
            
            //机型尺寸适配 & constraints归档
            xibContentView.xyFitSizeByNibNewView()
            
            self.xyNibContentViewOrNil = xibContentView
            
            self.addSubview(xibContentView)
            
            xibContentView.autoEdgesPinView(otherView: self)
        }
        
        self.xyDidAddNibContentView()
    }
    
    var superContaonerViewOrNil : UIView? {
        
        guard let firstView = self.subviews.first else { return nil }
        
        return firstView
    }
}

extension UIView {
    
    /**
     *    @description 根据实际设备的屏幕调整约束值
     *
     */
    func xyFitSizeByNibNewView() {
        
        //subviews 遍历
        for subview in self.subviews {
            
            //UIView类 constraint归档
            subview.xyFitSizeByNibNewView()
        }
        
        self.xyFitSizeByNibViewConstraints()
    }
    
    
    private func xyFitSizeByNibViewConstraints() {
        
        // 若没有修正过，才遍历所有子视图，根据屏幕尺寸修正约束值
        guard self.xyIsFitSizeByNibViewConstraints == false else { return }
        
        // 已经修正约束
        self.xyIsFitSizeByNibViewConstraints = true
        
        for constraint in self.constraints {
            
            // 将约束放到对应的可取位置
            self.xySetLayoutConstraints(constraint: constraint)
            
            /// 约束新值
            var newSize : CGFloat = constraint.constant
            
            if self.xyIBNeedFitSizeForNibViewByPad,
                XYDevice.Model() == .iPad {
                
                // 如果需要针对Pad调整
                newSize = XYUIAdjustment.ScalePadByiPhone * newSize
            }
            
            // 根据宽度调整约束值
            newSize = UIW(newSize)

            // 如果新值与原始值不一致，才去更新
            guard newSize != constraint.constant else { continue }
            
            constraint.constant = newSize
        }
        
        self.xyFitSizeByNibUIView()
        
        //具体子类的尺寸适配
        if let label = self as? UILabel {
            
            label.xyFitSizeByNibUILabel()
            
        }else if let button = self as? UIButton {
            
            button.xyFitSizeByNibUIButton()
            
        }else if let textField = self as? UITextField {
            
            textField.xyFitSizeByNibUITextField()
            
        }
    }
    
    /**
     *    @description constraint归档
     *
     */
    private func xySetLayoutConstraints(constraint: NSLayoutConstraint) {
        
        guard let view = constraint.firstItem as? UIView else { return }
        
        switch constraint.firstAttribute {
        case .left, .leading:
            view.xyLayoutConstraints.leading = constraint
            return
            
        case .right, .trailing:
            view.xyLayoutConstraints.trailing = constraint
            return
            
        case .top:
            view.xyLayoutConstraints.top = constraint
            return
            
        case .bottom:
            view.xyLayoutConstraints.bottom = constraint
            return
            
        case .width:
            view.xyLayoutConstraints.width = constraint
            return
            
        case .height:
            view.xyLayoutConstraints.height = constraint
            return
            
        case .centerX:
            view.xyLayoutConstraints.vertical = constraint
            return
            
        case .centerY:
            view.xyLayoutConstraints.horizontal = constraint
            return
            
        case .lastBaseline:
            return
            
        case .firstBaseline:
            return
            
        case .leftMargin:
            return
            
        case .rightMargin:
            return
            
        case .topMargin:
            return
            
        case .bottomMargin:
            return
            
        case .leadingMargin:
            return
            
        case .trailingMargin:
            return
            
        case .centerXWithinMargins:
            return
            
        case .centerYWithinMargins:
            return
            
        case .notAnAttribute:
            return
        @unknown default: return
        }
    }
}

extension NSLayoutConstraint.Attribute {
    
    func name() -> String {
        
        switch self {
            
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default: return "unknow"
        }
    }
}



extension UIView {
    
    fileprivate func xyFitSizeByNibUIView() {
        
        //cornerRadius
        if 0 < self.layer.cornerRadius {
            
            /// 旧大小
            let oldSize: CGFloat = self.layer.cornerRadius
            
            /// 新大小
            var newSize: CGFloat = oldSize
            
            if self.xyIBNeedFitSizeForNibViewByPad,
                XYDevice.Model() == .iPad {
                
                // 如果需要针对Pad调整
                newSize = XYUIAdjustment.ScalePadByiPhone * newSize
            }
            
            newSize = UIW(newSize)
            
            if newSize != oldSize {
                
                self.layer.cornerRadius = newSize
            }
        }
        
    }
}

extension UILabel {
    
    fileprivate func xyFitSizeByNibUILabel() {
        
        if let newFont = self.font.xyNewFontBy(needFitByPad: self.xyIBNeedFitSizeForNibViewByPad) {
            
            self.setFont(newFont)
        }
    }
}

extension UIButton {
    
    fileprivate func xyFitSizeByNibUIButton() {
        
        if let titleLabel = self.titleLabel {
            
            // 字体大小
            titleLabel.xyFitSizeByNibUILabel()
        }
    }
}

extension UITextField {
    
    fileprivate func xyFitSizeByNibUITextField() {
        
        //字体大小
        if let font = self.font {
            
            if let newFont = font.xyNewFontBy(needFitByPad: self.xyIBNeedFitSizeForNibViewByPad) {
                
                self.setFont(newFont)
            }
        }
    }
}

extension UITextView {
    
    fileprivate func xyFitSizeByNibUITextView() {
        
        //字体大小
        if let font = self.font {
            
            if let newFont = font.xyNewFontBy(needFitByPad: self.xyIBNeedFitSizeForNibViewByPad) {
                
                self.font = newFont
            }
        }
    }
}
