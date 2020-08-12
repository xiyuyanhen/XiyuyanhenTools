//
//  DebugToolsManage.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/13.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DebugToolsManage : NSObject {
    
    //单例
    private static let `default` = DebugToolsManage()
    
    class func Share() -> DebugToolsManage{
        
        let share:DebugToolsManage = self.default
        
        return share
    }
    
    override private init() {
        
        super.init()
    }
    
    private var cache : DebugToolsManageCache {
        
        get{
            
            guard let cacheByRead = DebugToolsManageCache.Read() else {
                
                let newCache = DebugToolsManageCache()
                
                newCache.save()
                
                return newCache
            }
            
            return cacheByRead
        }
        
        set {
            
            newValue.save()
        }
    }
    
    static func ClearCache() {
        
        DebugToolsManageCache.Clear()
    }
    
    /// 内存泄漏统计参考
//    lazy var rxObjecRetainCount: BehaviorRelay<UInt> = {
//
//        return BehaviorRelay<UInt>(value: 0)
//    }()
    
    /// 内存泄漏统计参考
    lazy var objectRetainCountDic: [String: UInt] = {
        
        return [String: UInt]()
    }()
}

/// 内存泄漏统计参考
extension DebugToolsManage {
    
    static var ObjecRetainCount: UInt {
        
        var count: UInt = 0
        
        for name in self.Share().objectRetainCountDic.keys {
            
            guard let dicCount: UInt = self.Share().objectRetainCountDic.xyObject(name) else { continue }
            
            count += dicCount
        }
        
        return count
    }
    
    static var ObjecRetainCountText: String {
        
        var result: String = ""
        
        for name in self.Share().objectRetainCountDic.keys {
            
            guard let count: UInt = self.Share().objectRetainCountDic.xyObject(name) else { continue }
            
            let nameCount: String = "\(name): \(count)"
            
            result = result.isEmpty.xyReturn(nameCount, "\(result)\n\(nameCount)")
        }
        
        return result
    }
    
    @discardableResult static func AddForObjectRetain(_ name: String) -> UInt {
        
        var count: UInt
        
        if let oCount: UInt = self.Share().objectRetainCountDic.xyObject(name) {
            
            count = oCount
        }else {
            
            count = 0
        }
        
        count += 1
        
        self.Share().objectRetainCountDic.xySetObject(count, forKey: name)
        
        return count
    }
    
    @discardableResult static func ReduceForObjectRetain(_ name: String) -> UInt {
        
        var count: UInt
        
        if let oCount: UInt = self.Share().objectRetainCountDic.xyObject(name) {
            
            count = oCount - 1
            
        }else {
            
            count = 0
        }
        
        guard 0 < count else {
            
            self.Share().objectRetainCountDic.xySetObject(nil, forKey: name)
            
            return 0
        }
        
        self.Share().objectRetainCountDic.xySetObject(count, forKey: name)
        
        return count
    }
    
    
}

// MARK: - 参数的set/get
extension DebugToolsManage {
    
    static var ShowDebugTools : Bool {
        
        get {
            
            return self.Share().cache.showDebugTools
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.showDebugTools = newValue
            
            manage.cache = cache
        }
        
    }
    
    static var EnableQuickLookUpAnswer : Bool {
        
        get {
            
            return self.Share().cache.enableQuickLookUpAnswer
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.enableQuickLookUpAnswer = newValue
            
            manage.cache = cache
        }
    }
    
    static var EnableRepeatPractice : Bool {
        
        get {
            
            return self.Share().cache.enableRepeatPractice
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.enableRepeatPractice = newValue
            
            manage.cache = cache
        }
    }
    
    static var IsLoadStartPage : Bool {
        
        get {
            
            return self.Share().cache.isLoadStartPage
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.isLoadStartPage = newValue
            
            manage.cache = cache
        }
    }
    
    static var EnableSaveAnswer : Bool {
        
        get {
            
            return self.Share().cache.enableSaveAnswer
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.enableSaveAnswer = newValue
            
            manage.cache = cache
        }
    }
    
    static var EnableSaveAnswerHomework : Bool {
        
        get {
            
            return self.Share().cache.enableSaveAnswerHomework
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.enableSaveAnswerHomework = newValue
            
            manage.cache = cache
        }
    }
    
    static var FakeAppVersionOrNil : String? {
        
        get {
            
            return self.Share().cache.fakeAppVersionOrNil
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.fakeAppVersionOrNil = newValue
            
            manage.cache = cache
        }
    }
    
    static var RequestAddressOrNil : String? {
        
        get {
            
            return self.Share().cache.requestAddressOrNil
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.requestAddressOrNil = newValue
            
            manage.cache = cache
        }
    }
    
    static var DeviceRemoteNotificationTokenOrNil : String? {
        
        get {
            
            return self.Share().cache.deviceRemoteNotificationTokenOrNil
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.deviceRemoteNotificationTokenOrNil = newValue
            
            manage.cache = cache
        }
    }
    
    
    static var IsShowOldIndexPage : Bool {
        
        get {
            
            return self.Share().cache.isShowOldIndexPage
        }
        
        set {
            
            let manage = self.Share()
            
            var cache = manage.cache
            cache.isShowOldIndexPage = newValue
            
            manage.cache = cache
        }
    }
    
}

extension DebugToolsManage {
    
}

struct DebugToolsManageCache : XYUserDefaultsProtocol {
    
    /**
     *    @description 默认设置
     *
     */
    static var DefaultCache : DebugToolsManageCache {
        
        let model = DebugToolsManageCache()
        
        return model
    }
    
    /// 是否在用户中心展示 DebugTools
    var showDebugTools:Bool             = false
    
    /// 能否快速浏览答题
    var enableQuickLookUpAnswer:Bool    = false
    
    /// 能否将线上作答结果作废
    var enableRepeatPractice:Bool       = false
    
    /// 是否展示App启动时的动态展示页面
    var isLoadStartPage: Bool           = true
    
    /// 是否允许保存练习的作答结果(功能测试参数)
    var enableSaveAnswer : Bool         = true
    
    /// 是否允许保存作业的作答结果(功能测试参数)
    var enableSaveAnswerHomework : Bool = true
    
    /// 虚假的App版本号(功能测试参数)
    var fakeAppVersionOrNil : String?
    
    /// 请求地址
    var requestAddressOrNil : String?
    
    /// 远程推送消息设备Token
    var deviceRemoteNotificationTokenOrNil : String?
    
    /// 是否显示旧首页
    var isShowOldIndexPage: Bool = false
    
    init() {
        
        switch ProjectSetting.BuildEnvironment {
        case .Development:
            
            self.showDebugTools          = true
            self.enableQuickLookUpAnswer = true
            self.enableRepeatPractice    = true
            self.isLoadStartPage         = false
            
            break
            
        case .Distribution:
            
            self.showDebugTools          = false
            self.enableQuickLookUpAnswer = false
            self.enableRepeatPractice    = false
            self.isLoadStartPage         = true
            
            break
        }
        
        self.isShowOldIndexPage = false
    }
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any? = nil) -> DebugToolsManageCache? {
        
        guard let dataDic = dataDicOrNil,
            0 < dataDic.count else { return nil }
        
        guard let showDebugTools = dataDic.object(forKey: "showDebugTools") as? Bool,
            let enableQuickLookUpAnswer = dataDic.object(forKey: "enableQuickLookUpAnswer") as? Bool,
            let enableRepeatPractice = dataDic.object(forKey: "enableRepeatPractice") as? Bool,
            let isLoadStartPage = dataDic.object(forKey: "isLoadStartPage") as? Bool,
            let enableSaveAnswer = dataDic.object(forKey: "enableSaveAnswer") as? Bool,
            let enableSaveAnswerHomework = dataDic.object(forKey: "enableSaveAnswerHomework") as? Bool else { return nil }
        
        var model = DebugToolsManageCache()
        
        model.showDebugTools = showDebugTools
        model.enableQuickLookUpAnswer = enableQuickLookUpAnswer
        model.enableRepeatPractice = enableRepeatPractice
        model.isLoadStartPage = isLoadStartPage
        model.enableSaveAnswer = enableSaveAnswer
        model.enableSaveAnswerHomework = enableSaveAnswerHomework
        
        if let fakeAppVersion = dataDic.object(forKey: "fakeAppVersion") as? String {
            
            model.fakeAppVersionOrNil = fakeAppVersion
        }
        
        if let requestAddress = dataDic.object(forKey: "requestAddress") as? String {
            
            model.requestAddressOrNil = requestAddress
        }
        
        if let token = dataDic.object(forKey: "deviceRemoteNotificationToken") as? String {
            
            model.deviceRemoteNotificationTokenOrNil = token
        }
        
        if let isShowOldIndexPage = dataDic.object(forKey: "isShowOldIndexPage") as? Bool {
            
            model.isShowOldIndexPage = isShowOldIndexPage
        }
        
        return model
    }
    
    //Cache
    static var CacheBrifKey: String = "DebugToolsManageCache"
    
    var modelDataDic: DataType? {
        
        var dic = DataType()
        
        dic["showDebugTools"] = self.showDebugTools
        dic["enableQuickLookUpAnswer"] = self.enableQuickLookUpAnswer
        dic["enableRepeatPractice"] = self.enableRepeatPractice
        dic["isLoadStartPage"] = self.isLoadStartPage
        dic["enableSaveAnswer"] = self.enableSaveAnswer
        dic["enableSaveAnswerHomework"] = self.enableSaveAnswerHomework
        
        if let fakeAppVersion = self.fakeAppVersionOrNil {
            
            dic["fakeAppVersion"] = fakeAppVersion
        }
        
        if let requestAddress = self.requestAddressOrNil {
            
            dic["requestAddress"] = requestAddress
        }
        
        if let token = self.deviceRemoteNotificationTokenOrNil {
            
            dic["deviceRemoteNotificationToken"] = token
        }
        
        dic["isShowOldIndexPage"] = self.isShowOldIndexPage
        
        return dic
    }
}
