//
//  APPInfo.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/29.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

//MARK: - APPInfo
struct APPInfo {
    
    static var AppInfo:[String : Any]? {
        
        let infoDic = XYBundle.Main.infoDictionary
        
        return infoDic
    }
    
    /**
     *    @description 程序名称
     *
     */
    static func AppDisplayName() -> String {
        
        guard let name = self.AppInfo?["CFBundleDisplayName"] as? String else {
            
            return ""
        }
        
        return name
    }
    
    /**
     *    @description 主程序版本号
     *
     */
    static func AppMajorVersion() -> String {
    
        guard let version = self.AppInfo?["CFBundleShortVersionString"] as? String else {
            
            return ""
        }
        
        return version
    }
    
    /**
     *    @description 版本号（内部标示）
     *
     */
    static func AppMinorVersion() -> String {
        
        guard let version = self.AppInfo?["CFBundleVersion"] as? String else {
            
            return ""
        }
        
        return version
    }
    
}
