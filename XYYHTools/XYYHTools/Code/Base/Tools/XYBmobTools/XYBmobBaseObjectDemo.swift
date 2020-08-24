//
//  XYBmobBaseObject.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/8/18.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation
import WCDBSwift

class XYBmobBaseObjectDemo: XYBmobObjectProtocol {
    
    var dataObjectId: String
    var name: String
    
    init(dataObjectId: String, name: String) {
        
        self.dataObjectId = dataObjectId
        self.name = name
    }
    
    var objectDataDicOrNil: Dictionary<String, Any>? {
        
        return [CodingKeys.dataObjectId.stringValue: self.dataObjectId,
                CodingKeys.name.stringValue: self.name]
    }
    
    static var Table: TableNameProtocol = XYWTableName.BmobBaseObjectDemo
    
    enum CodingKeys: String, CodingTableKey {
    
        typealias Root = XYBmobBaseObjectDemo
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        //List the properties which should be bound to table
        
        case dataObjectId
        case name
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .dataObjectId:  ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
                .name:  ColumnConstraintBinding(isNotNull: true, isUnique: false)
            ]
        }
    }
}
