//
//  NSObject+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/11/7.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYJsonHandleProtocol {}

extension NSObject : XYJsonHandleProtocol {
    
    func objectToDirectory() -> NSDictionary {
        
        let properties = Mirror(reflecting: self)
        
        //        dump(properties)
        
        let result = NSMutableDictionary.init()
        for child in properties.children{
            
            result.setObject(child.1, forKey: child.0! as NSCopying)
        }
        
        return result
    }
    
    func setWithDirectory(_ objectDic:NSDictionary) {
        
        for (key,value) in objectDic {
            
            self.setValue(value, forKey: key as! String)
        }
    }

    /**
     *    @description 获取类名字符串
     *
     */
    class func ClassName() -> String {
        
        let classString = "\(self)"//NSStringFromClass(self)
        
        return classString
    }
    
    /**
     *    @description 获取类名字符串
     *
     */
    var className : String {
        
        guard let anyClass = object_getClass(self) else { return "unKnow" }

        let className = "\(anyClass)"//NSStringFromClass(anyClass)
        
        return className
        
//        return "\(type(of: self))" //className
    }
    
    /// 是否显示日志信息(默认不显示) - 方便控制调试信息的操控
    var xyIsShowingLog: Bool { return false }
    
    static func CreateIdByClassAndTime() -> String {
        
        let amplification: Int = 1000000 //精度:纳秒
        let nowDate = Date()
        let nowTimeInterval = TimeInterval(nowDate.timeIntervalSince1970 * Double(amplification))
        let nowtime = TimeInterval(nowTimeInterval - 1483200000000000)
        let microsecond = Int64(nowtime)
        
        let newId = "\(self.ClassName())_\(microsecond)"
        
        return newId
    }
}


