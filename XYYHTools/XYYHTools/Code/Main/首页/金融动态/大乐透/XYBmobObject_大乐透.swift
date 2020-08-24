//
//  XYBmobObject_大乐透.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/8/20.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation
import WCDBSwift

class XYBmobObject_大乐透: XYBmobObjectProtocol {
    
    var dataObjectId: String
    var expect: String
    var frontAreaNumber1: Int = 0
    var frontAreaNumber2: Int = 0
    var frontAreaNumber3: Int = 0
    var frontAreaNumber4: Int = 0
    var frontAreaNumber5: Int = 0
    var backAreaNumber1: Int = 0
    var backAreaNumber2: Int = 0
    
    init(dataObjectId: String, expect: String) {
        
        self.dataObjectId = dataObjectId
        self.expect = expect
    }
    
    var objectDataDicOrNil: Dictionary<String, Any>? {
        
        return [CodingKeys.dataObjectId.stringValue: self.dataObjectId,
            CodingKeys.expect.stringValue: self.expect,
            CodingKeys.frontAreaNumber1.stringValue: self.frontAreaNumber1,
            CodingKeys.frontAreaNumber2.stringValue: self.frontAreaNumber2,
            CodingKeys.frontAreaNumber3.stringValue: self.frontAreaNumber3,
            CodingKeys.frontAreaNumber4.stringValue: self.frontAreaNumber4,
            CodingKeys.frontAreaNumber5.stringValue: self.frontAreaNumber5,
            CodingKeys.backAreaNumber1.stringValue: self.backAreaNumber1,
            CodingKeys.backAreaNumber2.stringValue: self.backAreaNumber2]
    }
    
    static var Table: TableNameProtocol = XYWTableName.TableName_大乐透
    
    enum CodingKeys: String, CodingTableKey {
    
        typealias Root = XYBmobObject_大乐透
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        //List the properties which should be bound to table
        
        case dataObjectId
        case expect
        case frontAreaNumber1
        case frontAreaNumber2
        case frontAreaNumber3
        case frontAreaNumber4
        case frontAreaNumber5
        case backAreaNumber1
        case backAreaNumber2
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .dataObjectId:  ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
                .expect:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber1:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber2:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber3:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber4:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber5:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .backAreaNumber1:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .backAreaNumber2:  ColumnConstraintBinding(isNotNull: true, isUnique: false)
            ]
        }
    }
}

extension XYBmobObject_大乐透 {
    
    
}

/*
 
 https://www.mxnzp.com/
 
 https://www.mxnzp.com/api/lottery/common/aim_lottery?expect=20074&code=cjdlt&app_id=slipvxfgrtsbrnwx&app_secret=ZEZpT2lmRXIwcUJwSVNqTituQ3VGZz09
 
 {
     "code": 1,
     "msg": "数据返回成功！",
     "data": {
         "openCode": "03,09,10,12,21+04+11",
         "code": "cjdlt",
         "expect": "20074",
         "name": "超级大乐透",
         "time": "2020-08-10 20:30:00"
     }
 }
 
 */
