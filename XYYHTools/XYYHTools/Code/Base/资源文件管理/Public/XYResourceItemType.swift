//
//  XYResourceItemType.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/3.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 资源单元类型
enum XYResourceType: String, ModelProtocol_Array, XYEnumTypeAllCaseProtocol {
    
    /// 音频类型
    case Audio    = "音频"
    
    /// 视频类型
    case Video   = "视频"
    
    /// 图片类型
    case Picture = "图片"
    
    /// 其它
    case Other = "其它"
    
    var shortFlag : String {
        
        switch self {
        case .Audio, .Video: return "AF"
        case .Picture: return "IMG"
        case .Other: return ""
        }
    }
}
