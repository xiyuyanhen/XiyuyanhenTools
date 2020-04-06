//
//  UIButton+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/4.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension UIButton{
    
    func setBackgroundColor(_ color:UIColor, _ state:UIControl.State){
        
        self.setBackgroundImage(UIImage.ImageWithColor(color), for: state)
    }
    
//    override func xyLayoutSubviews() {
//        super.xyLayoutSubviews()
//        self.layoutSubviews()
//

//    }

//    open override func layoutSubviews() {
//        super.layoutSubviews()
//

//    }
    
}
