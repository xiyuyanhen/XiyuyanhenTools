//
//  DebugToolsType.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/5/7.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

enum DebugToolsMainManagerType : XYEnumTypeAllCaseProtocol {
    case 日志
    case 测试
    case 其它
    
    var typesArr : [[DebugToolsType]] {
        
        var typesArr = [[DebugToolsType]]()
        
        switch self {
        case .日志:
            
            typesArr.append([DebugToolsType.重置调试工具权限])
            
            // 日志管理
            var logManagerArr = [DebugToolsType]()
            logManagerArr.append(DebugToolsType.调试悬浮窗)
            logManagerArr.append(DebugToolsType.日志管理)
            logManagerArr.append(DebugToolsType.查看日志)
            
            typesArr.append(logManagerArr)
    
            break
            
        case .测试:
            
            typesArr.append([DebugToolsType.测试A])
            
            break
            
        case .其它:
            
            typesArr.append([DebugToolsType.PGY, DebugToolsType.PGYIndex, DebugToolsType.设备推送Token, DebugToolsType.商店版本])
            
            var ossArr = [DebugToolsType]()
        
            ossArr.append(DebugToolsType.显示Document路径)
            typesArr.append(ossArr)
            
            var fakeAppVersionArr = [DebugToolsType]()
            fakeAppVersionArr.append(DebugToolsType.设置虚假的应用版本号)
            typesArr.append(fakeAppVersionArr)
            
            var resetRequestSchemeArr = [DebugToolsType]()
            resetRequestSchemeArr.append(DebugToolsType.重置网络请求地址)
            typesArr.append(resetRequestSchemeArr)
            
            var cacheClearArr = [DebugToolsType]()
            cacheClearArr.append(DebugToolsType.内存泄漏测试)
            cacheClearArr.append(DebugToolsType.内存使用参考)
            typesArr.append(cacheClearArr)
            
            typesArr.append([DebugToolsType.关闭应用])
            
            break
        }
        
        return typesArr
    }
    
}

enum DebugToolsType : XYEnumTypeAllCaseProtocol {
    
    case 重置调试工具权限
    
    case 调试悬浮窗
    
    case 日志管理
    case 查看日志
    
    case 设置虚假的应用版本号
    
    case 重置网络请求地址
    
    case 内存泄漏测试
    case 内存使用参考
    
    case 显示Document路径

    case 测试A
    
    case 注销
    case 隐私权政策
    
    case PGY
    case PGYIndex
    case 设备推送Token
    case 商店版本
    
    case 关闭应用
    
    var statusSwitchOrNil : Bool? {
        
        return nil

//        switch self {
//        case .能否快速浏览答案及试题数据: return DebugToolsManage.EnableQuickLookUpAnswer
//
//        case .是否显示旧首页: return DebugToolsManage.IsShowOldIndexPage
//
//        default: return nil
//
//        }
    }
    
}


