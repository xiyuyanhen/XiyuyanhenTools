//
//  XYView_Function_Node_Protocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/5/6.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

extension UIView : XYView_Function_Node_Protocol { }

protocol XYView_Function_Node_Protocol { }

// MARK: - UIView
extension XYView_Function_Node_Protocol where Self : UIView {
    
    
    
    // MARK: - isUserInteractionEnabled
    /**
     *    @description isUserInteractionEnabled
     *
     *    @param    enable    Bool
     *
     *    @return   Self
     */
    @discardableResult internal func setUserInteraction(_ enable: Bool) -> Self {
        
        self.isUserInteractionEnabled = enable
        
        return self
    }
    
    // MARK: - tag
    @discardableResult internal func setTag(_ tag: Int) -> Self {
        
        self.tag = tag
        
        return self
    }
    
    // MARK: - contentMode
    @discardableResult internal func setContentMode(_ mode: UIView.ContentMode) -> Self {
        
        self.contentMode = mode
        
        return self
    }
    
    // MARK: - alpha
    @discardableResult internal func setAlpha(_ alpha: CGFloat) -> Self {
        
        self.alpha = alpha
        
        return self
    }
    
    // MARK: - isHidden
    @discardableResult internal func setHidden(_ isHidden: Bool) -> Self {
        
        self.isHidden = isHidden
        
        return self
    }
    
    // MARK: - BackgroundColor
    @discardableResult internal func setBackgroundColor(uiColor color: UIColor) -> Self {
        
        self.backgroundColor = color
        
        return self
    }
    
    @discardableResult internal func setBackgroundColor(customColor cColor: XYColor.CustomColor, _ alpha: CGFloat = 1.0) -> Self {
        
        return self.setBackgroundColor(uiColor: XYColor(custom: cColor, alpha: alpha).uicolor)
    }
    
    @discardableResult internal func setBackgroundColor(argb: XYColorARGB) -> Self {
        
        return self.setBackgroundColor(uiColor: XYColor(argb: argb).uicolor)
    }
    
    // MARK: - layer cornerRadius
    @discardableResult internal func setLayerCornerRadius(_ cornerRadius: CGFloat) -> Self {
        
        self.layer.cornerRadius = cornerRadius
        
        self.layer.masksToBounds = true
        
        return self
    }
    
    // MARK: - layer border
    
    @discardableResult internal func setLayerBorder(width: CGFloat, color colorOrNil: UIColor?) -> Self {
        
        self.layer.borderWidth = width
        
        if let color = colorOrNil {
            
            self.layer.borderColor = color.cgColor
        }
    
        return self
    }
    
    @discardableResult internal func setLayerBorder(width: CGFloat, color: XYColor.CustomColor) -> Self {
        
        return self.setLayerBorder(width: width, color: color.uiColor)
    }
    
    
    /**
     *    @description 设置当前显示状态
     *
     *    @param    display    XYDisplay
     *
     *    @return   Self
     */
    @discardableResult internal func setDisplay(display: XYDisplay) -> Self {
        
        let isDisappear : Bool = (display == XYDisplay.Disappear)
        
        // 注意: 此时高度约束值应该为0，此约束用于不显示View，当View显示时，应该是根据其它的约束而得
        if let heightLC = self.xyLayoutConstraints.height {
            
            heightLC.isActive = isDisappear
        }
        
        return self.setHidden(isDisappear)
    }
}

// MARK: - UILabel
extension XYView_Function_Node_Protocol where Self : UILabel {
    
    // MARK: - text
    @discardableResult internal func setText( _ textOrNil: String?) -> Self {
        
        self.text = textOrNil
        
        return self
    }

    // MARK: - Font
    @discardableResult internal func setFont( _ font: UIFont) -> Self {
        
        self.font = font
        
        return self
    }
    
    // MARK: - textColor
    @discardableResult internal func setTextColor(uiColor: UIColor) -> Self {
        
        self.textColor = uiColor
        
        return self
    }
    
    @discardableResult internal func setTextColor(rgb: XYColorRGB) -> Self {
        
        return self.setTextColor(uiColor: XYColor(rgb: rgb).uicolor)
    }
    
    @discardableResult internal func setTextColor(argb: XYColorARGB) -> Self {
        
        return self.setTextColor(uiColor: XYColor(argb: argb).uicolor)
    }
    
    @discardableResult internal func setTextColor(customColor cColor: XYColor.CustomColor, _ alpha: CGFloat = 1.0) -> Self {
        
        return self.setTextColor(uiColor: XYColor(custom: cColor, alpha: alpha).uicolor)
    }
    
    // MARK: - textAlignment
    @discardableResult internal func setTextAlignment( _ textAlignment: NSTextAlignment) -> Self {
        
        self.textAlignment = textAlignment
        
        return self
    }
    
    // MARK: - numberOfLines
    @discardableResult internal func setNumberOfLines( _ numberOfLines: Int) -> Self {
        
        self.numberOfLines = numberOfLines
        
        return self
    }
    
    // MARK: - attributedText
    @discardableResult internal func setAttributedText( _ attributedText: NSAttributedString?) -> Self {
        
        self.attributedText = attributedText
        
        return self
    }
    
    /// 省略号显示位置
    @discardableResult internal func setLineBreakMode( _ mode: NSLineBreakMode) -> Self {
        
        self.lineBreakMode = mode
        
        return self
    }
    
}

// MARK: - UIImageView
extension XYView_Function_Node_Protocol where Self : UITextField {
    
    // MARK: - text
    @discardableResult internal func setText( _ textOrNil: String?) -> Self {
        
        self.text = textOrNil
        
        return self
    }
    
    // MARK: - Font
    @discardableResult internal func setFont( _ font: UIFont) -> Self {
        
        self.font = font
        
        return self
    }
    
    // MARK: - textColor
    @discardableResult internal func setTextColor(uiColor: UIColor) -> Self {
        
        self.textColor = uiColor
        
        return self
    }
    
    @discardableResult internal func setTextColor(customColor cColor: XYColor.CustomColor, _ alpha: CGFloat = 1.0) -> Self {
        
        return self.setTextColor(uiColor: XYColor(custom: cColor, alpha: alpha).uicolor)
    }
    
    // MARK: - textAlignment
    @discardableResult internal func setTextAlignment( _ textAlignment: NSTextAlignment) -> Self {
        
        self.textAlignment = textAlignment
        
        return self
    }
    
    // MARK: - attributedText
    @discardableResult internal func setAttributedText( _ attributedText: NSAttributedString?) -> Self {
        
        self.attributedText = attributedText
        
        return self
    }
}

// MARK: - UIImageView
extension XYView_Function_Node_Protocol where Self : UIImageView {

}

// MARK: - UIControl
extension XYView_Function_Node_Protocol where Self : UIControl {
    
    // MARK: - isEnabled
    @discardableResult internal func setEnable(_ enable: Bool) -> Self {
        
        self.isEnabled = enable
        
        return self
    }
    
    // MARK: - isSelected
    @discardableResult internal func setSelected(_ selected: Bool) -> Self {
        
        self.isSelected = selected
        
        return self
    }
    
    // MARK: - isHighlighted
    @discardableResult internal func setHighlighted(_ highlighted: Bool) -> Self {
        
        self.isHighlighted = highlighted
        
        return self
    }
}

// MARK: - UIControl
extension XYView_Function_Node_Protocol where Self : UIButton {
    
    
    @discardableResult internal func setImage(imageName: String?, for state: UIControl.State) -> Self {
        
        self.setImage(UIImage(xyImgName: imageName), for: state)
        
        return self
    }
}

