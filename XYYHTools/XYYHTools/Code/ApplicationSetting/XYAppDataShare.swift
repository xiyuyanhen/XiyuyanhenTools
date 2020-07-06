//
//  XYAppDataShare.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/7/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

/// App 共享数据(绑定在Application上，可以挂载希望存储的其它单例数据)
class XYAppDataShare : NSObject {
    
    static var Share: XYAppDataShare {
        
        return XYApplication.Share().dataShare
    }
    
    //@available(iOS, deprecated: 8.0, message: "禁止使用此构造方法，应该使用Share，保证获取的是单例数据")
    override init() {
        super.init()
        
    }
    
    lazy var bmobTools: XYBmobTools = {
        
        return XYBmobTools()
    }()

}
