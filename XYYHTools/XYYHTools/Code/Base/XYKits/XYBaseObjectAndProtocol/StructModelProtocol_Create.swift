//
//  StructModelProtocol_Create.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

protocol StructModelProtocol_Create : ModelProtocol_Array {
    
    associatedtype ModelType = Self
    
    //    typealias ExtraDataType = [String:Any]
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any?) -> ModelType?
}

extension StructModelProtocol_Create {
    
    static func CreateArray(listArr listArrOrNil : NSArray?, extraData eDataOrNil: Any? = nil) -> [ModelType]? {
        
        guard let listArr = listArrOrNil else { return nil }
        
        var modelArr : [ModelType]  = [ModelType]()
        
        for subData in listArr {
            
            guard let subDataDic = subData as? NSDictionary,
                0 < subDataDic.count else { continue }
            
            guard let model = Self.CreateModel(dataDic: subDataDic, extraData: eDataOrNil) else { continue }
            
            modelArr.append(model)
        }
        
        guard 0 < modelArr.count else { return nil }
        
        return modelArr
    }
    
    static func CreateModel(dicText dicTextOrNil : String?, extraData eDataOrNil: Any? = nil) -> ModelType? {
        
        guard let dicText = dicTextOrNil,
            dicText.isNotEmpty,
            let dic = NSDictionary.CreateWith(jsonString: dicText) else { return nil }
        
        return self.CreateModel(dataDic: dic, extraData: eDataOrNil)
    }
    
    static func CreateArray(listArrText listArrTextOrNil : String?, extraData eDataOrNil: Any? = nil) -> [ModelType]? {
        
        guard let listArrText = listArrTextOrNil,
            listArrText.isNotEmpty,
            let array = NSArray.CreateWith(jsonString: listArrText) else { return nil }
        
        return self.CreateArray(listArr: array, extraData: eDataOrNil)
    }
}
