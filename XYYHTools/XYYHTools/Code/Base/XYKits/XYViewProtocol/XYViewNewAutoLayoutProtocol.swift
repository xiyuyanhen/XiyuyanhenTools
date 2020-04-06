//
//  XYViewNewAutoLayoutProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/24.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYNewSettingProtocol {
    
    func initProperty()
    
    func layoutAddViews()
    
    func layoutAllViews()
}

protocol XYViewNewAutoLayoutProtocol : XYNewSettingProtocol {
    
}

extension XYViewNewAutoLayoutProtocol where Self : UIView {
    
    static func NewAutoLayout() -> Self {
        
        let newView = Self.newAutoLayout()
        
        newView.initProperty()
        
        return newView
    }
}

