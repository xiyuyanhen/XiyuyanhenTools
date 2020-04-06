//
//  XYNotificationManage.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/7/4.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

enum XYNotificationKey : String {
    
    case PracticeResource_Download = "PracticeResource_download"

    case PracticeResource_QuickLookUpAnswer = "PracticeResource_QuickLookUpAnswer"
    
    case Homework_ItemStatusCellHandle = "Homework_ItemStatusCellHandle"
}

func XYNotificationName(key:XYNotificationKey) -> NSNotification.Name{
    
    let frontPart = "XYNotificationName_"
    
    let resultName = frontPart+key.rawValue
    
    return NSNotification.Name(rawValue: resultName)
}

struct XYNotificationCenter {

    static let Center = NotificationCenter.default
    
    static func PostNotification(key: XYNotificationKey, object anObject: Any? = nil, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        
        let notificationName = XYNotificationName(key: key)
        
        self.PostNotification(name: notificationName, object: anObject, userInfo: aUserInfo)
    }
    
    static func PostNotification(name: NSNotification.Name, object anObject: Any? = nil, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        
        self.Center.post(name: name, object: anObject, userInfo: aUserInfo)
    }
    
}
