//
//  AppTabbarItemTag.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/19.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

enum AppTabbarItemTag : Int, XYEnumTypeAllCaseProtocol {
    
    case 作业     = 0
    case 浏览器     = 2
    case 用户中心  = 3
    
    var isNeedShow : Bool {
        switch self {
        case .作业: return true
        case .浏览器: return true
        case .用户中心: return true
        }
    }
    
    var title : String {
        
        switch self {
        case .作业:
            
            return "作业"
            
        case .浏览器:
            
            return "浏览器"
            
        case .用户中心:
            
            return "我的"
        }
    }
    
    // 默认状态、选中状态
    typealias ImageNames = (nImgName : String, sImgName : String)
    typealias Images = (nImg : UIImage?, sImg : UIImage?)
    
    var imageNames : ImageNames {
        
        let normalImgName : String
        let selectImgName : String
        
        let tag : String = APP_CurrentTarget.resourceFooterTag
        
        switch self {
        case .作业:
            
            normalImgName = "Tabbar_Item_作业\(tag)"
            selectImgName = "Tabbar_Item_作业_Selected\(tag)"
            
            break
            
        case .浏览器:
            
            normalImgName = "Tabbar_Item_班级\(tag)"
            selectImgName = "Tabbar_Item_班级_Selected\(tag)"
        
            break
            
        case .用户中心:
            
            normalImgName = "Tabbar_Item_用户中心\(tag)"
            selectImgName = "Tabbar_Item_用户中心_Selected\(tag)"
            
            break
        }
        
        return (normalImgName, selectImgName)
    }
    
    var images : Images {
        
        let imgNames = self.imageNames
        
        return (UIImage(xyImgName: imgNames.nImgName), UIImage(xyImgName: imgNames.sImgName))
    }
    
    var isNavigationBarHidden : Bool {
        
        switch self {
        case .作业, .浏览器, .用户中心: return false
        }
    }
    
}
