//
//  XYItemFilterByBool_Protocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/9/19.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 数据统计协议
protocol XYItemFilterByBool_Protocol {
    
    /// 统计
    var itemFilterByBool : Bool { get }
}

extension XYItemFilterByBool_Protocol {
    
    static func CountByFilter(itemArr itemArrOrNil: [Self]?) -> Int {
        
        guard let itemArr = itemArrOrNil,
            itemArr.isNotEmpty else { return 0 }
        
        var count: Int = 0
        
        for item in itemArr {
            
            guard item.itemFilterByBool else { continue }
            
            count += 1
        }
        
        return count
    }
    
    /**
     *    @description 根据检索Id从数据数组中找出对应的数据
     *
     *    @param    itemArr    数据数组
     *
     *    @param    searchId    检索Id
     *
     *    @return   检索Id对应的数据
     */
    static func ItemsByFilter(itemArr itemArrOrNil: [Self]?) -> [Self]? {
        
        guard let itemArr = itemArrOrNil,
            itemArr.isNotEmpty else { return nil }
        
        var filterItems = [Self]()
        
        for item in itemArr {
            
            guard item.itemFilterByBool else { continue }
            
            filterItems.append(item)
        }
        
        guard filterItems.isNotEmpty else { return nil }
        
        return filterItems
    }
}
