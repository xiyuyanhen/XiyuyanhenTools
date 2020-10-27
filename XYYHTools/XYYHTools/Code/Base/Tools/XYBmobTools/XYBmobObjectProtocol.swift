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
        
        /*
         1. className 不能包含中文，保存会报错(code:1)；
        */
        
        guard let newValue = BmobObject(className: Self.Table.name) else { return nil }
        
        if let objectDataDic = self.objectDataDicOrNil {
            
            newValue.saveAll(with: objectDataDic)
            
//            for (key, value) in objectDataDic {
//
//                newValue.setObject(value, forKey: key)
//            }
        }
        
        return newValue
    }
    
    func save(_ block: @escaping (XYBmobResult<BmobObject, XYError>) -> Void) {
        
        self.insertOrReplace { (result) in
            
            switch result {
            case .Success(_):
                
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
                        
                        XYLog.LogNote(msg: "Bmob保存对象成功(objectId: \(objectId))")
                        
                        block(.Complete(weakObje))

                    }else if let error = errorOrNil {

                        let xyError = XYError(error: error)

                        XYLog.LogNote(msg: "Bmob保存对象失败, code: \(xyError.code) msg: \(xyError.detailMsg)")
                        
                        block(.Error(xyError))
                        
                    }else {

                        XYLog.LogNote(msg: "Bmob保存对象失败, 未知错误")
                        
                        block(.Error(XYBmobError.保存到Bmob失败.error()))
                    }
                }
                
                return
                
            case .Failure(_):
                
                block(.Error(XYBmobError.保存到本地数据库失败.error()))
                return
                
            case .Error(let error):
                
                block(.Error(error))
                return
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
    
    case 保存到Bmob失败 = "10002#*#保存到Bmob失败"
    
    case 保存到本地数据库失败 = "10003#*#保存到本地数据库失败"
    
}
