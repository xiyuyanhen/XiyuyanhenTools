//
//  ProjectSetting.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/7/17.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

// Info.plist里增加一个键：UIFileSharingEnabled（Application supports iTunes file sharing），赋值YES 可以使用iTunes主用户上传和下载文档

import Foundation

class ProjectSetting : NSObject {
    
    /// Log信息打印默认操作
    static let LogPrintTarget: XYLogPrintTarget = XYLogPrintTarget.Console
    
    /// App接口全局域名 (默认值)
    var requestAddress: APP_RequestRootAddress = APP_RequestRootAddress.Development
    
    /// 打包环境
    static let BuildEnvironment: APPBuildEnvironment = APPBuildEnvironment.Development
    
    /// 单例模式
    private static let `default` = ProjectSetting()
    
    class func Share() -> ProjectSetting {
        
        let share:ProjectSetting = self.default
        
        return share
    }
    
    override private init() {
        
        super.init()
        
        XYLog.Share().printTarget = ProjectSetting.LogPrintTarget
        
        // 解析缓存的接口请求地址
//        if let addressStr = DebugToolsManage.RequestAddressOrNil,
//            addressStr.isNotEmpty {
//
//            if let scheme = APP_RequestRootAddress(rawValue: addressStr) {
//
//                self.requestAddress = scheme
//            }else {
//
//                APP_RequestRootAddress_Custom_SchemePath = addressStr
//                self.requestAddress = APP_RequestRootAddress.Custom
//            }
//        }
    }
    
    /// 当前工程与版本号对应关系
    lazy var currentAppVersionPair: AppVersionPair = { return AppVersionPair.NewByTarget() }()
    
}

// MARK: - Version
extension ProjectSetting {
    
    
}

extension ProjectSetting {
    
    
}

