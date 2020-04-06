//
//  Bool+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2020/1/2.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation

extension Bool {
    
    /**
     *    @description 根据Bool值返回元素
     *
     *    @param    tElement    当Bool为True时的元素
     *
     *    @param    fElement    当Bool为False时的元素
     *
     *    @return   返回元素
     */
    func xyReturn<T>(_ tElement: T, _ fElement: T) -> T {
        
        if self {
            
           return tElement
        }
        
        return fElement
    }
}

// MARK: - Block
extension Bool {
    
    /**
    *    @description 根据Bool值执行操作并返回元素
    *
    *    @param    tBlock    当Bool为True时的Block
    *
    *    @param    fBlock    当Bool为False时的Block
    *
    *    @return   返回元素
    */
    func xyReturnByBlock<T>(_ tBlock: ()->T, _ fBlock: ()->T) -> T {
        
        if self {
            
           return tBlock()
        }
        
        return fBlock()
    }

    /**
     *    @description 当Bool值为True时执行Block
     *
     *    @param    block    待执行Block
     *
     */
    func xyRunBlockWhenTrue(_ block: ()->Void) {
        
        guard self else { return }
        
        block()
    }
    
    /**
     *    @description 当Bool值为False时执行Block
     *
     *    @param    block    待执行Block
     *
     */
    func xyRunBlockWhenFalse(_ block: ()->Void) {
        
        guard self else {
            
            block()
            return
        }
    }
    
    /**
    *    @description 根据Bool值执行操作
    *
    *    @param    tBlock    当Bool为True时的Block
    *
    *    @param    fBlock    当Bool为False时的Block
    *
    */
    func xyRunBlock(_ tBlock: ()->Void, _ fBlock: ()->Void) {
        
        if self {
            
           tBlock()
           return
        }
        
        fBlock()
    }
    
}
