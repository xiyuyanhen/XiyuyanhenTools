
//
//  XYLog.swift
//  XYStudio
//
//  Created by Xiyuyanhen on 2017/8/8.
//  Copyright © 2017年 XyyH. All rights reserved.
//

import Foundation
import Alamofire

extension XYLog {
    
    /**
     *    @description 用于打印Note级别的调试信息 (仅用于输出简单的调试信息)
     *
     *    @param    msg    调试信息
     *
     *    @param    active    活跃状态
     *
     */
    static func LogNote(msg: String,
                        active: Bool = true,
                        _ file: String = #file,
                        _ function:String = #function,
                        _ line:Int = #line) {
        
        #if DEBUG
        
        guard active else { return }
        
        self.Log(msg: msg, type: XYLogType.Note, isNeedSave: false, file, function, line)
        
        #else
        #endif
    }
    
    /**
     *    @description 用于打印Note级别的调试信息 (若调试信息的生成需要耗费算力，应使用该方法，以避免在正式使用时的算力浪费)
     *
     *    @param    msgBlock    生成调试信息的代码块
     *
     *    @param    active    活跃状态
     *
     */
    static func LogNoteBlock(_ file: String = #file,
                        _ function:String = #function,
                        _ line:Int = #line,
                        active: Bool = true,
                        msgBlock: CompletionReturnValueBlock<String>) {
        
        #if DEBUG
        
        guard active,
            let msg = msgBlock() else { return }
        
        self.Log(msg: msg, type: XYLogType.Note, isNeedSave: false, file, function, line)
        
        #else
        #endif
        
    }
    
}

extension XYLog {
    
}

extension XYLog {
    
    /**
     *    @description 用于打印函数名信息
     *
     *
     */
    static func LogFunction(_ file : String = #file,
                            _ function:String = #function,
                            _ line:Int = #line) {
        
        #if DEBUG
        
        self.Log(msg: "", type: .Function, isNeedSave: false, file, function, line)
        
        #else
        #endif
    }
    
    /**
     *    @description 用于打印Request级别的调试信息
     *
     *    @param    msg    调试信息
     *
     */
    @discardableResult static func LogRequest(msg: String,
                           mark: String,
                        _ file: String = #file,
                        _ function:String = #function,
                        _ line:Int = #line) -> WCDB_XYLogMsg {
        
        return self.Log(msg: msg,
                        type: XYLogType.Request,
                        mark: mark,
                        isNeedSave: true,
                        file,
                        function,
                        line)
    }
    
    /**
     *    @description 用于打印Warnning级别的调试信息
     *
     *    @param    msg    调试信息
     *
     */
    @discardableResult static func LogWarnning(msg: String,
                        mark markOrNil: String? = nil,
                        _ file: String = #file,
                        _ function:String = #function,
                        _ line:Int = #line) -> WCDB_XYLogMsg {
        
        return self.Log(msg: msg,
                type: XYLogType.Warnning,
                mark: markOrNil,
                isNeedSave: true,
                file,
                function,
                line)
    }
    
    /**
     *    @description 用于打印Error级别的调试信息
     *
     *    @param    msg    调试信息
     *
     */
    @discardableResult static func LogError(msg: String,
                        mark markOrNil: String? = nil,
                        _ file: String = #file,
                        _ function:String = #function,
                        _ line:Int = #line) -> WCDB_XYLogMsg {
        
        return self.Log(msg: msg,
                type: XYLogType.Error,
                mark: markOrNil,
                isNeedSave: true,
                file,
                function,
                line)
    }
    
    /**
     *    @description 用于记录用户关键动作的日志信息(Warnning)
     *
     *    @param    msg    调试信息
     *
     */
    @discardableResult static func LogUserAction(msg: String,
                                              _ file: String = #file,
                                              _ function:String = #function,
                                              _ line:Int = #line) -> WCDB_XYLogMsg {
        
        return self.Log(msg: msg,
                        type: XYLogType.Warnning,
                        mark: "用户关键动作",
                        isNeedSave: true,
                        file,
                        function,
                        line)
    }
    
    /**
     *    @description 用于打印所有类型的调试信息
     *
     *    @param    msg    调试信息
     *
     *    @param    type    调试信息等级
     *
     */
    @discardableResult static func Log(msg: String,
                    type: XYLogType = .Debug,
                    mark markOrNil: String? = nil,
                    isNeedSave: Bool = true,
                    _ file: String = #file,
                    _ function: String = #function,
                    _ line: Int = #line) -> WCDB_XYLogMsg {
        
        let logMsg = WCDB_XYLogMsg(msg: msg, type: type, file, function, line)
        
        logMsg.markOrNil = markOrNil
        
        self.HandleMsg(logMsg: logMsg, isNeedSave: isNeedSave)
        
        return logMsg
    }
    
}

class XYLog : NSObject {
    
    static func HandleMsg(logMsg: WCDB_XYLogMsg, isNeedSave: Bool = true) {
        
        self.Share().handleMsg(logMsg: logMsg, isNeedSave: isNeedSave)
    }
    
    func handleMsg(logMsg: WCDB_XYLogMsg, isNeedSave: Bool = true) {
        
        defer {
            
            if isNeedSave,
                XYLogType.Debug.level <= logMsg.type.level {
                
//                XYDispatchQueueType.Public.xyAsync {
//                    
//                    logMsg.insertOrReplace()
//                }
            }
        }
        
        guard self.printTarget != .None else { return }
        
        self.printLog(logMsg)
    }
    
    private func printLog(_ logMsg: WCDB_XYLogMsg) {
        
        switch self.printTarget {
            
        case .None: return
            
        case .Console:
            
            //标准输出
            print(logMsg.outMsg)
            
            break
            
        case .LogFile:
            
            //输出到重定向文件
            
            //msg添加html标签
            let newLogMsg = XYLog.AddHtmlLabel(logMsg)
            
            //log输出路径
            let logFilePath = XYLog.PrintOutLogToDocumentPath
            
            //输出msg到指定路径
            freopen(logFilePath.cString(using: .ascii), "a+", stdout)
            
            print(newLogMsg)
            
            fclose(stdout)
            //关闭文件
            
            break
            
        case .Network:
            
            //msg添加html标签
            //            logMsg = XYLog.AddHtmlLabel(logMsg, type: type)
            
            let url = self.networkLogRequestHost+self.networkLogRequestPath
            
            let dataRequest:DataRequest =  SessionManager.default.request(url, method: HTTPMethod.get, parameters: ["msg":logMsg, "type": logMsg.typeRaw], encoding: URLEncoding.default, headers: nil)
            
            dataRequest.responseData(queue: nil) { (dataResponse) in
                
                guard let data = dataResponse.value,
                    let resultDic = NSDictionary.CreateWith(jsondata: data),
                    let status = resultDic.object(forKey: "status") as? String,
                    status == "11" else {
                        
                    debugPrint(dataResponse.result)
                    return
                }
            }
            
            break
        }
    }
    
    
    static let PrintOutLogToDocumentPath = LogFilePath(toDocumentPath: "XYLog.log")
    static let PrintErrLogToDocumentPath = LogFilePath(toDocumentPath: "XYLogErr.log")
    
    class func Share() -> XYLog{
        
        let log:XYLog = XYLog.default
        
        return log
    }
    
    // MARK: - 默认输出目标
    private var _printTarget : XYLogPrintTarget = XYLogPrintTarget.Console
    var printTarget : XYLogPrintTarget {
        
        get {
            
            return self._printTarget
        }
        
        set {
            
            guard self._printTarget != newValue else { return }
            
            self._printTarget = newValue
            
            self.printOutSetting(printTarget: newValue)
        }
    }
    
    // MARK: - 默认网络输出地址
    var networkLogRequestHost : String = "http://192.168.43.195:8067"
    var networkLogRequestPath : String = "/AppLog/log"
    
    //单例
    static private let `default` = XYLog()
    
    override private init() {
        
        super.init()
        
        self.printOutSetting(printTarget: self.printTarget)
    }
    
    private func printOutSetting(printTarget : XYLogPrintTarget) {
        
        switch printTarget {
            
        case .None: return
            
        case .Console:
            
            
            break
            
        case .LogFile:
            
            let defaultManager = FileManager.default
            
            //先删除已经存在的App错误警告输出文件
            let logErrFilePath = XYLog.PrintErrLogToDocumentPath
            try? defaultManager.removeItem(atPath: logErrFilePath)
            
            // 将log输入到文件
            freopen(logErrFilePath.cString(using: .ascii), "w", stderr) //app错误警告输出
            
            //先删除已经存在的通用Log输出文件
            let logOutFilePath = XYLog.PrintOutLogToDocumentPath
            try? defaultManager.removeItem(atPath: logOutFilePath)
            
            print("ErrFilePath:\(logErrFilePath)\nLogFilePath:\(logOutFilePath)")
            
            break
            
        case .Network:
            
            
            
            break
        }
    }
    
    
    
    /**
     *    @description 生成输出Log文件的路径
     *
     *    @param    fileName    Log文件名
     *
     *    @return   输出Log文件的路径
     */
    private class func LogFilePath(toDocumentPath fileName: String) -> String {
        
        //Document Path
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        
        //        let desktopPath = "/Users/Xiyuyanhen/Desktop/AppLog"
        
        let filePath = documentPath.appending("/\(fileName)")
        
        return filePath
    }
    
    // !!! Markdown
    private class func AddHtmlLabel(_ logMsg: WCDB_XYLogMsg) -> String {
        //    <font color=#0099ff size=3 face="黑体">color=#0099ff size=72 face="黑体"</font>
        
        let textColor = self.HtmlColor(type: logMsg.type)
        let textSize = "3"
        let textFont = "STCAIYUN" //华文彩云
        
        var fontHead: String
        switch logMsg.type {
        case .Error, .Warnning, .Request, .Debug, .Note, .Brief, .Function:
            fontHead = "<font color=\(textColor) size=\(textSize) face=\"\(textFont)\">"
            break
        }
        
        let fontEnd = "</font>"
        let lineBreak = "</br>"
        
        return "\(fontHead)\(logMsg.outMsg)\(fontEnd)\(lineBreak)"
    }
    
    private class func HtmlColor(type: XYLogType) -> String {
        
        let textColor : String
        
        switch type {
            
        case .Error:
            textColor = "#CD2626"
            break
            
        case .Warnning:
            textColor = "#ffff33"
            break
        
        case .Request, .Debug, .Note, .Brief, .Function:
            textColor = "#ffffff"
            break
        }
        
        return textColor
    }
}



