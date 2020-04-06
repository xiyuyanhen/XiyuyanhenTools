//
//  XYResourceProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/3.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 资源协议
protocol XYResourceProtocol : ModelProtocol_Array {

    /// 资源地址
    var resourceAddress : XYResourceAddress { get }
    
    /// 资源类型
    var resourceType : XYResourceType { get }
    
    /// 唯一ID (根据资源类型前缀、资源地址生成，同一地址的资源，ID应该一致)
    var uuId : String { get }
    
    /// 资源ID (根据唯一ID及时间生成，即使同一资源，ID也不相同)
    var itemId : String { get }

    /// 队列ID (可选参数)
    var queueIdOrNil : String? { get set }
}
