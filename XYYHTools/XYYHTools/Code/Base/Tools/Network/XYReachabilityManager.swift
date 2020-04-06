//
//  ReachabilityManage.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/6/15.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class XYReachabilityManager: NSObject {
    
    //单例
    static private let `default` = XYReachabilityManager()
    
    public class func Share() -> XYReachabilityManager{
        
        let manager:XYReachabilityManager = self.default
        
        return manager;
    }
    
    override private init() {
        
        super.init();
    }
    
    private lazy var hostReachabilityOrNil : Reachability? = {
        
        let reachability : Reachability
        
        if let reach = Reachability(hostname: "www.baidu.com") {
            
            reachability = reach
        }else if let reach = Reachability(hostname: "http://www.qq.com/") {
            
            reachability = reach
        }else {
            
            return nil
        }
        
        return reachability
    }()

//    static let kChangedNotificationName = Notification.Name.reachabilityChanged
    
    public func setups() {
        
        guard let hostReachability = self.hostReachabilityOrNil else { return }
        
        weak var weakSelf = self
        
        hostReachability.whenReachable = {
            reachability in

            weakSelf?.connectionStateChangedHandle(reachability: reachability)
        }

        //断开连接
        hostReachability.whenUnreachable = {
            reachability in

            weakSelf?.connectionStateChangedHandle(reachability: reachability)
        }
        
        do {
            //启动监听
            try hostReachability.startNotifier();

        }catch let error {
            
            DebugNote(tip: "ReachabilityManager: 无法启动监听(\(error.localizedDescription))")
        }
    }
    
    private func connectionStateChangedHandle(reachability : Reachability) {
        
        XYLog.Log(msg: "ReachabilityManager: 网络连接状态改变(new connection: \(reachability.connection.description))")
        
        
        
    }
    
    /**
     *    @description 获取当前网络状态
     *
     */
    public var connection:Reachability.Connection {
        
        guard let hostReachability = self.hostReachabilityOrNil else { return Reachability.Connection.none }
        
        return hostReachability.connection
    }
    
    static func IsCanReachability() -> Bool {
        
        let connection = self.Share().connection
        
        return connection != .none
    }
}

// MARK: - VPN检查
extension XYReachabilityManager {
    
    /// 获取网络设置参数
    static var CopySystemProxySettingsDicOrNil: Dictionary<String, Any>? {
        
        return CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>
    }
    
    /**
     *    @description 是否连接VPN
     *
     *    @param    settingsDicOrNil    网络设置参数
     *
     *    @return   Bool
     */
    static func IsConnectingVPN(_ settingsDicOrNil: Dictionary<String, Any>? = nil) -> Bool {
        
        let settingsDic: Dictionary<String, Any>
        
        if let dic = settingsDicOrNil {
            
            settingsDic = dic
            
        }else if let dic = self.CopySystemProxySettingsDicOrNil {
            
            settingsDic = dic
        }else {
            
            return false
        }
        
        guard let scopedDic: NSDictionary = settingsDic.xyObject("__SCOPED__") else { return false }
        
        for scopedKey in scopedDic.allKeys {
            
            guard let key = scopedKey as? String,
                key.lowercased().contains(strArr: ["tap", "tun", "ipsec", "ppp"]) else { continue }
            
            // 插入日志，以防出现问题好排查
            XYLog.LogError(msg: "疑似连接了VPN key:\(key) scopedDic:(\(scopedDic)", mark: "VPN")
            
            // 连接了VPN
            return true
        }
        
        // 未连接VPN
        return false
    }
    
    /**
     *    @description 是否使用了网络代理
     *
     *    @param    settingsDicOrNil    网络设置参数
     *
     *    @return   Bool
     */
    public static func IsUsedProxy(_ settingsDicOrNil: Dictionary<String, Any>? = nil) -> Bool {
    
        let settingsDic: Dictionary<String, Any>
        
        if let dic = settingsDicOrNil {
            
            settingsDic = dic
            
        }else if let dic = self.CopySystemProxySettingsDicOrNil {
            
            settingsDic = dic
        }else {
            
            return false
        }
        
        // 有时候未设置代理dictionary也不为空，而是一个空字典
        
        guard let proxyDic: NSDictionary = settingsDic.xyObject("HTTPProxy"),
            proxyDic.isNotEmpty else { return false }

        // 插入日志，以防出现问题好排查
        XYLog.LogError(msg: "疑似使用了网络代理 HTTPProxy:(\(proxyDic)", mark: "HTTPProxy")
        
        // 使用了网络代理
        return true
    }
    
    /// 限制VPN或代理连接
    static func LimitUserForConnectingVPNOrProxy() {
        
        guard let settings = self.CopySystemProxySettingsDicOrNil,
            self.IsConnectingVPN(settings) || self.IsUsedProxy(settings) else { return }
        
        ShowNormalAlertView(title: "网络安全提醒", message: "当前网络使用了代理模式，存在安全风险，请关闭代理模式后使用本应用", comfirmTitle: "已经关闭", cancelTitle: "退出应用", comfirmBtnBlock: { (comfirmAction) in
            
            self.LimitUserForConnectingVPNOrProxy()
            
        }) { (abortAction) in
                
            // 退出App
            BuglyManager.ExitApp("网络安全问题退出")
        }
        
    }
}


