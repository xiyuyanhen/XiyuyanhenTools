//
//  AppTabbarController.swift
//  XY_EStudy
//
//  Created by Xiyuyanhen on 2018/5/16.
//  Copyright © 2018年 Xiyuyanhen. All rights reserved.
//

import Foundation

class AppTabbarController: UITabBarController {
    
    static func XYInitBySystem() {
        
        if #available(iOS 10.0, *) {
            
            UITabBar.appearance().tintColor = XYColor(custom: .main).uicolor
            UITabBar.appearance().unselectedItemTintColor = XYColor(custom: .xcccccc).uicolor
        }
    }
    
    init() {
        
        //iOS 12.1 tabbar从二级页面返回跳动问题的解决方法
        UITabBar.appearance().isTranslucent = false

        super.init(nibName: nil, bundle: nil)
        
        self.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("XYTabbarController init(coder:) has not been implemented")
    }
    
    /**
     *    @description 创建主内容
     *
     */
    func setups() {
        
        self.refreshChildVC()
    }
    
    func refreshChildVC() {
        
        for childVC in self.children {
            
            childVC.removeFromParent()
        }
        
        //添加模块
        
        self.addSubNavigationController(self.indexContainerNavigationController)
        
        self.addSubNavigationController(self.webBrowerIndexNavigationController)
        
        self.addSubNavigationController(self.debugToolsMainManagerNavigationController)
    }
    
    /// 首页
    lazy var indexContainerVC: 首页ViewController = {
        
        let vc = 首页ViewController.LoadFromStoryboard() ?? 首页ViewController()
        vc.bottomBarHidden = false

        return vc
    }()

    lazy var indexContainerNavigationController: BaseNavigationController = {
        
        return self.newNavigationController(viewController: self.indexContainerVC, itemTag: AppTabbarItemTag.首页)
    }()
    
    /// 浏览器首页
    lazy var webBrowerIndexVC: BaseViewController = {

        let vc = WebBrowerIndexViewController.LoadFromStoryboard() ?? WebBrowerIndexViewController()
        vc.bottomBarHidden = false
        
        return vc
    }()

    lazy var webBrowerIndexNavigationController:BaseNavigationController = {
        
        return self.newNavigationController(viewController: self.webBrowerIndexVC, itemTag: AppTabbarItemTag.浏览器)
    }()

    /// 调试中心
    lazy var debugToolsMainManagerVC: DebugToolsMainManagerViewController = {
        
        let vc = DebugToolsMainManagerViewController()
        vc.bottomBarHidden = false
        
        return vc
    }()
    
    lazy var debugToolsMainManagerNavigationController:BaseNavigationController = {
        
        return self.newNavigationController(viewController: self.debugToolsMainManagerVC, itemTag: AppTabbarItemTag.调试中心)
    }()
    
    //默认显示的模块
    var currentTag: AppTabbarItemTag = .首页
    
}

extension AppTabbarController: UITabBarControllerDelegate{
    
    var managerViewControllers: [UIViewController] {
        
        guard let viewControllers = self.viewControllers else { return [] }
        
        return viewControllers
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if #available(iOS 13.0, *) {
            
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:XYColor(custom: .main).uicolor], for: UIControl.State.selected)
        }
        
        for subVC in self.managerViewControllers {

            guard (subVC.tabBarItem == item) else { continue }
                
            if let itemTag = AppTabbarItemTag(rawValue: item.tag) {
                
                // MARK: - 记录当前选择的Tag
                self.currentTag = itemTag
            }
            
            if let subNC = subVC as? UINavigationController {
                //返回RootVC
                subNC.popToRootViewController(animated: true)
            }

            break
        }
    }
    
    /**
     *    @description 获取指定的ViewController
     *
     */
    @discardableResult func selectViewController(tag:AppTabbarItemTag, isSelectVC: Bool = true) -> BaseViewController? {
        
        guard self.managerViewControllers.isNotEmpty else { return nil }
        
        for (index, subVC) in self.managerViewControllers.enumerated() {
            
            guard let subNC = subVC as? UINavigationController,
                subNC.tabBarItem.tag == tag.rawValue,
                let vc = subNC.viewControllers.last as? BaseViewController else { continue }
            
            if isSelectVC {
                
                self.selectedIndex = index
            }
            
            return vc
        }
        
        return nil
    }
    
    /**
     *    @description 获取当前ViewController
     *
     */
    var currentViewControllerOrNil : BaseViewController? {
        
        return self.selectViewController(tag: self.currentTag)
    }
}

extension AppTabbarController {
    
    func addSubNavigationController(_ navigationControllerOrNil:BaseNavigationController?){
        
        guard let navigationController = navigationControllerOrNil else { return }
        
        self.addChild(navigationController)
    }
    
    func newNavigationController(viewController:UIViewController, itemTag:AppTabbarItemTag) -> BaseNavigationController {
        
        let navigationController = BaseNavigationController.init(xyRootViewController: viewController)
    
        navigationController.tabBarItem.title = itemTag.name
        navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: -5, vertical: 0)
        
        navigationController.tabBarItem.tag = itemTag.rawValue
        navigationController.isNavigationBarHidden = itemTag.isNavigationBarHidden
        
        if #available(iOS 10.0, *) {
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:XYFont.Font(size: 16)], for: UIControl.State.selected)
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:XYFont.Font(size: 16)], for: UIControl.State.normal)
            
        }else {
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:XYColor(custom: .main).uicolor, NSAttributedString.Key.font:XYFont.Font(size: 16)], for: UIControl.State.selected)
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:XYColor(custom: .xcccccc).uicolor, NSAttributedString.Key.font:XYFont.Font(size: 16)], for: UIControl.State.normal)
        }
        
        return navigationController
    }
    
}

