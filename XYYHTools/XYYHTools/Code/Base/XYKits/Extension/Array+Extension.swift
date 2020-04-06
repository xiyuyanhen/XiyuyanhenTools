//
//  Array+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/4.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

extension Array {
    
    /**
     *    @description 添加数据(过滤Nil数据)
     *
     */
    @discardableResult mutating func appendByFilterNil(_ elementOrNil: Element?) -> Element? {
        
        guard let element = elementOrNil else { return nil }

        self.append(element)
        
        return element
    }
    
    /// 过滤条件Block
    typealias XYAppendFilterBlock = (_ newElement: Element, _ allElements: [Element]) -> Bool
    
    /**
     *    @description 通过过滤条件判断，如果允许，才添加到当前数组wywg
     *
     *    @param    elementOrNil    新的元素
     *
     *    @param    filterBlock    过滤条件Block
     *
     */
    mutating func xyAppendByFilterBlock(_ elementOrNil: Element?, filterBlock: XYAppendFilterBlock) {
        
        guard let element = elementOrNil,
            filterBlock(element, self) else { return }
        
        self.append(element)
    }
    
    /**
     *    @description 添加到随机位置
     *
     */
    mutating func appendByRandom(_ newElement: Element) {
        
        guard self.isNotEmpty else {
            
            self.append(newElement)
            return
        }
        
        let random = Int.random(in: 0 ... self.count)
        
        if random == self.count {
            
            self.append(newElement)
        }else {
            
            self.insert(newElement, at: random)
        }
    }
    
    /**
     *    @description 随机打乱数据位置
     *
     */
    mutating func confusionElementsByRandom() {
        
        guard self.isNotEmpty else { return }
        
        let elementsCache = self
        
        self.removeAll()
        
        for element in elementsCache {
            
            self.appendByRandom(element)
        }
    }
    
    /**
     *    @description 索取指定位置的元素(已做防越界处理)
     *
     *    @param    index    指定位置
     *
     */
    func elementByIndex(_ index: Int) -> Element? {
        
        guard 0 <= index,
            index < self.count else { return nil }
        
        return self[index]
    }
    
    /**
     *    @description 移除开头的count个元素
     *
     *    @param    count    需要移除的元素数量(如果原数据不足，则全部移除)
     *
     *    @return   被移除的元素组合
     */
    mutating func removeHeaderElements(count: UInt) -> SelfType? {
        
        guard 0 < count,
            self.isNotEmpty else {
            
            return nil
        }
    
        var removedElements = SelfType()
        guard count < self.count else {
            
            removedElements.append(contentsOf: self)
            
            self.removeAll()
            
            return removedElements
        }
        
        while removedElements.count < count {
            
            removedElements.append(self.removeFirst())
        }
    
        return removedElements
    }
    
    /**
     *    @description 替换数据到指定位置
     *
     */
    @discardableResult mutating func xyReplaceElement(_ newElement: Element, index: Int) -> Element? {
        
        // 取旧数据
        guard let oldElement = self.elementByIndex(index) else { return nil }
        
        // 替换新数据
        self[index] = newElement
        
        // 返回旧数据
        return oldElement
    }
    
    /**
     *    @description 根据当前数组数据生成新的数据组
     *
     *    @param    E    新的数据类型
     *
     *    @param    block    新的数据构建闭包
     *
     *    @param    defaultElements    默认数据(可选，可以在无法构建有效数据时，默认返回的数据)
     *
     *    @return   新的数据组(无有效数据时为Nil)
     */
    func xyNewArrayOrNil<E>(_ block: (Element) -> E?, defaultElements defaultElementsOrNil: [E]? = nil) -> [E]? {
        
        let results: [E] = self.xyNewArray(block, defaultElements: defaultElementsOrNil)
        
        guard results.isNotEmpty else { return nil }
        
        return results
    }
    
    /**
     *    @description 根据当前数组数据生成新的数据组
     *
     *    @param    E    新的数据类型
     *
     *    @param    block    新的数据构建闭包
     *
     *    @param    defaultElements    默认数据(可选，可以在无法构建有效数据时，默认返回的数据)
     *
     *    @return   新的数据组(无有效数据时为空数组)
     */
    func xyNewArray<E>(_ block: (Element) -> E?, defaultElements defaultElementsOrNil: [E]? = nil) -> [E] {
        
        var results: [E] = [E]()
        
        for element in self {
            
            guard let newE = block(element) else { continue }
            
            results.append(newE)
        }
        
        if results.isEmpty,
            let defaultElements = defaultElementsOrNil {
            
            // 如果没有有效的构建数据，但设置了默认数据，返回默认数据
            
            return defaultElements
        }
    
        return results
    }
    
    var xyIndexFromRandom: Int {
        
        guard 1 < self.count else { return 0 }
        
        return Int.random(in: 0 ..< self.count)
    }
    
    var xyElementFromRandomOrNil: Element? {
        
        return self.elementByIndex(self.xyIndexFromRandom)
    }
}

// MARK: - Filter
extension Array {
    
    typealias FilterOneElementBlock = (Element) -> Bool
    
    /**
     *    @description 根据条件筛选元素数据
     *
     *    @param    filterBlock    返回true则符合筛选条件，保留在filters中，不符合的保留在others
     *
     *    @return   筛选过的数据
     */
    mutating func filter(_ filterBlock: FilterOneElementBlock) -> (filters: [Element], others: [Element]) {
        
        var filters : [Element] = [Element]()
        var others : [Element] = [Element]()
        
        while let element = self.first {
            
            if filterBlock(element) {
                
                filters.append(element)
            }else {
                
                others.append(element)
            }
            
            self.remove(at: 0)
        }
        
        return (filters: filters, others: others)
    }
}



//XYDataListExtension Protocol
extension Array : XYDataListExtension {
    
    typealias SelfType = Array
    
}

extension Array where Element == NSRange {

    /// 是否包含指定的范围
    func xyIsInclude(_ otherItem: Element) -> Bool {
        
        let otherItemEndLocation = otherItem.location + otherItem.length
        
        for element in self {
            
            let elementEndLocation = element.location + element.length
            
            let boolA = (element.location <= otherItemEndLocation) && (otherItemEndLocation <= elementEndLocation)
            
            let boolB = (element.location <= otherItem.location) && (otherItem.location <= elementEndLocation)
            
            if boolA || boolB {
                
                return true
            }
            
        }
        
        return false
    }
    
    mutating func xySortByLocation() {
        
        self.sort { (firstElement, secondElement) -> Bool in
            
            return firstElement.location < secondElement.location
        }
    }
}
