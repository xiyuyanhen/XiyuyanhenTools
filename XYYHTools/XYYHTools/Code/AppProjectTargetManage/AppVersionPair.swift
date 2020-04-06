//
//  AppVersionPair.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/6.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

extension AppVersionPair {
    
    static func NewByTarget() -> AppVersionPair {
        
        var newValue = AppVersionPair()
        
        switch newValue.buildTarget {
        case .ShiTingShuo:
            
            break
        
        case .Xiyou:
            
            break
        }
        
        return newValue
    }
}

/// 版本号对应关系
struct AppVersionPair {
    
    /// 工程版本号
    let targetVersion: String
    
    /// 匹配的版本号
    var pairVersionOrNil: String?
    
    /// 内部标识版本号(第四位)
    var minorVersionOrNil: String? { return APPInfo.AppMinorVersion() }
    
    init(targetVersion: String = APPInfo.AppMajorVersion(), pairVersion pairVersionOrNil: String? = nil) {
        
        self.targetVersion = targetVersion
    
        self.pairVersionOrNil = pairVersionOrNil
    }
    
    /// 版本号 (优先取pair，没有就取target)
    var versionByPair: String {
        
        guard let pair = self.pairVersionOrNil,
            pair.isNotEmpty else { return self.targetVersion }
        
        return pair
    }
    
    /// Build工程
    var buildTarget: APPProject_Target { return APP_CurrentTarget }
    
    /// 上传服务器接口的版本号
    var appVersionForService: String {
        
        switch self.buildTarget {
        case .ShiTingShuo, .Xiyou: return self.versionByPair
        }
    }

    /// 对外显示的版本号
    func appVersionForDisplay(addMinor: Bool = false) -> String {
        
        var version : String = APPInfo.AppMajorVersion()
        
        switch self.buildTarget {
        case .ShiTingShuo:
            
            version = self.versionByPair
            
            break
        
        case .Xiyou:
            
            version = self.targetVersion
            
            break
        }
        
        /// 添加内部版本号
        if addMinor,
            let minorVersion = self.minorVersionOrNil {
            
            version = "\(version).\(minorVersion)"
        }
        
        return version
    }
}
