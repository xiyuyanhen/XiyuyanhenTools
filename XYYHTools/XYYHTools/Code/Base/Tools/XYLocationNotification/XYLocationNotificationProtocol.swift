//
//  XYLocationNotificationProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/3.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYLocationNotificationProtocol : XYEnumTypeAllCaseProtocol {
    
    /// 自定义通知名称
    func customName() -> NSNotification.Name?
}

extension XYLocationNotificationProtocol {
    
    /// 取通知中心的语法糖
    private static func LNCenter() -> NotificationCenter{
        
        let center = NotificationCenter.default
        
        return center
    }
    
    /**
     *    @description 生成对应的Notification对象
     *
     *    @param    object    接收通知的对象
     *
     *    @param    userInfo    传递的相关数据
     *
     *    @return   Notification
     */
    func newNotification(object anObjectOrNil: Any? = nil, userInfo aUserInfoOrNil: [AnyHashable : Any]? = nil) -> Notification {
        
        return Notification(name: self.name(), object: anObjectOrNil, userInfo: aUserInfoOrNil)
    }
    
    /**
     *    @description 发送通知消息
     *
     */
    func postNotification() {
        
        Self.LNCenter().post(name: self.name(), object: nil, userInfo: nil)
    }
    
    /**
     *    @description 发送通知消息
     *
     *    @param    userInfo    传递的相关数据
     *
     *    @param    object    接收通知的对象
     *
     */
    func postNotification(userInfo aUserInfo: [AnyHashable : Any], object anObject: Any? = nil) {
        
        Self.LNCenter().post(name: self.name(), object: anObject, userInfo: aUserInfo)
    }
    
    /**
    *    @description 发送通知消息
    *
    *    @param    observer    监听器
    *
    *    @param    aSelector    接到收通知后的处理函数
    *
    *    @param    object    接收通知的对象，需要与postNotification的object匹配，否则接收不到通知
    *
    */
    func addObserver(_ observer: Any, selector aSelector: Selector, object anObject: Any? = nil) {
        
        Self.LNCenter().addObserver(observer,
                                    selector: aSelector,
                                    name: self.name(),
                                    object: anObject)
    }
    
    /**
     *    @description 删除通知的监听器
     *
     *    @param    observer    监听器
     *
     *    @param    object    监听的通知的发送对象
     *
     */
    func removeObserver(_ observer: Any, object anObject: Any? = nil) {
        
        NotificationCenter.default.removeObserver(observer,
                                                  name: self.name(),
                                                  object: anObject)
    }
    
    /**
     *    @description  生成对应的通知名称
     *
     *    @return   NSNotification.Name
     */
    func name() -> NSNotification.Name {
        
        if let customName = self.customName() {
            
            return customName
        }
        
        let resultName = "XYNotificationName_\(self.enumName)_\(self.name)"
        
        return NSNotification.Name(rawValue: resultName)
    }
    
    /**
     *    @description 与通知名称是同价
     *
     *    @param    notificationName    通知名称
     *
     */
    func equal( notificationName: Notification.Name) -> Bool {
        
        return self.name() == notificationName
    }
    
    /**
    *    @description 与通知是否同价
    *
    *    @param    notification    通知
    *
    */
    func equal( notification notificationOrNil: Notification?) -> Bool {
        
        guard let notification = notificationOrNil else { return false }
        
        return self.equal(notificationName: notification.name)
    }
}

/*
struct XYLocationNotificationBag<N: XYLocationNotificationProtocol> {
    
    let notification: N
    var objectOrNil: Any? = nil
    
    init(notification: N, object: Any? = nil) {
        
        self.notification = notification
        self.objectOrNil = object
    }
}
*/
