//
//  BuglyManager.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/10/11.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

struct BuglyManager {
    
//    static func Start() {
//
//        let config = BuglyConfig()
////        config.delegate = self
//        config.version = ProjectSetting.Share().currentAppVersionPair.appVersionForDisplay()
//
//        /*  STS
//         com.xinqidian.aitingshuo
//         产品名称 : 英语视听说
//         App ID : c145641346
//         App Key : d8670e16-87e9-43a6-80c8-817d340d458a
//
//         */
//
//        /*  Qiming
//
//         com.xinqidian.hunanXunfeiQiming
//         产品名称 : HunanQiming
//         App ID : 0ff3e62753
//         App Key : 50c56dfc-fd5b-406a-a257-d20abca794f3
//
//         */
//
//        /* 西柚英语
//         com.zhongkexinsheng.xiyouyingyu
//         产品名称: 西柚英语
//         App ID: 6197b54b88
//         App Key: af41beac-ce5c-408f-a782-bfcce9e3083c
//        */
//
//        let appId: String
//
//        switch APP_CurrentTarget {
//        case .OQ: appId = "0ff3e62753"
//            break
//
//        case .ShiTingShuo: appId = "c145641346"
//            break
//
//        case .Xiyou: appId = "6197b54b88"
//            break
//        }
//
//        // 设置代理
//        config.delegate = APPDELEGATE
//
//        Bugly.start(withAppId: appId)
//    }
}

// MARK: - 自定义异常上报
extension BuglyManager {
    
    /**
    *    @brief 上报自定义错误
    *
    *    @param category    类型(Cocoa=3,CSharp=4,JS=5,Lua=6)
    *    @param aName       名称
    *    @param aReason     错误原因
    *    @param aStackArray 堆栈
    *    @param info        附加数据
    *    @param terminate   上报后是否退出应用进程
    */
    
    
    
    /// 上报错误
    static func ReportError(_ error: XYError, terminateApp: Bool = false) {
        
        /// 额外信息
        var extraInfo: [String : Any]
        if let errorUserInfo = error.userInfoOrNil {
            // 添加错误信息所携带的信息
            extraInfo = errorUserInfo
        }else {
            
            extraInfo = [String : Any]()
        }
        
//        if let userInfo = UserManage.UserInfoOrNil {
//            // 添加用户信息
//            extraInfo.xySetObject(userInfo.userId, forKey: "userId")
//
//            if let userName = userInfo.nameOrNil {
//
//                extraInfo.xySetObject(userName, forKey: "userName")
//            }
//        }
        
//        Bugly.reportException(withCategory: 3, name: "\(error.detailMsg)(\(error.code))", reason: error.reasonOrNil ?? "", callStack: [], extraInfo: extraInfo, terminateApp: false)
    }
    
}

extension BuglyManager {
    
    /// 退出App
    static func ExitApp(_ reason: String, dic dicOrNil: [String : Any]? = nil) {
        
        defer {
            
            // 二重退出机制，防止Bugly出现很久都没退出的情况
            XYDispatchQueueType.Main.after(time: 5.0) {
                
                XYExitApp(animated: false)
            }
        }
        
        /// 额外信息
        var extraInfo: [String : Any]
        if let dic = dicOrNil {
            // 添加错误信息所携带的信息
            extraInfo = dic
        }else {
            
            extraInfo = [String : Any]()
        }
        
//        if let userInfo = UserManage.UserInfoOrNil {
//            // 添加用户信息
//            extraInfo.xySetObject(userInfo.userId, forKey: "userId")
//
//            if let userName = userInfo.nameOrNil {
//
//                extraInfo.xySetObject(userName, forKey: "userName")
//            }
//        }
        
//        Bugly.reportException(withCategory: 3, name: "用户退出应用", reason: reason, callStack: [], extraInfo: extraInfo, terminateApp: true)
        
        guard let window = AppDelegate.AppWindow else {
            
            XYLog.LogWarnning(msg: "退出App -- 无法获取APPKEYWINDOW")
            return
        }
        
        // 一秒黑屏动画
        UIView.animate(withDuration: 1.0, animations: {
            
            window.setAlpha(0.0)
        }) { (finished) in
            
            
        }
    }
    
    /// 退出App，前往更新
    static func ExitAppForUpdate(dic dicOrNil: [String : Any]? = nil) {
        
        self.ExitApp("前往商店更新应用", dic: dicOrNil)
    }
}


// MARK: - AppDelegate - 代理
//extension AppDelegate: BuglyDelegate {
//
//    /**
//    *  发生异常时回调
//    *
//    *  @param exception 异常信息
//    *
//    *  @return 返回需上报记录，随异常上报一起上报
//    */
//    func attachment(for exception: NSException?) -> String? {
//
//        if let except = exception {
//
//            var msg: String = "exception.name: \(except.name)"
//
//            if let reason = except.reason {
//
//                msg += "\nexception.reason\(reason)"
//            }
//
//            if let userInfo = except.userInfo {
//
//                msg += "\nexception.userInfo\(userInfo)"
//            }
//
//            msg += "\nexception.callStackReturnAddresses\(except.callStackReturnAddresses)"
//
//            msg += "\nexception.callStackSymbols\(except.callStackSymbols)"
//
//            XYLog.LogError(msg: msg, mark: "BuglyDelegate.attachment(_)")
//        }
//
//        return nil
//    }
//}
