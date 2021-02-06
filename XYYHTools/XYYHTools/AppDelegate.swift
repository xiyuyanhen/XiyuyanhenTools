//
//  AppDelegate.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/4.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? 
    
    lazy var tabbarController : AppTabbarController = { () -> AppTabbarController in
        
        AppTabbarController.XYInitBySystem()
        
        let newValue = AppTabbarController()
        newValue.setups()
        
        return newValue
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        XYDispatchQueueType.Public.xyAsync {
            
            //初始化数据库
            XYWDBManager.CreateDBAndTable()
            
            XYBmobTools.Register()
        }
        
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    
    class func Shared() -> AppDelegate {
        
        let del = self.ShareApplication.delegate as! AppDelegate
        
        return del
    }
    
    static var ShareApplication: XYApplication {
        
        return XYApplication.Share()
    }
    
    var shareApplication: XYApplication {
        
        return AppDelegate.ShareApplication
    }
    
    static var AppWindow : XYWindow? {
        
        return self.ShareApplication.windows.first as? XYWindow
    }
    
    class func SharedTabbarController() -> AppTabbarController {
        
        return self.Shared().tabbarController
    }
    
    class func CurrentVC() -> BaseViewController? {
        
        return self.Shared().tabbarController.currentViewControllerOrNil
    }
}

extension AppDelegate {
    
    /**
     *    @description 拨打指定号码
     *
     *    @param    telprompt    号码
     *
     *    @return   能否成功
     */
    static func Telprompt(telprompt: String) -> Bool {
        
        let urlStr = "telprompt://\(telprompt)"
        
        guard let url = URL(string: urlStr),
            self.ShareApplication.openURL(url) else { return false }
        
        return true
    }
    
    static func OpenUrl(url text: String) -> Bool {
        
        guard let url = URL(string: text),
            self.ShareApplication.openURL(url) else { return false }
        
        return true
    }
}
