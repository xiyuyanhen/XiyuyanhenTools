//
//  XYTelephony.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/10/29.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

/// 电话相关的方法

import Foundation
import CoreTelephony

/// 是否正在接听电话
var IsCalling: Bool {
    
    let center = CTCallCenter()
    
    guard let currentCalls = center.currentCalls else { return false }
    
    for call in currentCalls {
        
        let state: String = call.callState
        
//        XYLog.LogNoteBlock { () -> String? in
//            
//            return "call id:\(call.callID) state:\(state)"
//        }
        
        guard (state == CTCallStateIncoming) || (state == CTCallStateConnected) else { continue }
        
        return true
    }
    
    return false
}
