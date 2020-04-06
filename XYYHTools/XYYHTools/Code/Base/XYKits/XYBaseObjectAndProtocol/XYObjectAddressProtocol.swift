//
//  XYObjectAddressProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/20.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 输出对象地址的协议功能扩展
protocol XYObjectAddressProtocol {
    
}

extension XYObjectAddressProtocol where Self : AnyObject {
    
    /**
     *    @description 获取class, struct，enum等类型的变量内存地址
     *
     *    @return   内存地址
     */
    var xy_RAMAddress: String {
    
        return "\(Unmanaged<AnyObject>.passUnretained(self).toOpaque())"
    }
}

extension NSObject: XYObjectAddressProtocol {}
