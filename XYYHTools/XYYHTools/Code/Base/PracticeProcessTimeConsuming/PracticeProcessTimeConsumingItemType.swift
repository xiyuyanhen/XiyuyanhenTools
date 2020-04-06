//
//  PracticeProcessTimeConsumingItemType.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/1.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

enum PracticeProcessTimeConsumingState : Int, XYEnumTypeAllCaseProtocol {
    case Ready
    case Buffering
    case Running
    case Suspend
    case Stop
}

extension PracticeProcessTimeConsumingState {
    
    /// 是否为暂停或者停止状态
    var isSuspendOrStop: Bool {
        
        switch self {
        case .Suspend, .Stop: return true
        default: return false
        }
    }
}

protocol PracticeProcessTimeConsumingItemProtocol : XYItemSearch_Protocol, ModelProtocol_Array {
    
    var itemType: PracticeProcessTimeConsumingItemType { get }
    
    var flagText: String { get }
}

extension PracticeProcessTimeConsumingItemProtocol {
    
}

enum PracticeProcessTimeConsumingItemType: String, ModelProtocol_Array, XYEnumTypeAllCaseProtocol {
    
    case Timing   = "Timing" // 定时
    case Audio   = "Audio" // 音频
    /// 视频
    case Video   = "Video"
    
    //是否为允许的数据类型
    static func IsAllowType(model: PracticeProcessTimeConsumingItemProtocol, typeArr: PracticeProcessTimeConsumingItemType.ModelArray = PracticeProcessTimeConsumingItemType.AllCaseArr) -> Bool {
        
        guard typeArr.isNotEmpty else { return true }
        
        for type in typeArr {
            
            guard model.itemType == type else { continue }
            
            return true
        }
        
        return false
    }
}
