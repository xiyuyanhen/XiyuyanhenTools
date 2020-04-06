//
//  UIEdgeInsets+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2020/1/3.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - UIEdgeInsetsMake
func UIEdgeInsetsMake(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets{
    
    return UIEdgeInsets(top: top,
                left: left,
                bottom: bottom,
                right: right)
}

/**
 *    @description (top = left = bottom = right)
 *
 *    @param    <#参数#>    <#参数说明#>
 *
 *    @return   <#返回说明#>
 */
func UIEdgeInsetsMakeEqual(_ constant: CGFloat) -> UIEdgeInsets{
    
    return UIEdgeInsets(top: constant,
                left: constant,
                bottom: constant,
                right: constant)
}

extension UIEdgeInsets {
    
    init(adjustBy top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
    
        self.init(top: UIW(top), left: UIW(left), bottom: UIW(bottom), right: UIW(right))
    }
    
    init(equalConstant constant: CGFloat) {
    
        self.init(top: constant, left: constant, bottom: constant, right: constant)
    }
    
    init(adjustAndEqualBy constant: CGFloat) {
    
        let newValue: CGFloat = UIW(constant)
        
        self.init(equalConstant: newValue)
    }
    
}
