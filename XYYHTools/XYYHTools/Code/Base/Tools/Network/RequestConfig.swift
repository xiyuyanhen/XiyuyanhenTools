//
//  RequestConfig.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/2/10.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

/// 接口请求配置
class RequestConfig: XYObject {
    
    /// 接口请求头
    var scheme: String
    
    /// 路径
    var path: String
    
    /// 实际请求参数
    var parametersOrNil: XYNetWorkManage.XYParameters?
    
    /// 请求时显示动画的视图 (默认显示在顶层视图)
    var progressHudViewOrNil: UIView? = ProgressHudView
    
    /// 是否默认添加用户信息
    var needUserMsg: Bool = true
    
    /// 接口是否缓存
    var needCache: Bool = false
    
    /// 是否自动处理一些公共问题，比如网络异常的提示，重新登录
    var autoHandle: Bool = true
    
    /// 请求记录
    var requestLog: String = ""
    
    init(scheme: String,
         path: String,
         parametersOrNil: XYNetWorkManage.XYParameters? = nil) {
        
        self.scheme = scheme
        self.path = path
        self.parametersOrNil = parametersOrNil
        
        super.init()
    }
}

extension RequestConfig {
    
    convenience init(address: APP_RequestRootAddress,
         path: String,
         parametersOrNil: XYNetWorkManage.XYParameters? = nil) {
        
        self.init(scheme: address.schemePath, path: path, parametersOrNil: parametersOrNil)
    }
    
    convenience init(address: APP_RequestRootAddress,
         url: RequestUrlProtocol,
         parametersOrNil: XYNetWorkManage.XYParameters? = nil) {
        
        self.init(scheme: address.schemePath, path: url.path, parametersOrNil: parametersOrNil)
    }
    
    /// 根据所提供的接口，使用全局域名请求数据
    convenience init(url: RequestUrlProtocol,
         parametersOrNil: XYNetWorkManage.XYParameters? = nil) {
        
        
         
        self.init(scheme: url.schemeOrNil ?? ProjectSetting.Share().requestAddress.schemePath, path: url.path, parametersOrNil: parametersOrNil)
    }
}

extension RequestConfig {
    
    /// 设置请求接口的scheme
    @discardableResult func setScheme(_ scheme: String) -> RequestConfig {
        
        self.scheme = scheme
        
        return self
    }
    
    /// 设置请求动画视图窗口
    @discardableResult func setHudView(_ hudViewOrNil: UIView?) -> RequestConfig {
        
        self.progressHudViewOrNil = hudViewOrNil
        
        return self
    }
    
}

extension RequestConfig {
    
    /// 请求地址
    var requestUrl: String {
        
        return "\(self.scheme)\(self.path.isNotEmpty.xyReturn("/\(self.path)", ""))"
    }
}

extension RequestConfig {
    
    func get(completionHandler: @escaping XYNetWorkManage.RequestCompletionHandler) {
        
        XYNetWorkManage.Get(self, completionHandler: completionHandler)
    }
    
    func post(completionHandler: @escaping XYNetWorkManage.RequestCompletionHandler) {

        XYNetWorkManage.Post(self, completionHandler: completionHandler)
    }
}
