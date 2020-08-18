//
//  XYBmobDemo.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/8/18.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

struct XYBmobDemo {
    
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

