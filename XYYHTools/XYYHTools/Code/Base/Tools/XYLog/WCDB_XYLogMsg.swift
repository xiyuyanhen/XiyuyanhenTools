//
//  WCDB_XYLogMsg.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/24.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class WCDB_XYLogMsg: NSObject, ModelProtocol_Array {
    
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
}

extension WCDB_XYLogMsg {
    
    //默认保留3天的日志
    static var DefaultClearHours : Float { return 24 * 3 }
    
    static func ClearEarlierMsg(hours: Float = WCDB_XYLogMsg.DefaultClearHours) {
        
        let newDateTimeInterval = Date().timeIntervalSince1970
        
        let earlierTimeInterval : TimeInterval = TimeInterval(hours * 3600)
        
        let earlierDate = Date(timeIntervalSince1970: newDateTimeInterval - earlierTimeInterval)
        
//        self.Delete(earlierDate: earlierDate, completionBlock: nil)
    }
}
