//
//  XYModelWithId.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/11/19.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

class XYModelWithId: XYModel, XYModelWithIdProtocol {
    
    var modelId: String = ""
    
    required init?(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any?) {

        let selfType = type(of: self)
        
        if let modelId = selfType.CreateModelId(),
            0 < modelId.count {

            self.modelId = modelId
        }
        
        super.init(dataDic: dataDicOrNil, extraData: eDataOrNil)

        if let modelId = self.createModelId(),
            0 < modelId.count {

            self.modelId = modelId
        }
    }
    
    /**
     *    @description required init前计算设置modelId
     *
     */
    class func CreateModelId() -> String? {
        
//        let modelId = self.CreateIdByClassAndTime()
        
        return nil
    }
    
    /**
     *    @description required init后计算设置modelId
     *
     */
    func createModelId() -> String? {
        
        return nil
    }

}

protocol XYModelWithIdProtocol {
    
    static func CreateModelId() -> String?
    
    func createModelId() -> String?
}

extension XYModelWithIdProtocol where Self : XYModelWithId {
    
    static func CreateIdByClassAndTime() -> String {
        
        let amplification: Int = 1000000 //精度:纳秒
        let nowDate = Date()
        let nowTimeInterval = TimeInterval(nowDate.timeIntervalSince1970 * Double(amplification))
        let nowtime = TimeInterval(nowTimeInterval - 1483200000000000)
        let theTime = Int64(nowtime)
        
        let microsecond = "\(theTime)"//时间(微秒)
        
        let newClassName = "\(self)"//类名
        
        let newId = "\(newClassName)_\(microsecond)"
        
        return newId
    }
    
    
    
}
