//
//  UILabel+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/11/29.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

extension UILabel {
    
    /**
     *    @description 拷贝当前文本到系统剪贴板
     *
     */
    @objc func xy_CopyText() -> Bool {
        
        guard let willCopyText = self.text else { return false }
        
        willCopyText.copyToPasteboard()
        
        return true
    }
}

extension UILabel {
    
    /**
     *    @description 添加长按拷贝文本到系统剪贴板的功能
     *
     */
    func xy_AddCopyActionByLongPressGR() {
        
        self.xyCanBecomeFirstResponder = true
        
        self.isUserInteractionEnabled = true
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.xy_HandleCopyMenuItemsByLongPressGR))
        
        self.addGestureRecognizer(longPressGR)
    }
    
    @objc fileprivate func xy_HandleCopyMenuItemsByLongPressGR() {
        
        // 让其成为响应者
        self.becomeFirstResponder()
        
        // 拿出菜单控制器单例
        let menu = UIMenuController.shared
        
        // 创建一个复制的item
        let copy = XYMenuItem(title: "复制", action: #selector(self.xy_CopyText))
        
//        let select = UIMenuItem(title: "选择", action: #selector(self.select(_:)))
        
        // 将复制的item交给菜单控制器（菜单控制器其实可以接受多个操作）
        menu.menuItems = [copy]
        
        // 设置菜单控制器的点击区域为这个控件的bounds
        menu.setTargetRect(self.bounds, in: self)
        
        // 显示菜单控制器，默认是不可见状态
        menu.setMenuVisible(true, animated: true)
    }
    
//    open override func select(_ sender: Any?) {
//
//        XYLog.LogFunction()
//    }
    
    // 重写此方法，来控制 UIMenuItem 的显示和隐藏：
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        /*
         以下是系统默认的 UIMenuItem 所对应的 action：
         cut: // 剪切
         copy: // 拷贝
         select: // 选择
         selectAll: // 全选
         paste: // 粘贴
         delete: // 删除
         _promptForReplace: // Replace...
         _transliterateChinese: // 简<=>繁
         _showTextStyleOptions: // B/<u>U</u>
         _define: // Define
         _addShortcut: // Learn...
         _accessibilitySpeak: // Speak
         _accessibilitySpeakLanguageSelection: // Speak...
         _accessibilityPauseSpeaking: // Pause
         _share: // 共享...
         makeTextWritingDirectionRightToLeft: // 往右缩进
         makeTextWritingDirectionLeftToRight: // 往左缩进
         */
        
        guard let menuItems = UIMenuController.shared.menuItems else { return false }
        
        for item in menuItems {
            
            guard item.action == action else { continue }
            
            return true
        }
        
        return false
    }
    
}

// MARK: - 添加额外的xyCanBecomeFirstResponder参数
extension UILabel {

    fileprivate static let XYLabelCanBecomeFirstResponderNameKey = UnsafeRawPointer.init(bitPattern: "UILabel_XYLabelCanBecomeFirstResponderName_Key".hashValue)!
    fileprivate var xyCanBecomeFirstResponder:Bool{
        set{
            objc_setAssociatedObject(self, UILabel.XYLabelCanBecomeFirstResponderNameKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            if let bool = objc_getAssociatedObject(self, UILabel.XYLabelCanBecomeFirstResponderNameKey) as? Bool {
                
                return bool
            }
            
            return false
        }
    }
    
    /// 根据新增参数xyCanBecomeFirstResponder重写canBecomeFirstResponder方法
    open override var canBecomeFirstResponder: Bool {
        
        return self.xyCanBecomeFirstResponder
    }
}
