//
//  BuildEnvironment.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/19.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - Project 各 Target 配置数据
var APP_CurrentTarget : APPProject_Target {
    
    return APPProject_Target.Xiyou
}

/// 工程打包产品
enum APPProject_Target : String, XYEnumTypeAllCaseProtocol {
    
    /// 视听说
    case ShiTingShuo = "视听说"
    
    /// 西柚英语
    case Xiyou = "西柚英语"
    
    /// App名称
    var appName : String {
        
        return self.rawValue
    }
    
    /**
     *    @description 公司名称
     *
     */
    var corporateName : String {
        
        switch self {
        case .ShiTingShuo: return "视听说团队"
        case .Xiyou: return "西柚英语团队"
        }
    }
    
    /// 资源后缀
    var resourceFooterTag : String {
        
        switch self {
        case .ShiTingShuo: return ""
        case .Xiyou: return "_XY"
        }
    }
    
    
    
    /**
     *    @description 获取对应工程图片资源的名称
     *
     *    @param    name    默认图片资源的名称
     *
     *    @return   对应工程图片资源的名称
     */
    func imageName(_ name: String) -> String {
    
        return "\(name)\(self.resourceFooterTag)"
    }
    
    func targetColorBy(_ otherOrNil: String?) -> XYColor.CustomColor? {
        
        if let text = otherOrNil?.lowercased(),
            (text == "main") ||
            ("24b32f" == text) ||
            ("ff24b32f" == text) {
            
            return XYColor.CustomColor.main
        }
        
        return nil
    }
    
    /**
     *    @description 根据Target筛选结果
     *
     */
    func filter<T>(sts: T, xy: T) -> T {
        
        switch self {
        case .ShiTingShuo: return sts
        case .Xiyou: return xy
        }
    }
    
    /**
     *    @description 根据Target执行
     *
     */
    func filter<T>(sts: ()->T, xy: ()->T) -> T {
        
        switch self {
        case .ShiTingShuo: return sts()
        case .Xiyou: return xy()
        }
    }
}

extension APPProject_Target {
    
    var belongOrNil: String? {
        return nil
//        switch self {
//        case .ShiTingShuo: return "0"
//        case .OQ: return nil
//        case .Xiyou: return "1"
//        }
    }
    
    var qq群: String {
        
        switch self {
        case .ShiTingShuo: return "386271347" // 1群:"679410705"
        case .Xiyou: return "721877016"
        }
    }
    
    var 客服电话分割: String {
        
        switch self {
        case .ShiTingShuo: return "400-128-1298"
        case .Xiyou: return "400-996-0201"
        }
    }
    
    var 客服电话: String {
        
        switch self {
        case .ShiTingShuo: return "4001281298"
        case .Xiyou: return "4009960201"
        }
    }
    
}

// MARK: - Universal Links
extension APPProject_Target {
    
    var universalLinks_HostOrNil: String? {
        
        switch self {
        case .ShiTingShuo: return nil
        case .Xiyou: return "xiyouyingyu.com"
        }
    }
    
    var universalLinks_PathOrNil: String? {
        
        switch self {
        case .ShiTingShuo: return nil
        case .Xiyou: return "openApp"
        }
    }
    
}
