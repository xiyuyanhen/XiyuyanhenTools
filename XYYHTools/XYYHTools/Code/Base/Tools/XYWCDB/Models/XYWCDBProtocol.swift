//
//  XYWCDBProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/14.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import WCDBSwift

protocol XYWCDBProtocol: WCDBSwift.TableCodable, ModelProtocol_Array {
    
    static var Table: TableNameProtocol { get }
}

extension XYWCDBProtocol {
    
    static var ClassName : String {
        
        return "\(self)"
    }
    
    var className : String {
        
        guard let anyClass = object_getClass(self) else { return "unKnow" }
        
        let className = "\(anyClass)"
        
        return className
    }
    
    var tableName: String {
        
        return self.className
    }
}

// MARK: - Insert
extension XYWCDBProtocol {
    
    /**
     *    @description 插入或替换模型数据
     *
     *    @param    resultBlock    结果回调
     *
     */
    func insertOrReplace(resultBlock blockOrNil: XYResultHandleBlock? = nil) {
        
        Self.InsertOrReplace(objects: [self], resultBlock: blockOrNil)
    }
    
    /**
    *    @description 插入或替换模型数据
    *
    *    @param    resultBlock    结果回调
    *
    */
    static func InsertOrReplace(objects: Self.ModelArray, resultBlock blockOrNil: XYResultHandleBlock? = nil) {
        
        XYWDBManager.insertOrReplace(self.Table, objects: objects, errorClosure: { (errorOrNil) in
            
            if let error = errorOrNil {
                
                XYLog.Log(msg: "\(self.ClassName) - insertError: \(error.description)", type: .Error)
                
                if let block = blockOrNil {
                    
                    block(XYResult.Error(XYError(error: error)))
                }
                
            }else if let block = blockOrNil {
                
                block(XYResult.Failure(nil))
            }
            
        }) {
            
            XYLog.LogNoteBlock { () -> String? in
            
                return "Table:\(self.ClassName) 成功保存数据\(objects.count)条"
            }
            
            if let block = blockOrNil {
                
                block(XYResult.Success(nil))
            }
        }
    }
}

// MARK: - Select
extension XYWCDBProtocol {
    
    /**
     *    @description 查询指定的数据
     *
     *
     *    @return   model
     */
    static func SelectModel(condition conditionOrNil: Condition?) -> Self? {
        
        guard let condition = conditionOrNil else {
            
            return nil
        }
        
        guard let models:Self.ModelArray = XYWDBManager.select(Table, conditioin: condition, errorClosure: nil) else {
            
            return nil
        }
        
        guard models.count <= 1 else{
            
            XYLog.Log(msg: "出现异常，查询结果出现多个！", type: .Warnning)
            return nil
        }
        
        return models.last
    }
    
    /**
     *    @description 查询指定的数据
     *
     *
     *    @return   modelArr
     */
    static func SelectModels(condition conditionOrNil: Condition?) -> Self.ModelArray? {
        
        guard let models:Self.ModelArray = XYWDBManager.select(Table, conditioin: conditionOrNil, errorClosure: nil),
            models.isNotEmpty else {
                
            return nil
        }
        
        return models
    }
}

// MARK: - Delete
extension XYWCDBProtocol {
    
    /**
     *    @description 删除指定的数据
     *
     */
    static func Delete(condition conditionOrNil: Condition?,
                       resultBlock blockOrNil: XYResultHandleBlock? = nil) {
        
        guard let condition = conditionOrNil else {
            
            if let block = blockOrNil {
                
                block(XYResult.Failure(nil))
            }
            return
        }
        
        XYWDBManager.delete(Table, conditioin: condition) { (errorOrNil) in
            
            if let error = errorOrNil {
                
                XYLog.Log(msg: "\(Table.name) - Delete - 失败(\(error.description))", type: .Error)
                
                if let block = blockOrNil {
                    
                    block(XYResult.Error(XYError(error: error)))
                }
                
            }else{
                
                if let block = blockOrNil {
                    
                    block(XYResult.Success(nil))
                }
            }
        }
    }
    
}

extension XYWCDBProtocol {
    
}
