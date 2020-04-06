//
//  XYCopyProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/5.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

/********************** NSCopying协议功能扩展 ********************/

import Foundation

/// NSCopying协议功能扩展
protocol XYCopyProtocol : NSCopying {
    
}

extension XYCopyProtocol {
    
    var newByCopyOrNil : Self? {
        
        guard let newObj = self.copy() as? Self else { return nil }
        
        return newObj
    }
    
    static func NewByCopy(objArr objArrOrNil: [Self]?) -> [Self]? {
        
        guard let objArr = objArrOrNil,
            objArr.isNotEmpty else { return nil }
        
        var newObjArr : [Self] = [Self]()
        
        for obj in objArr {
            
            guard let newObj = obj.newByCopyOrNil else { continue }
            
            newObjArr.append(newObj)
        }
        
        guard newObjArr.isNotEmpty else { return nil }
        
        return newObjArr
    }
}
