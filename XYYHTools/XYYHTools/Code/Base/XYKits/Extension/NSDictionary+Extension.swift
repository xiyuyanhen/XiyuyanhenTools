//
//  NSDictionary+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/8/29.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    func objectFromRequestData(forKey aKey: String) -> String {
        
        let value = self.object(forKey: aKey)
        
        //是否为nil
        guard let valueNotNil = value else {
            return ""
        }
        
        //是否为String 对象
        if type(of: valueNotNil) == String.self {
            return valueNotNil as! String
        }
        
        let stringFromNumber = "\(String(describing: valueNotNil))"
        
        guard stringFromNumber != "<null>" else {
            
            return ""
        }
        
        return stringFromNumber
    }
    
    //判断是否是数字
    func isPurnFloat(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Float = 0
        
        return scan.scanFloat(&val) && scan.isAtEnd
        
    }
    
    //判断是否是整数
    func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
}

extension NSDictionary {
    
    /**
    *    @description 根据Key获取数据
    *
    *    @param    forKey    数据索引
    *
    *    @return   数据
    */
    func xyObjectValue(_ forKey: String) -> Any? {
        
        guard let value = self.object(forKey: forKey) else { return nil }
        
        return value
    }
    
    /**
     *    @description 获取相应类型的数据
     *
     *    @param    E    数据类型
     *
     *    @param    forKey    数据索引
     *
     *    @return   E类型的数据
     */
    func xyObject<E>(_ forKey: String) -> E? {
        
        guard let value = self.xyObjectValue(forKey) as? E else { return nil }
        
        return value
    }
    
    /**
    *    @description 获取相应类型的数据
    *
    *    @param    E    数据类型
    *
    *    @param    forKey    数据索引
    *
    *    @param    defaultValue    默认值
    *
    *    @return   E类型的数据
    */
    func xyObject<E>(_ forKey: String, defaultValue: E) -> E {
        
        guard let value: E = self.xyObject(forKey) else { return defaultValue }
        
        return value
    }
}

extension NSDictionary {
    
    /**
     *    @description 是否包含Key值
     *
     *    @param    forKey    Key值
     *
     *    @return   Bool
     */
    func xyContainKey(_ forKey: String) -> Bool {
        
        guard self.xyObjectValue(forKey) != nil else { return false }
        
        return true
    }
}

extension NSDictionary {
    
}

//XYDataListExtension Protocol
extension NSDictionary : XYDataListExtension {
    
    typealias SelfType = NSDictionary
    
}

// MARK: - NSMutableDictionary
extension NSMutableDictionary {
    
    /**
     *    @description 添加数据(封闭层)
     *
     *    @param    value    Any?
     *
     *    @param    forKey    String
     *
     *    @return   Self
     */
    @discardableResult func xySetObject(_ value: Any?, forKey: String) -> Self {
        
        self.setValue(value, forKey: forKey)
        
        return self
    }
    
}



