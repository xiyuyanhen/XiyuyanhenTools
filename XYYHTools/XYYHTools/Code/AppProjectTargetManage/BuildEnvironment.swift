//
//  APPBuildEnvironment.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/19.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 编译环境
enum APPBuildEnvironment : String {
    
    /// 开发环境
    case Development = "(测试)"
    
    /// 正式环境
    case Distribution = ""
    
    /// 是否为开发环境
    var isDevelopment : Bool { return (self == APPBuildEnvironment.Development) }
}
