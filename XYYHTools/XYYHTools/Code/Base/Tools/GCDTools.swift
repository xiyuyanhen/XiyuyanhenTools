//
//  GCDTools.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/8/17.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

enum XYDispatchQueueType: XYEnumTypeProtocol {
    
    case Main
    case Public
    case After
    case Custom(String)
    
    static var QueueLabelHeader: String { return "EStudy.Dispatch" }
    
    var queueLabel: String {
        
        let header: String = XYDispatchQueueType.QueueLabelHeader
        
        switch self {
        case .Main: return "\(header).Main"
        case .Public: return "\(header).Public"
        case .After: return "\(header).After"
        case .Custom(let label): return label
        }
    }
    
    var queue: DispatchQueue {
        
        switch self {
            
        case .Main: return DispatchQueue.main
            
        default: return DispatchQueue(label: self.queueLabel)
        }
    }
}

extension XYDispatchQueueType {
    
    typealias HandleBlock = ()->Void
    
    @discardableResult func after(time: TimeInterval, block:@escaping HandleBlock) -> DispatchWorkItem {
        
        let workItem = DispatchWorkItem(block: block)
        
        self.queue.asyncAfter(deadline: DispatchTime.now() + time, execute: workItem)
        
        return workItem
    }
    
    /**
     *    @description 异步执行
     *
     */
    func xyAsync(_ block:@escaping HandleBlock) {
    
        self.queue.async {
            
            block()
        }
    }
}

//struct XYDispatch {
//
//    @discardableResult static func After(isMainThread:Bool = false, time:TimeInterval, block:@escaping XYDispatchQueueType.HandleBlock) -> DispatchWorkItem {
//
//        let queueType: XYDispatchQueueType = isMainThread.xyReturn(XYDispatchQueueType.Main, XYDispatchQueueType.Public)
//
//        return queueType.after(time: time, block: block)
//    }
//
//    /**
//     *    @description 异步执行
//     *
//     */
//    static func Async(isMainThread:Bool = false, block:@escaping XYDispatchQueueType.HandleBlock) {
//
//        let queueType: XYDispatchQueueType = isMainThread.xyReturn(XYDispatchQueueType.Main, XYDispatchQueueType.Public)
//
//        queueType.xyAsync(block)
//    }
//}


