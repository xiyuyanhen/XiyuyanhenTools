//
//  XYLogPrintTarget.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/24.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

enum XYLogPrintTarget : Int {
    case None = 0
    case Console = 1
    case LogFile = 2
    case Network = 3
    
    func name() -> String {
        
        switch self {
        case .None:
            return "不打印"
            
        case .Console:
            return "控制台"
            
        case .LogFile:
            return "沙盒文件"
            
        case .Network:
            return "网络输出"
        }
    }
}
