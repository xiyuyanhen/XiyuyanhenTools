//
//  CGSize+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2020/1/3.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation

extension CGSize {
    
    /// 宽高相等且根据设备动态调整大小
    init(squareByAdjust: CGFloat) {
        
        self.init(square: UIW(squareByAdjust))
    }
    
    /// 宽高相等
    init(square: CGFloat) {
        
        self.init(width: square, height: square)
    }
    
    /// 根据设备动态调整指定的宽高值
    init(adjustBy width: CGFloat, _ height: CGFloat) {
        
        self.init(width: UIW(width), height: UIW(height))
    }
    
    var isNotEmpty: Bool {
        
        return (0 < self.width) && (0 < self.height)
    }
}
