//
//  XYResourceAddress.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/3.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

func XYURLBy(address addressOrNil: String?, type: XYResourceAddressType = XYResourceAddressType.Path) -> URL? {
    
    guard let address = addressOrNil else { return nil }
    
    switch type {
    case .URL: return URL(string: address)
    case .Path: return URL(fileURLWithPath: address)
    }
}

enum XYResourceAddressType {
    /// 网络资源
    case URL
    /// 本地地址
    case Path
}

/// 资源位置
struct XYResourceAddress : ModelProtocol_Array {

    /// 地址
    let address : String
    
    /// 位置类型
    let type : XYResourceAddressType
    
    /// 文件名称
    var nameOrNil: String?
    
    init?(address addressOrNil: String?, type: XYResourceAddressType) {
        
        guard let address = addressOrNil,
            address.isNotEmpty else { return nil }
        
        self.address = address
        self.type = type
    }
    
    lazy var urlOrNil: URL? = {
        
        return XYURLBy(address: self.address, type: self.type)
    }()
}

extension XYResourceAddress {
    
    mutating func fileExists() -> Bool {
        
        guard self.type == .Path else {
            
            // 若为网络资源，默认存在
            return true
        }
        
        guard let url = self.urlOrNil,
            XYFileManager.FileExists(fileUrl: url) else { return false }
        
        return true
    }
    
}

extension XYResourceAddress {
    
    /**
     *    @description 是否与另一个资源文件不相同 (检验文件地址)
     *
     *    @param    otherOrNil    另一个资源文件
     *
     *    @return   Bool
     */
    func isNotEqual(_ otherOrNil: XYResourceAddress?) -> Bool {
        
        return self.isEqual(otherOrNil) == false
    }

    /**
     *    @description 是否与另一个资源文件相同 (检验文件地址)
     *
     *    @param    otherOrNil    另一个资源文件
     *
     *    @return   Bool
     */
    func isEqual(_ otherOrNil: XYResourceAddress?) -> Bool {
        
        guard let other = otherOrNil,
            self.address == other.address  else { return false }
        
        return true
    }
}
