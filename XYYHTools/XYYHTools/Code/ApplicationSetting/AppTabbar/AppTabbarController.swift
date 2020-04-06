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
        
        //若没有地区和年级信息，设置默认的地区和年级信息
//        LocationGradeModel.DefaultLocationGlazz()
        
        self.refreshChildVC()
    }
    
    func refreshChildVC() {
        
        for childVC in self.children {
            
            childVC.removeFromParent()
        }
        
        //添加模块
        
        self.addSubNavigationController(self.homeworkContainerNavigationController)
        
//        for itemTag in AppTabbarItemTag.AllCaseArr {
//
//            guard itemTag.isNeedShow else { continue }
//
//            switch itemTag {
//            case .作业:
//
//                self.addSubNavigationController(self.homeworkContainerNavigationController)
//
//                break
//
//            case .班级:
//
//                self.addSubNavigationController(self.clazzIndexV2NavigationController)
//
//                break
//
//            case .用户中心:
//
//                self.addSubNavigationController(self.userCenterNavigationController)
//
//                break
//            }
//        }
    }

    /// 班级首页
    lazy var clazzIndexVC: BaseViewController = {

        let vc = BaseViewController()
        vc.bottomBarHidden = false
        
        return vc
    }()

    lazy var clazzIndexV2NavigationController:BaseNavigationController = {
        
        return self.newNavigationController(viewController: self.clazzIndexVC, itemTag: AppTabbarItemTag.班级)
    }()
    
    
    /// 首页
    lazy var homeworkContainerVC: 首页ViewController = {
        
        let vc = 首页ViewController.LoadFromStoryboard() ?? 首页ViewController()
        vc.bottomBarHidden = false

        return vc
    }()

    lazy var homeworkContainerNavigationController: BaseNavigationController = {
        
        return self.newNavigationController(viewController: self.homeworkContainerVC, itemTag: AppTabbarItemTag.作业)
    }()

    /// 用户中心
    lazy var userCenterVC: BaseViewController = {
        
        let vc = BaseViewController()
        vc.bottomBarHidden = false
        
        return vc
    }()
    
    lazy var userCenterNavigationController:BaseNavigationController = {
        
        return self.newNavigationController(viewController: self.userCenterVC, itemTag: AppTabbarItemTag.用户中心)
    }()
    
    //默认显示的模块
    var currentTag:AppTabbarItemTag = .作业
    
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
        
        // title
        //        navigationController.tabBarItem.titlePositionAdjustment = UIOffsetMake(30, -10)
        navigationController.tabBarItem.title = itemTag.title
        
        // Images
        let images = itemTag.images
        navigationController.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0 , 0, 0)
        
        if var nImg = images.nImg {
            
            //            nImg = nImg.imageResize(size: CGSize(width: 30, height: 30));
            nImg = nImg.withRenderingMode(.alwaysOriginal)
            
            navigationController.tabBarItem.image = nImg
        }
        
        if var sImg = images.sImg {
            
            //            sImg = sImg.imageResize(size: CGSize(width: 30, height: 30));
            sImg = sImg.withRenderingMode(.alwaysOriginal)
            
            navigationController.tabBarItem.selectedImage = sImg
        }
        
        navigationController.tabBarItem.tag = itemTag.rawValue
        navigationController.isNavigationBarHidden = itemTag.isNavigationBarHidden
        
        if #available(iOS 10.0, *) {
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:XYFont.Font(size: 12)], for: UIControl.State.selected)
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:XYFont.Font(size: 12)], for: UIControl.State.normal)
            
        }else {
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:XYColor(custom: .main).uicolor, NSAttributedString.Key.font:XYFont.Font(size: 12)], for: UIControl.State.selected)
            
            navigationController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:XYColor(custom: .xcccccc).uicolor, NSAttributedString.Key.font:XYFont.Font(size: 12)], for: UIControl.State.normal)
        }
        
        
        
        return navigationController
    }
    
}

