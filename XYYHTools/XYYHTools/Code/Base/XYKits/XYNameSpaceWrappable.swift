//
//  XYNameSpaceWrappable.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2020/1/5.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation

/// XY命名空间
struct XYNameSpace<Base> {

    let nsBase: Base

    init(base: Base) {

        self.nsBase = base
    }
}

/// XY命名空间扩展协议
protocol XYNameSpaceWrappable {
    associatedtype T
    
    var xy: T { get }
    
    static var xy: T.Type { get }
}

extension XYNameSpaceWrappable {
    
    var xy: XYNameSpace<Self> {
        
        return XYNameSpace<Self>(base: self)
    }

    static var xy: XYNameSpace<Self>.Type {
        
        return XYNameSpace<Self>.self
    }
}
