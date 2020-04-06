//
//  CaLayer+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/14.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - ExtraData
extension CALayer {
    
    static private let XYCALayerExtraDataNameKey = UnsafeRawPointer.init(bitPattern: "CALayer_XYExtraData_Key".hashValue)
    var xyExtraDataOrNil:Any?{
        
        set{
            
            objc_setAssociatedObject(self, CALayer.XYCALayerExtraDataNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get{
            guard let extraData = objc_getAssociatedObject(self, CALayer.XYCALayerExtraDataNameKey!) else {
                
                return nil
            }
            
            return extraData
        }
    }
}
