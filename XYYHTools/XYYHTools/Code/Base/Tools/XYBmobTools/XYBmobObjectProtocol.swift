//
//  XYBmobObjectProtocol.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/8/18.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYBmobObjectProtocol: XYWCDBProtocol {
    
    var objectDataDicOrNil: Dictionary<String, Any>? { get }
}

extension XYBmobObjectProtocol {
    
    var bmobObjectOrNil: BmobObject? {
        
        guard let objectDataDic = self.objectDataDicOrNil else { fatalError() }
        
        guard let newValue = BmobObject(className: self.className) else { return nil }
        
        for (key, value) in objectDataDic {
            
            newValue.setObject(value, forKey: key)
        }
        
        return newValue
    }
    
    func save(_ block: @escaping (XYBmobResult<BmobObject, XYError>) -> Void) {
        
        guard let bmobObj = self.bmobObjectOrNil else {
            
            block(.Error(XYBmobError.初始化失败.error()))
            return
        }
        
        bmobObj.saveInBackground { [weak bmobObj] (isSuccessful, errorOrNil) in
            
            if isSuccessful,
                let weakObje = bmobObj,
                let objectId = weakObje.objectId,
                objectId.isNotEmpty {
                
                //创建成功后会返回objectId，updatedAt，createdAt等信息
                
                XYLog.LogNote(msg: "保存对象成功(objectId: \(objectId))")
                
                block(.Complete(weakObje))

            }else if let error = errorOrNil {

                let xyError = XYError(error: error)

                XYLog.LogNote(msg: "保存对象失败, code: \(xyError.code) msg: \(xyError.detailMsg)")
                
                block(.Error(xyError))
                
            }else {

                XYLog.LogNote(msg: "保存对象失败, 未知错误")
                
                block(.Error(XYBmobError.保存失败.error()))
            }
        }
    }
    
}

extension XYBmobObjectProtocol {

    
}


enum XYBmobResult<R, Error: Swift.Error> {
    
    /// 完成
    case Complete(R)
    
    /// 失败
    case Error(Error)
    
    var Complete_Int:Int { return 1201 }
    var Error_Int:Int { return 1202 }
    
}

typealias XYBmobHandleResult = (XYBmobResult<BmobObject, XYError>) -> Void

enum XYBmobError: String, XYErrorCustomTypeProtocol {

    case 初始化失败 = "10001#*#初始化失败"
    
    case 保存失败 = "10002#*#保存失败"
    
}
