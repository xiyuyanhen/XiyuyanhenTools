//
//  XYLogType.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/24.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

enum XYLogType : String {
    
    case Function   = "函数方法"
    case Brief      = "简要"
    case Note       = "注"
    case Debug     = "普通"
    case Request   = "网络请求"
    case Warnning   = "警告"
    case Error      = "错误"
    
    var flag : String {
        
        switch self {
            
        case .Error:
            return "[E]"
            
        case .Warnning:
            return "[W]"
            
        case .Request:
            return "[R]"
            
        case .Debug:
            return "[D]"
            
        case .Note:
            return "[N]"
        
        case .Brief:
            return ""
            
        case .Function:
            return "[F]"
        }
    }
    
    var emojiHexOrNil: UInt32? {
        
        switch self {
            
        case .Error:
            return 0xe219
            
        case .Warnning:
            return 0xe252
            
        case .Request:
            return 0xe21a
            
        case .Debug:
            return nil
            
        case .Note:
            return nil
        
        case .Brief:
            return nil
            
        case .Function:
            return nil
        }
    }
    
    var emojiFlag: String {
        
        guard let emojiHex = self.emojiHexOrNil,
            let utf = UnicodeScalar(emojiHex) else {
            
            return ""
        }
        
        //使用Uint32的数值，生成一个UTF8的字符
        let c = Character(utf)
        
        return "\(String(c)) "
    }
    
    var level : UInt {
        
        switch self {
            
        case .Error:
            return 50
        
        case .Warnning:
            return 40
            
        case .Request:
            return 30
            
        case .Debug:
            return 20
            
        case .Note:
            return 12
            
        case .Brief:
            return 11
            
        case .Function:
            return 10
        }
    }
}
