//
//  XYMenuItem.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/29.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYMenuItem: UIMenuItem {
    
    let modelId: String
    
    override init(title: String, action: Selector) {
        
        self.modelId = String.CreateIdByTime(className: "XYMenuItem")
        
        super.init(title: title, action: action)
    }
}
