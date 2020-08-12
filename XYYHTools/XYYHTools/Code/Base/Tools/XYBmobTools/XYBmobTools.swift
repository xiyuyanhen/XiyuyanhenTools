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

extension XYBmobTools {
    
    /*  http://doc.bmob.cn/data/ios/develop_doc/  */
    
    /*
     
     在运行以上代码时，如果服务器端你创建的应用程序中已经存在GameScore数据表和相应的score、playerName、cheatMode等字段，那么你此时添加的数据和数据类型也应该和服务器端的表结构一致，否则将保存数据失败。
     
     如果服务器端不存在GameScore数据表，那么Bmob将根据你第一次(也就是运行的以上代码)保存的GameSocre对象在服务器为你创建此数据表并插入相应数据。
     
     每个BmobObject对象有几个默认的键(数据列)是不需要开发者指定的，objectId是每个保存成功数据的唯一标识符。createAt和updateAt代表每个对象(每条数据)在服务器上创建和最后修改的时间。这些键 (数据列)的创建和数据内容是由服务器端来完成的。
     
     在 [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error)中，成功创建后，error返回的是nil，可以通过 error.localizedDescription 查看返回的错误信息，之后的类似于 xxInBackground 中的error也是一样的结构。
     
     objectId，updatedAt，createdAt这些系统属性在调用创建函数（saveInBackground）的时候不需要进行设置，创建成功后，会返回objectId，updatedAt，createdAt。
     */
    
    /// 添加一条Test数据(测试)
    static func AddTestObject() {
        
        if let newObj = BmobObject(className: "Test") {
            
            XYLog.LogNote(msg: "will save objectId: \(newObj.objectId)")
            
            newObj.setObject("测试数据2A", forKey: "name")
            
//            newObj.deleteInBackground { (isSuccessful, errorOrNil) in
//
//                if isSuccessful {
//
//                    XYLog.LogNote(msg: "删除对象成功")
//
//                }else if let error = errorOrNil {
//
//                    let xyError = XYError(error: error)
//
//                    XYLog.LogNote(msg: "删除对象失败, code: \(xyError.code) msg: \(xyError.detailMsg)")
//                }else {
//
//                    XYLog.LogNote(msg: "删除对象失败, 未知错误")
//                }
//            }
            
            newObj.saveInBackground(resultBlock: { [weak newObj] (isSuccessful, errorOrNil) in

                if isSuccessful {
                    
                    if let weakObje = newObj {
                        
                        //创建成功后会返回objectId，updatedAt，createdAt等信息
                        
                        XYLog.LogNote(msg: "saved objectId: \(weakObje.objectId)")
                    }
                    
                    XYLog.LogNote(msg: "保存对象成功")

                }else if let error = errorOrNil {

                    let xyError = XYError(error: error)

                    XYLog.LogNote(msg: "保存对象失败, code: \(xyError.code) msg: \(xyError.detailMsg)")
                }else {

                    XYLog.LogNote(msg: "保存对象失败, 未知错误")
                }
            })
            
//            newObj.updateInBackground { (isSuccessful, errorOrNil) in
//
//                if isSuccessful {
//
//                    XYLog.LogNote(msg: "更新对象成功")
//
//                }else if let error = errorOrNil {
//
//                    let xyError = XYError(error: error)
//
//                    XYLog.LogNote(msg: "更新对象失败, code: \(xyError.code) msg: \(xyError.detailMsg)")
//                }else {
//
//                    XYLog.LogNote(msg: "更新对象失败, 未知错误")
//                }
//            }
        }
        
        
//        if let obj = BmobObject(outDataWithClassName: "Test", objectId: "Test00001") {
//
//            obj.saveInBackground(resultBlock: { (isSuccessful, errorOrNil) in
//
//                if isSuccessful {
//
//                    XYLog.LogNote(msg: "保存对象成功")
//
//                }else if let error = errorOrNil {
//
//                    let xyError = XYError(error: error)
//
//                    XYLog.LogNote(msg: "保存对象失败, code: \(xyError.code) msg: \(xyError.detailMsg)")
//                }else {
//
//                    XYLog.LogNote(msg: "保存对象失败, 未知错误")
//                }
//            })
//
//        }else {
//
//            XYLog.LogNote(msg: "创建对象失败")
//        }
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
