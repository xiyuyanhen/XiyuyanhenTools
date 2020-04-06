//
//  Public_View_Tag.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/5/6.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

enum Public_View_TagType : Int {
    
    case Unknow = 0 // 未知
    
    case XYFloatingButton = 1000 // 悬浮按钮
    
    
}

extension Public_View_TagType {
    
    var tag : Int { return self.rawValue }
}

/**
 *    @description UIView Extension By Public_View_Tag_SetTag_Protocol
 *
 */
protocol Public_View_Tag_SetTag_Protocol { }

extension Public_View_Tag_SetTag_Protocol where Self : UIView {
    
    @discardableResult func setTagByPublic(_ type: Public_View_TagType) -> Self {
        
        self.tag = type.tag
        
        return self
    }
    
    var publicTagTypeOrNil : Public_View_TagType? {
        
        guard let type = Public_View_TagType(rawValue: self.tag) else { return .Unknow }
        
        return type
    }
}

extension UIView : Public_View_Tag_SetTag_Protocol { }
