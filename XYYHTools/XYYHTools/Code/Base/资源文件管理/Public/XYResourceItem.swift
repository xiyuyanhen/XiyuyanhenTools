//
//  XYResourceItem.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/8/5.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYResourceItem : NSObject, XYResourceProtocol {
    
    let resourceType: XYResourceType
    
    var resourceAddress: XYResourceAddress
    
    let uuId: String
    
    let itemId: String
    
    var queueIdOrNil: String?
    
    init(resourceAddress: XYResourceAddress,
         resourceType: XYResourceType) {
        
        self.resourceType = resourceType
        
        self.resourceAddress = resourceAddress
        
        let uuID = "\(resourceType.shortFlag)\(resourceAddress.address.MD5String())"
        
        self.uuId = uuID
        
        self.itemId = "\(uuID)\(String.MicroSecondString())".MD5String()
        
        super.init()
    }
    
    convenience init?(resourceType: XYResourceType,
                      url urlOrNil:String? = nil) {
        
        guard let rAddress = XYResourceAddress(address: urlOrNil, type: XYResourceAddressType.URL) else { return nil }
        
        self.init(resourceAddress: rAddress,
                  resourceType: resourceType)
    }
}

extension XYResourceItem {
    
    /// 链接 (本地/网络)
    var itemUrlOrNil : URL? { return self.resourceAddress.urlOrNil }
}

extension XYResourceItem {
    
    /**
     *    @description 是否与另一个资源文件不相同 (检验文件地址)
     *
     *    @param    otherOrNil    另一个资源文件
     *
     *    @return   Bool
     */
    func isNotEqualAddress(_ otherOrNil: XYResourceItem?) -> Bool {
        
        return self.isEqualAddress(otherOrNil) == false
    }
    
    /**
     *    @description 是否与另一个资源文件相同 (检验文件地址)
     *
     *    @param    otherOrNil    另一个资源文件
     *
     *    @return   Bool
     */
    func isEqualAddress(_ otherOrNil: XYResourceItem?) -> Bool {
        
        guard let other = otherOrNil,
            self.resourceAddress.isEqual(other.resourceAddress) else { return false }
        
        return true
    }
    
}

extension XYResourceItem : XYItemSearch_Protocol {
    
    /// 检索Id
    var itemSearchId: String { return self.itemId }
}
