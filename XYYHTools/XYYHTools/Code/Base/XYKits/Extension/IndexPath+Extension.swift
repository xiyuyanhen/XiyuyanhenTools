//
//  IndexPath+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2020/1/3.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation

extension IndexPath {
    
    static func Upper(indexPathArr arrOrNil: [IndexPath]?) -> IndexPath? {
        
        guard var arr = arrOrNil,
            let first = arr.first else { return nil }
        
        guard 1 < arr.count else { return first }
        
        arr.sort { (firstElement, secondElement) -> Bool in
            
            if (firstElement.section < secondElement.section) {
             
                return true
                
            }else if (firstElement.section == secondElement.section) {
                
                return (firstElement.row <= secondElement.row)
            }
            
            return false
            
        }
        
        guard let last = arr.last else { return nil }
        
        return last
    }
    
    // 有效性
    var xyIsEffective: Bool {
        
        guard (0 <= self.section),
            (0 <= self.row) else { return false }
        
        return true
    }
}
