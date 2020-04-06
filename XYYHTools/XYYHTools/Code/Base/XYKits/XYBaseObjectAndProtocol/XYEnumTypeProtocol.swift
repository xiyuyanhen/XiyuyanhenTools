//
//  XYEnumTypeProtocol.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/11/15.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - XYEnumTypeProtocol 通用枚举协议
/// 通用枚举协议
protocol XYEnumTypeProtocol {
    
}

extension XYEnumTypeProtocol {
    
    var enumName : String {
        
        return "\(type(of: self))"
    }
    
    var name : String {
        
        return "\(self)"
    }
}

extension XYEnumTypeProtocol {
    
    /// 是否包含其一
    func xyEqual(types: Self...) -> Bool {
        
        let name = self.name
        let enumName = self.enumName
        
        if name != enumName {
            
            for type in types {
                
                guard type.name == self.name else { continue }
                
                return true
            }
            
            
        }else {
            
            /// 通常是OC定义的枚举类型出现这种情况，应该手动修改 name 方法
                        
            #if DEBUG

            fatalError("类型需要调整")

            #else
            #endif
        }
        
        return false
    }
}

// MARK: - XYEnumTypeAllCaseProtocol 集合枚举协议
/// 集合枚举协议
protocol XYEnumTypeAllCaseProtocol : CaseIterable, XYEnumTypeProtocol {
    
}

extension XYEnumTypeAllCaseProtocol {
    
    static var AllCaseArr : [Self] {

        return self.allCases as! [Self]
    }
    
    static var AllNameArr : [String] {
        
        var titleArr = [String]()
        
        for type in self.AllCaseArr {
            
            titleArr.append(type.name)
        }
        
        return titleArr
    }
}

// MARK: - XYEnumKeyProtocol 拥有Key参数的集合枚举协议
protocol XYEnumKeyProtocol : XYEnumTypeAllCaseProtocol, Hashable {
    
}

extension XYEnumKeyProtocol {
    
    var key : String {
        
        return self.name
    }
}
