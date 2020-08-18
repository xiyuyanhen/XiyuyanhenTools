//
//  XYBmobTools.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/7/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation
import RxCocoa

class XYBmobTools: XYObject {
    
    override init() {
        super.init()
        
        self.addInitObserver()
    }
    
    lazy var rxStatus: BehaviorRelay<Status> = {
        
        return BehaviorRelay<Status>(value: .未初始化)
    }()
}

extension XYBmobTools {
    
    /*
     应用密钥

     //Application ID，SDK初始化必须用到此密钥
     Application ID:  07eb42a701a4a233d96bad7aa6a17af0
     
     //REST API Key，REST API请求中HTTP头部信息必须附带密钥之一
     REST API Key:   d912d332e0197e1bc8277d98de3916f6
     
     //Secret Key，是SDK安全密钥，不可泄漏，在云函数测试云函数时需要用到
     Secret Key:     ebbca6a1f774492d
     
     //Master Key，超级权限Key。应用开发或调试的时候可以使用该密钥进行各种权限的操作，此密钥不可泄漏
     Master Key:     2adfc3ce91f81a3812eade2fb0f7920c
     
    */
    
    /// SDK初始化必须用到此密钥
    static var AppId: String {
        
        return "07eb42a701a4a233d96bad7aa6a17af0"
    }
    
    /// REST API请求中HTTP头部信息必须附带密钥之一
    static var RestAPIKey: String {
        
        return "d912d332e0197e1bc8277d98de3916f6"
    }
    
    /// SDK安全密钥，不可泄漏，在云函数测试云函数时需要用到
    static var SecretKey: String {
        
        return "ebbca6a1f774492d"
    }
    
    /// 超级权限Key。应用开发或调试的时候可以使用该密钥进行各种权限的操作，此密钥不可泄漏
    static var MasterKey: String {
        
        return "2adfc3ce91f81a3812eade2fb0f7920c"
    }
    
    // 开发文档地址 http://doc.bmob.cn/data/ios/swift_develop_doc/#_1
}

extension XYBmobTools {
    
    /// 向Bmob注册应用
    static func Register() {
        
        /// 触发懒加载方法，生成XYBmobTools对象与监听通知
        let _ = XYAppDataShare.Share.bmobTools
        
        Bmob.register(withAppKey: self.AppId)
    }
    
    /// 在应用进入前台时调用
    static func ActivateSDK() {
        
        Bmob.activateSDK()
    }
    
    private func addInitObserver() {
        
        LN_XYBmobTools.初始化成功.addObserver(self, selector: #selector(self.notificationHandle(notification:)))
        LN_XYBmobTools.初始化失败.addObserver(self, selector: #selector(self.notificationHandle(notification:)))
    }
    
    @objc private func notificationHandle(notification: Notification) {
        
        if LN_XYBmobTools.初始化成功.equal(notification: notification) {
            
            XYLog.LogNote(msg: "Bmob.初始化成功")
            
            self.rxStatus.accept(.准备就绪)
            
        }else if LN_XYBmobTools.初始化失败.equal(notification: notification) {
            
            var msg: String = "Bmob.初始化失败"
            
            if let userInfo = notification.userInfo {
                
                msg.append("\(userInfo)")
            }
                
            XYLog.LogNote(msg: msg)
            
            self.rxStatus.accept(.初始化失败)
        }
    }
    
    enum Status {
        case 未初始化
        case 初始化失败
        case 准备就绪
    }
}

/// Bmob初始化通知
fileprivate enum LN_XYBmobTools: XYLocationNotificationProtocol {
    
    case 初始化成功
    case 初始化失败
    
    func customName() -> NSNotification.Name? {
        
        switch self {
        case .初始化成功: return NSNotification.Name.bmobInitSuccess
        
        case .初始化失败: return NSNotification.Name.bmobInitFail
        }
    }
}
