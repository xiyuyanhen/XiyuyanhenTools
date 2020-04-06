//
//  XYItemSearch_Protocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 数据检索协议
protocol XYItemSearch_Protocol {
    
    /// 检索Id
    var itemSearchId : String { get }
}

extension XYItemSearch_Protocol {
    
    /**
     *    @description 是否存在于数组之中
     *
     *    @param    itemArr    数据数组
     *
     *    @return   Bool
     */
    func isIncludeInArr(_ itemArr: [Self]) -> Bool {
        
        guard itemArr.isNotEmpty else { return false }
        
        for item in itemArr {
            
            guard self.itemSearchId == item.itemSearchId else { continue }
            
            return true
        }
        
        return false
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
    static func Search(itemArr itemArrOrNil: [Self]?, searchId searchIdOrNil: String?) -> Self? {
        
        guard let itemArr = itemArrOrNil,
            itemArr.isNotEmpty,
            let searchId = searchIdOrNil,
            searchId.isNotEmpty else { return nil }
        
        for item in itemArr {
            
            guard searchId == item.itemSearchId else { continue }
            
            return item
        }
        
        return nil
    }
    
    static func SearchItems(itemArr itemArrOrNil: [Self]?, filterItemArr: [XYItemSearch_Protocol]) -> [Self]? {
        
        guard let itemArr = itemArrOrNil,
            itemArr.isNotEmpty else { return nil }
        
        var resultArr = [Self]()
        
        for filterItem in filterItemArr {
            
            for item in itemArr {
                
                guard item.itemSearchId == filterItem.itemSearchId else { continue }
                
                resultArr.append(item)
                break
            }
        }
        
        guard resultArr.isNotEmpty else { return nil }
        
        return resultArr
    }
    
    
    /**
     *    @description 根据检索Id从数据数组中找出对应的数据及其所处的序号
     *
     *    @param    itemArr    数据数组
     *
     *    @param    searchId    检索Id
     *
     *    @return   检索Id对应的数据及其所处的序号
     */
    static func SearchWithIndex(itemArr itemArrOrNil: [Self]?, searchId searchIdOrNil: String?) -> (index: Int, model: Self)? {
        
        guard let itemArr = itemArrOrNil,
            itemArr.isNotEmpty,
            let searchId = searchIdOrNil,
            searchId.isNotEmpty else { return nil }
        
        for (index, item) in itemArr.enumerated() {
            
            guard searchId == item.itemSearchId else { continue }
            
            return (index: index, model: item)
        }
        
        return nil
    }
    
    /**
     *    @description 过滤重复的元素，返回新的数组集合
     *
     *    @param    itemArrOrNil    原数组
     *
     *    @return   过滤后的新数组
     */
    static func FilterRepetitionItems(itemArr itemArrOrNil: [Self]?) -> [Self]? {
        
        guard let itemArr = itemArrOrNil,
            itemArr.isNotEmpty else { return nil }
        
        var resultItemArr = [Self]()
        
        for item in itemArr {
            
            /// 没有被包含
            var notContained: Bool = true
            
            for resultItem in resultItemArr {
                
                guard item.itemSearchId == resultItem.itemSearchId else { continue }
                
                notContained = false
                break
            }
            
            guard notContained else { continue }
            
            resultItemArr.append(item)
        }
        
        guard resultItemArr.isNotEmpty else { return nil }
        
        return resultItemArr
    }
    
    /// 收集所有数据的Id
    static func ItemIdArr(_ itemArrOrNil: [Self]?) -> [String]? {
        
        guard let itemArr = itemArrOrNil else { return nil }

        var itemIdArr: [String] = [String]()
        
        for item in itemArr {
            
            itemIdArr.append(item.itemSearchId)
        }
        
        return itemIdArr
    }
    
    /// 获取Id的组合
    static func ItemIds(_ itemArrOrNil: [Self]?) -> String? {
        
        guard let itemArr = itemArrOrNil else { return nil }
        
        var ids: String = ""
        
        for (index, item) in itemArr.enumerated() {
            
            if index == 0 {
                
                ids.append(item.itemSearchId)
                
            }else {
                
                ids.append(",\(item.itemSearchId)")
            }
        }
        
        return ids
    }
}

extension Array where Element: XYItemSearch_Protocol {
    
    /**
     *    @description 根据检索Id从数据数组中找出对应的数据
     *
     *    @param    itemArr    数据数组
     *
     *    @param    searchId    检索Id
     *
     *    @return   检索Id对应的数据
     */
    func xySearch(searchId searchIdOrNil: String?) -> Element? {
        
        return Element.Search(itemArr: self, searchId: searchIdOrNil)
    }
    
    func xySearchItems(filterItemArr: [XYItemSearch_Protocol]) -> [Element]? {
        
        return Element.SearchItems(itemArr: self, filterItemArr: filterItemArr)
    }
    
    /**
     *    @description 根据检索Id从数据数组中找出对应的数据及其所处的序号
     *
     *    @param    itemArr    数据数组
     *
     *    @param    searchId    检索Id
     *
     *    @return   检索Id对应的数据及其所处的序号
     */
    func xySearchWithIndex(searchId searchIdOrNil: String?) -> (index: Int, model: Element)? {
        
        return Element.SearchWithIndex(itemArr: self, searchId: searchIdOrNil)
    }
    
    /**
    *    @description 过滤重复的元素，返回新的数组集合
    *
    *    @return   过滤后的新数组
    */
    func xyFilterRepetitionItems() -> [Element]? {
        
        return Element.FilterRepetitionItems(itemArr: self)
    }
    
    /// 收集所有数据的Id
    var xyItemIdArr: [String]? {
        
        return Element.ItemIdArr(self)
    }
    
    /// 获取Id的组合
    var xyItemIds: String? {
        
        return Element.ItemIds(self)
    }
    
    /// other Custom
    
    /**
     *    @description 通过itemSearchId过滤性添加新元素
     *
     *    @param    elementOrNil    新元素
     *
     */
    mutating func xyAppendByFilterSearchId(_ elementOrNil: Element?) {
        
        self.xyAppendByFilterBlock(elementOrNil) { (element, arr) -> Bool in
            
            guard let itemIdArr = arr.xyItemIdArr else { return true }
            
            return !itemIdArr.contains(element.itemSearchId)
        }
    }
    
    /**
     *    @description 通过itemSearchId过滤性添加新元素
     *
     *    @param    elementsOrNil    新元素组
     *
     */
    mutating func xyAppendByFilterSearchId(_ elementsOrNil: [Element]?) {
        
        guard let elements = elementsOrNil,
            elements.isNotEmpty else { return }
        
        for element in elements {
            
            self.xyAppendByFilterSearchId(element)
        }
    }
    
}

extension String: XYItemSearch_Protocol {
    
    var itemSearchId: String { return self }
}
