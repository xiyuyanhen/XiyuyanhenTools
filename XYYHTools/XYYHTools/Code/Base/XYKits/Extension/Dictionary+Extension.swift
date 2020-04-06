//
//  Dictionary+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/4.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 数据组合
    static func Merge<T>(dic:[String: T], otherDic otherDicOrNil: [String: T]?) -> [String: T] {
    
        var resultDic = dic
        
        if let otherDic = otherDicOrNil {
            
            for (key, value) in otherDic {
                
                resultDic[key] = value
            }
        }
    
        return resultDic
    }
}

extension Dictionary {

    func xyLogAllProperty(name: String) {
        
        XYLog.Log(msg: "-------------------------- \(name) --------------------------", type: XYLogType.Brief)
        
        var dataArr = [(property: String, setProperty: String)]()
        
        for keyUnknow in self.keys {

            guard let keyStr = keyUnknow as? String,
                self.cannoteBeIgnoreKey(key: keyStr) else { continue }
            
            /// 数据类型字符
            var valueTypeStr: String = "String"
            
            if let key = keyStr as? Key,
                let value = self.xyObjectValue(key) {
                
                // 暂时未能明确区分数据应该是Double/Float/Int类型，所以现阶段先统一使用NSNumber类型
                if let _ = value as? NSNumber {
                    
                    valueTypeStr = "NSNumber"
                }else if let _ = value as? Double {
                    
                    valueTypeStr = "Double"
                }else if let _ = value as? Float {
                    
                    valueTypeStr = "Float"
                }else if let _ = value as? Int {
                    
                    valueTypeStr = "Int"
                }
            }

            let msg : String = """
            if let \(keyStr):\(valueTypeStr) = dataDic.xyObject(\"\(keyStr)\") {
            
                newValue.\(keyStr)OrNil = \(keyStr)
            }\n
            """

            dataArr.append((property: "var \(keyStr)OrNil : \(valueTypeStr)?", setProperty: msg))
        }
        
        for data in dataArr {
            
            XYLog.Log(msg: data.property, type: XYLogType.Brief)
        }
        
        XYLog.Log(msg: "\n", type: XYLogType.Brief)
        
        for data in dataArr {
            
            XYLog.Log(msg: data.setProperty, type: XYLogType.Brief)
        }
        
        XYLog.Log(msg: "----------------------------------------------------", type: XYLogType.Brief)
    }
    
    /**
     *    @description 是否为不能忽略的Key
     *
     *    @param    key    Key参数名
     *
     *    @return   Bool
     */
    private func cannoteBeIgnoreKey(key: String) -> Bool {
        
        switch key {
        case "updator",
             "updateAt",
             "createAt",
             "creator":  return false
            
        default: return true
        }
    }
}

extension Dictionary {
    
    /**
    *    @description 根据Key获取数据
    *
    *    @param    forKey    数据索引
    *
    *    @return   数据
    */
    func xyObjectValue(_ forKey: Self.Key) -> Value? {
        
        guard let value = self[forKey] else { return nil }
        
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
    func xyObject<E>(_ forKey: Self.Key) -> E? {
        
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
    func xyObject<E>(_ forKey: Self.Key, defaultValue: E) -> E {
        
        guard let value: E = self.xyObject(forKey) else { return defaultValue }
        
        return value
    }
}

extension Dictionary {
    
    /**
    *    @description 是否包含Key值
    *
    *    @param    forKey    Key值
    *
    *    @return   Bool
    */
    func xyContainKey(_ forKey: Self.Key) -> Bool {
        
        guard self.xyObjectValue(forKey) != nil else { return false }
        
        return true
    }
}

//XYDataListExtension Protocol
extension Dictionary : XYDataListExtension{
    
    typealias SelfType = Dictionary
    
}

extension Dictionary {
    
    /**
     *    @description 添加数据(封闭层)
     *
     *    @param    value    Value?
     *
     *    @param    forKey    String
     *
     *    @return   Self
     */
    @discardableResult mutating func xySetObject(_ value: Value?, forKey: Self.Key) -> Self {
        
        self[forKey] = value
        
        return self
    }
    
}
