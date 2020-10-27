//
//  WCDB_XYLogMsg.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/24.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import WCDBSwift

class WCDB_XYLogMsg: XYWCDBProtocol {
    
    static var Table: TableNameProtocol = XYWTableName.logMsg
    
    //Your own properties
    
    /// 信息Id
    var msgId: String
    
    /// 信息内容
    var msg : String
    
    /// 日期 (基于1970时间点)
    var dateSince1970 : TimeInterval
    
    /// 信息类型
    var typeRaw : String
    
    /// 文件名
    var fileName : String
    
    /// 方法名
    var functionName : String
    
    /// 信息行数
    var line : Int
    
    /// 标记
    var markOrNil : String? = nil
    
    /// 信息类型
    var type : XYLogType {
        
        guard let type = XYLogType(rawValue: self.typeRaw) else { return .Debug }
        
        return type
    }
    
    /// 日期 (格式: MM/dd HH:mm:ss:SSS)
    var dateString : String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm:ss:SSS"
        
        let date = Date(timeIntervalSince1970: self.dateSince1970)
        
        return dateFormatter.string(from: date)
    }
    
    /// 输出信息
    var outMsg : String {
        
        switch self.type {
        case .Request, .Debug, .Note:
            return String(format: "%@%@ %@ %@", self.type.emojiFlag, self.dateString, self.type.flag, self.msg)
            
        case .Warnning:
            return String(format: "%@%@ %@ %@ %@", self.type.emojiFlag, self.dateString, self.functionName, self.type.flag, self.msg)
            
        case .Error:
            return String(format: "%@%@ %@ %@ %@", self.type.emojiFlag, self.dateString, self.functionName, self.type.flag, self.msg)
            
        case .Function:
            return String(format: "%@%@ %d %@", self.type.emojiFlag, self.dateString, self.line, self.functionName)
            
        case .Brief:
            return String(format: "%@%@", self.type.emojiFlag, self.msg)
        }
    }
    
    required init(msg : String, type : XYLogType, fileName : String, functionName : String, line : Int) {
        
        self.msgId = "\(msg)-\(type.rawValue)-\(fileName)-\(functionName)-\(line)".MD5String()
        self.msg = msg
        self.typeRaw = type.rawValue
        
        if let newFileName = fileName.components(separatedBy: "/Code/").last {
            
            /*
             /Users/xiyuyanhen/Project/Git_Projects/iOS/EStudy/EStudy/EStudy/Code/
             Base/XYKits/BaseViewController.swift
             */
            
            self.fileName = newFileName
        }else {
            
            self.fileName = fileName
        }
        
        self.functionName = functionName
        
        self.line = line
        
        self.dateSince1970 = Date().timeIntervalSince1970
    }
    
    convenience init(msg: String,
                     type: XYLogType = .Debug,
                     _ file: String = #file,
                     _ function: String = #function,
                     _ line: Int = #line) {
        
        self.init(msg: msg, type: type, fileName: file, functionName: function, line: line)
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WCDB_XYLogMsg
        
        //List the properties which should be bound to table
        case msgId
        case msg
        case typeRaw
        case fileName
        case functionName
        case line
        case dateSince1970
        case markOrNil = "mark"
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .msgId : ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
                .msg  : ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .typeRaw  : ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .fileName : ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .functionName : ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .line : ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .dateSince1970 : ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .markOrNil: ColumnConstraintBinding(isNotNull: false, isUnique: false)
            ]
        }
    }
    
}

extension WCDB_XYLogMsg {
    
    //默认保留3天的日志
    static var DefaultClearHours : Float { return 24 * 3 }
    
    static func ClearEarlierMsg(hours: Float = WCDB_XYLogMsg.DefaultClearHours) {
        
        let newDateTimeInterval = Date().timeIntervalSince1970
        
        let earlierTimeInterval : TimeInterval = TimeInterval(hours * 3600)
        
        let earlierDate = Date(timeIntervalSince1970: newDateTimeInterval - earlierTimeInterval)
        
        self.Delete(earlierDate: earlierDate, completionBlock: nil)
    }
}

extension WCDB_XYLogMsg {
    
    /**
     *    @description 相似词
     *
     *    @param    text 检索的字符
     *
     *    @return   约束条件
     */
    static func ConditionBy(msgContain: String, markOrNil: String?) -> Condition {
        
        var newValue = self.Properties.msg.like("%\(msgContain)%")
        
        if let mark = markOrNil {
            
            newValue = newValue && self.Properties.markOrNil.like(mark)
        }
        
        return newValue
    }
}

extension WCDB_XYLogMsg : ModelProtocol_Array {
    
    // MARK: - Insert
    func insertOrReplace() {
        
        WCDB_XYLogMsg.InsertOrReplace(model: self)
    }
    
    class func InsertOrReplace(model:WCDB_XYLogMsg) {
        
        XYWDBManager.insertOrReplace(Table, objects: [model], errorClosure: { (errorOrNil) in
            
            if let error = errorOrNil {
                
                XYLog.Log(msg: "\(self.Table.name) - insertError: \(error.description)", type: .Error, isNeedSave: false)
            }
            
        }) {
            
            
        }
    }
    
    /**
     *    @description 删除所有数据
     *
     *    @param
     *
     *
     */
    static func DeleteAll(completionBlock:CompletionElementBlockHandler<Error>?) {
        
        XYWDBManager.delete(Table, conditioin: nil) { (errorOrNil) in
            
            guard let block = completionBlock else { return }
            
            if let error = errorOrNil {
                
                XYLog.Log(msg: error.description, type: .Error, isNeedSave: false)
                block(error)
                
            }else{
                
                block(nil)
            }
        }
    }
    
    /**
     *    @description 删除指定的数据
     *
     *    @param
     *
     *
     */
    static func Delete(earlierDate eDate: Date, completionBlock:CompletionElementBlockHandler<Error>?) {
        
        XYWDBManager.delete(Table, conditioin: WCDB_XYLogMsg.Properties.dateSince1970 < eDate.timeIntervalSince1970) { (errorOrNil) in
            
            guard let block = completionBlock else { return }
            
            if let error = errorOrNil {
                
                XYLog.Log(msg: error.description, type: .Error, isNeedSave: false)
                block(error)
                
            }else{
                
                block(nil)
            }
        }
    }
    
    /**
     *    @description 删除指定msgId的数据
     *
     *    @param    msgId    msgId
     *
     *
     */
    class func Delete(msgId:String, completionBlock:CompletionElementBlockHandler<Error>?){
        
        XYWDBManager.delete(Table, conditioin: WCDB_XYLogMsg.Properties.msgId == msgId) { (errorOrNil) in
            
            guard let block = completionBlock else { return }
            
            if let error = errorOrNil {
                
                XYLog.Log(msg: error.description, type: .Error, isNeedSave: false)
                block(error)
                
            }else{
                
                block(nil)
            }
        }
    }
    
    // MARK: - Select
    class func Select(earlierDate eDate: Date) -> WCDB_XYLogMsg.ModelArray?{
        
        guard let models:[WCDB_XYLogMsg] = XYWDBManager.select(Table, conditioin: WCDB_XYLogMsg.Properties.dateSince1970 < eDate.timeIntervalSince1970, errorClosure: nil) else {
            
            return nil
        }
        
        guard models.isNotEmpty else{ return nil }
        
        return models
    }
    
    
    /**
     *    @description 查询指定msgId的数据
     *
     *    @param    msgId    msgId
     *
     *    @return   WCDB_XYLogMsg
     */
    class func Select(msgId:String) -> WCDB_XYLogMsg?{
        
        guard let models:[WCDB_XYLogMsg] = XYWDBManager.select(Table, conditioin: WCDB_XYLogMsg.Properties.msgId == msgId, errorClosure: nil) else {
            
            return nil
        }
        
        guard models.count <= 1 else{
            
            XYLog.Log(msg: "出现异常，查询结果出现多个！", type: .Warnning, isNeedSave: false)
            return nil
        }
        
        return models.first
    }
    
    /// 按时间顺序取所有日志数据
    class func SelectAll() -> WCDB_XYLogMsg.ModelArray? {
        
        guard let select = XYWTableName.logMsg.select?.order(by: WCDB_XYLogMsg.Properties.dateSince1970),
            let selectedAllObjects = try? select.allObjects(),
            let logMsgArr = selectedAllObjects as? WCDB_XYLogMsg.ModelArray else { return nil }
        
        return logMsgArr
    }
    
    
    
    
}
