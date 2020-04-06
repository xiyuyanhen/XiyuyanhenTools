//
//  ClassModelProtocol_Create.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - ClassModelProtocol_Create
protocol ClassModelProtocol_Create : NSObject, ModelProtocol_Array {
    
    init?(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any?)
}

extension ClassModelProtocol_Create where Self : NSObject {
    
    static func CreateArray(listArr listArrOrNil : NSArray?, extraData eDataOrNil: Any? = nil) -> ModelArray? {
        
        guard let listArr = listArrOrNil else { return nil }
        
        var modelArr : ModelArray  = ModelArray()
        
        for subData in listArr {
            
            guard let subDataDic = subData as? NSDictionary,
                0 < subDataDic.count else { continue }
            
            guard let model = Self.init(dataDic: subDataDic, extraData: eDataOrNil) else { continue }
            
            modelArr.append(model)
        }
        
        guard 0 < modelArr.count else { return nil }
        
        return modelArr
    }
    
    init?(dicText dicTextOrNil : String?, extraData eDataOrNil: Any? = nil) {
        
        guard let dicText = dicTextOrNil,
            dicText.isNotEmpty,
            let dic = NSDictionary.CreateWith(jsonString: dicText) else { return nil }
        
        self.init(dataDic: dic, extraData: eDataOrNil)
    }
    
    static func CreateArray(listArrText listArrTextOrNil : String?, extraData eDataOrNil: Any? = nil) -> ModelArray? {
        
        guard let listArrText = listArrTextOrNil,
            listArrText.isNotEmpty,
            let array = NSArray.CreateWith(jsonString: listArrText) else { return nil }
        
        return self.CreateArray(listArr: array, extraData: eDataOrNil)
    }
}
