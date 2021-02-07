//
//  XYBmobObjectProtocol.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/8/18.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYBmobObjectProtocol: XYWCDBProtocol {
    
    /// 对象序列化数据
    var objectDataDicOrNil: Dictionary<String, Any>? { get }
}

extension XYBmobObjectProtocol {

    /// bmob对象表名
    static var BmobObjectClassName: String {
        
        return Self.Table.name
    }
    
    /// bmob对象表名
    var bmobObjectClassName: String {
        
        return Self.BmobObjectClassName
    }
}

extension XYBmobObjectProtocol {
    
    /// 查询条件
    var bmobQuery: BmobQuery {
        
        return BmobQuery(className: self.bmobObjectClassName)
    }
}

extension XYBmobObjectProtocol {
    
    static var kObjectDataMD5: String { return "ObjectDataMD5" }
    
    /// 对象数据MD5值
    var objectDataMD5: String {
        
        var newValue: String = ""
        
        if let objectDataDic = self.objectDataDicOrNil {
            
            let sortedKeyArr:[String] = objectDataDic.keys.sorted { (s0, s1) -> Bool in
                
                let result = ( s0 < s1)
                return result
            }
            
            for sortedKey in sortedKeyArr {
                guard let value = objectDataDic.xyObjectValue(sortedKey) else { continue }
                
                newValue += "&\(sortedKey):\(value)"
            }
        }
        
        return newValue.MD5String()
    }
    
    /// 生成BmobObject对象
    var bmobObjectOrNil: BmobObject? {
        
        /*
         1. className 不能包含中文，保存会报错(code:1)；
        */
        
        guard let newValue = BmobObject(className: self.bmobObjectClassName) else { return nil }
        
        if let objectDataDic = self.objectDataDicOrNil {
            
            newValue.saveAll(with: objectDataDic)
        }
        
        return newValue
    }
}

extension XYBmobObjectProtocol {
    
    func save(_ block: @escaping (XYBmobResult<BmobObject, XYError>) -> Void) {
        
        self.saveOnWCDB { (result) in
            
            switch result {
            case .Complete(_):
                self.saveOnBmob(block)
                break
                
            case .Error(let error):
                block(.Error(error))
                break
            }
        }
    }
    
    func saveOnWCDB(_ block: @escaping (XYBmobResult<Bool, XYError>) -> Void) {
        
        self.insertOrReplace { (result) in
            
            switch result {
            case .Success(_):
                
                block(.Complete(true))
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
    
    func saveOnBmob(_ block: @escaping (XYBmobResult<BmobObject, XYError>) -> Void) {
        
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
    }
    
    func selectOnBmobByObjectDataMD5(_ block: @escaping (XYBmobResult<[BmobObject]?, XYError>) -> Void) {
     
        let objectDataMD5: String = self.objectDataMD5
        
        let query = self.bmobQuery
        query.whereKey(Self.kObjectDataMD5, equalTo: objectDataMD5)
        query.findObjectsInBackground { (resultOrNil, errorOrNil) in
            
            if let e = errorOrNil {
                
                block(.Error(XYError(error: e)))
                return
            }
            
            guard let result = resultOrNil else {
                
                
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
