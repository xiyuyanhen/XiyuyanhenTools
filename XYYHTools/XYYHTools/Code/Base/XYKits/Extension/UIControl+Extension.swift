//
//  UIControl+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/4.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

//增大UIButton响应范围
extension UIControl{
    
    // MARK: - 触发间隔属性名
//    private static let ResponseIntervalTimeNameKey = UnsafeRawPointer.init(bitPattern: "ResponseIntervalTime_NameKey".hashValue)
    
    /**
     *    @description 触发间隔
     *
     */
//    var responseIntervalTime : TimeInterval? {
//
//        set{
//            objc_setAssociatedObject(self, UIControl.ResponseIntervalTimeNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//
//        get{
//            return objc_getAssociatedObject(self, UIControl.ResponseIntervalTimeNameKey!) as? TimeInterval
//        }
//    }
    
    // MARK: - 触发允许属性名
//    private static let ResponseIntervalEnableNameKey = UnsafeRawPointer.init(bitPattern: "ResponseIntervalEnable_NameKey".hashValue)
    
    /**
     *    @description 触发允许属性
     *
     */
//    var responseIntervalEnable : Bool? {
//
//        set{
//            objc_setAssociatedObject(self, UIControl.ResponseIntervalEnableNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//        }
//
//        get{
//            return objc_getAssociatedObject(self, UIControl.ResponseIntervalEnableNameKey!) as? Bool
//        }
//    }
    
    // MARK: - 触发范围扩展属性
    private struct EnlargeEdge_RuntimeKey {
        
        static let EnLargeEdge_topNameKey = UnsafeRawPointer.init(bitPattern: "EnLargeEdge_topNameKey".hashValue)
        static let EnLargeEdge_LeadingNameKey = UnsafeRawPointer.init(bitPattern: "EnLargeEdge_LeadingNameKey".hashValue)
        static let EnLargeEdge_TrailingNameKey = UnsafeRawPointer.init(bitPattern: "EnLargeEdge_TrailingNameKey".hashValue)
        static let EnLargeEdge_bottomNameKey = UnsafeRawPointer.init(bitPattern: "EnLargeEdge_bottomNameKey".hashValue)
    }
    
    private var enLargeEdgeTop:CGFloat?{
        set{
            objc_setAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_topNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_topNameKey!) as? CGFloat
        }
    }
    
    private var enLargeEdgeLeading:CGFloat?{
        set{
            objc_setAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_LeadingNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_LeadingNameKey!) as? CGFloat
        }
    }
    
    private var enLargeEdgeTrailing:CGFloat?{
        set{
            objc_setAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_TrailingNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_TrailingNameKey!) as? CGFloat
        }
    }
    
    private var enLargeEdgeBottom:CGFloat?{
        set{
            objc_setAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_bottomNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, UIControl.EnlargeEdge_RuntimeKey.EnLargeEdge_bottomNameKey!) as? CGFloat
        }
    }
    
    /**
     *    @description 设置增大响应范围的值
     *
     *    @param    touchEdgeInsets    top/left/bottom/right各方向的增量
     *
     */
    func enlargeEdge(_ touchEdgeInsets:UIEdgeInsets) {
        
        if 0 < touchEdgeInsets.top {
            
            self.enLargeEdgeTop = touchEdgeInsets.top
        }
        
        if 0 < touchEdgeInsets.left {
            
            self.enLargeEdgeLeading  = touchEdgeInsets.left
        }
        
        if 0 < touchEdgeInsets.right {
            
            self.enLargeEdgeTrailing  = touchEdgeInsets.right
        }
        
        if 0 < touchEdgeInsets.bottom {
            
            self.enLargeEdgeBottom  = touchEdgeInsets.bottom
        }
    }
    
    /**
     *    @description 获取控件的响应范围
     *
     *    @return   控件的响应范围
     */
    private func enLargedRect() -> CGRect {
        
        var top:CGFloat = 0
        if let edgeTop = self.enLargeEdgeTop {
            
            top = edgeTop
        }
        
        var leading:CGFloat = 0
        if let edgeLeading = self.enLargeEdgeLeading {
            
            leading = edgeLeading
        }
        
        var bottom:CGFloat = 0
        if let edgebottom = self.enLargeEdgeBottom {
            
            bottom = edgebottom
        }
        
        var trailing:CGFloat = 0
        if let edgeTrailing = self.enLargeEdgeTrailing {
            
            trailing = edgeTrailing
        }
        
        let x = self.bounds.origin.x - leading
        let y = self.bounds.origin.y - top
        let width  = self.bounds.size.width + leading + trailing
        let height = self.bounds.size.height + top + bottom
        
        return CGRect(x: x, y: y, width: width, height: height)
        
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let rect = self.enLargedRect()
        
        if(self.bounds.equalTo(rect)){
            
            return super.hitTest(point, with: event)
            
        }else if rect.contains(point) {
            
            return self
        }
        
        return nil
    }
}
