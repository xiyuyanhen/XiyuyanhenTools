//
//  APP_RequestRootAddress.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/2/10.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

/// 自定义接口地址
var APP_RequestRootAddress_Custom_SchemePath : String = ""

/// App主要接口地址
enum APP_RequestRootAddress : String, XYEnumTypeAllCaseProtocol {
    case Development = "测试环境"
    case Production = "正式环境"
    case Production_Reserve = "正式环境_备用"
    case JunBo = "俊波"
    case 振东 = "振东"
    case 建鹏 = "建鹏"
    case Custom = "自定义"
    
    var name : String {
        
        return self.rawValue
    }
    
    var schemePath : String {
    
        switch self {
        case .Custom: return  APP_RequestRootAddress_Custom_SchemePath
            
        default: return "http://testmini.sts100.com"
        }
    }
}
