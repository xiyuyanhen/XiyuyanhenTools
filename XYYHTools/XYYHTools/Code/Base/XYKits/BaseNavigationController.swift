//
//  BaseNavigationController.swift
//  XYStudio
//
//  Created by Xiyuyanhen on 2017/6/20.
//  Copyright © 2017年 XyyH. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .fullScreen
        
        self.delegate = self
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        
        self.modalPresentationStyle = .fullScreen
        
        self.delegate = self
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        
        self.modalPresentationStyle = .fullScreen
        
        self.delegate = self
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    convenience init(xyRootViewController: UIViewController) {
        
        self.init(rootViewController: xyRootViewController)
        
        let backgroundColor : XYColor.CustomColor //
        
        // MARK: - Naviagtion Bar BackgroundColor & title textColor
        switch APP_CurrentTarget {
            
        case .ShiTingShuo, .Xiyou:
            
            backgroundColor = XYColor.CustomColor.white
            break
        }
        
        self.xyBackgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        XYLog.LogNoteBlock { () -> String? in
            
            return "BaseNavigationController - viewWillAppear"
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        XYLog.LogNoteBlock { () -> String? in
            
            return "BaseNavigationController - viewDidAppear"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        XYLog.LogNoteBlock { () -> String? in
            
            return "BaseNavigationController - viewWillDisappear"
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        XYLog.LogNoteBlock { () -> String? in
            
            return "BaseNavigationController - viewDidDisappear"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        guard let topVC = self.topViewController else { return .default }
        
        return topVC.preferredStatusBarStyle
    }
    
    /**
     *    @description 设置字体颜色
     *
     */
    func setTitleColor(color: UIColor) {
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:color]
    }
    
    // MARK: - 背景颜色
    private var _xyBackgroundColor : XYColor.CustomColor = XYColor.CustomColor.white
    var xyBackgroundColor : XYColor.CustomColor {
        get {
            
            return self._xyBackgroundColor
        }
        
        set {
            
            guard self._xyBackgroundColor != newValue else { return }
            
            self._xyBackgroundColor = newValue
            
            // MARK: - 修改背景颜色关键API
            self.navigationBar.setBackgroundImage(UIImage.ImageWithColor(newValue.uiColor), for: .default)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if let bVC = viewController as? BaseViewController {
            
            bVC.hidesBottomBarWhenPushed = bVC.bottomBarHidden
        }
        
        super.pushViewController(viewController, animated: animated)
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        guard let nc = navigationController as? BaseNavigationController,
            let vc = viewController as? BaseViewController else { return }
        
        nc.setNavigationBarHidden(vc.navigationBarHidden, animated: animated)
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    // 手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return true
    }
    
    /* 调用此方法禁用侧滑返回功能
     
     此方法将会把navigationController后边的所有ViewController侧滑手势禁用，
     所以我推荐在所有ViewController基类的viewDidLoad中开启全局的侧滑功能，然后在相应禁止侧滑的控制器中的viewDidAppear中禁止侧滑。
     */
//    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
    //开始进行手势识别时调用的方法，返回NO则结束，不再触发手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        /*
         设置完成之后所有在该导航控制器下的ViewController就有了侧滑的返回功能，
         但是如果是根控制器侧滑就会出现问题，当我在根控制器侧滑之后想再次push出新的控制器后就会失效。
         如果根控制器侧滑三次则需要push四次之后才可以出现新的视图，所以要通过手势的代理方法对根控制器的侧滑手势进行处理
         */
        
        // 判断是否是侧滑相关的手势，且允许响应返回请求
        guard gestureRecognizer == self.interactivePopGestureRecognizer,
            let visibleVC = self.visibleViewController as? BaseViewController,
            visibleVC.interactivePopGestureRecognizerHandle(btn: nil) else { return false }
        
        // 通过重写 BaseViewController 的 interactivePopGestureRecognizerHandle(btn: UIButton?) -> Bool 方法，可以自定义左滑返回的具体执行内容
        
        return false
    }
    
    // 是否支持多时候触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // 判断是否是侧滑相关手势
        guard gestureRecognizer == self.interactivePopGestureRecognizer,
            let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        let point = pan.translation(in: self.view)
        
        guard 0 < point.x else {
            
//            if let visibleVC = self.visibleViewController as? BaseViewController {
//
//                visibleVC.xy_PanGestureRecognizerForTabbleBar(panGR: pan)
//            }
        
            return false
        }
        
        // 当前为滑动手势，且手势起始位置大于0
        // 如果是侧滑相关的手势，并且手势的方向是侧滑的方向就让多个手势共存

        return true
    }
    
    //下面这个两个方法也是用来控制手势的互斥执行的
    
    //这个方法返回YES，第一个手势和第二个互斥时，第一个会失效
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return true
//    }
    
    //这个方法返回YES，第一个和第二个互斥时，第二个会失效
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return true
//    }
}

class BaseTabbar: UITabBar {
    
    
}

class BaseNavigationItem : UINavigationItem {
    
    
}

class BaseBarButtonItem : UIBarButtonItem {
    
    enum XYBarButtonType {
        case Back
        case Close
        case Next
        case More
        case DownloadManager
        case AutoNext
    }
    
    var baseBtnOrNil: BaseButton? = nil
    
    convenience init(type: XYBarButtonType, target:Any, sel:Selector) {
        
        var btnSize : CGSize = CGSize(width: UIW(30), height: UIW(25))
        let imgName : String
        switch type {
        case .Back:
            
            imgName = "public_back_black"
            
            break
            
        case .Close:
            
            btnSize = CGSize(width: UIW(30), height: UIW(30))
            imgName = "Public_Close2_Black"
            
            break
            
        case .Next:
            
            imgName = "public_Next_small_white"
            
            break
            
        case .More:
            
            imgName = "Public_More_Black"
            
            break
            
        case .DownloadManager:
            
            btnSize = CGSize(width: UIW(30), height: UIW(30))
            imgName = "Public_Icon_DownloadManager"
            
            break
            
        case .AutoNext:
            
            btnSize = CGSize(width: UIW(30), height: UIW(30))
            imgName = "Public_Auto"
            
            break
            
        }
        
        let btn : BaseButton = BaseBarButtonItem.CreateCommondBaseButton(btnSize: btnSize)
        
        btn.addTarget(target, action: sel, for: .touchUpInside)
        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
        
        if let img = UIImage(named: imgName) {
            
            btn.setImage(img, for: .normal)
        }
        btn.setContentMode(.scaleAspectFit)
        
        self.init(customView: btn)
        
        self.baseBtnOrNil = btn
    }
    
    convenience init(btnSize : CGSize, imgName : String, target:Any, sel:Selector) {
        
        let btn : BaseButton = BaseBarButtonItem.CreateCommondBaseButton(btnSize: btnSize)
        
        btn.addTarget(target, action: sel, for: .touchUpInside)
        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
        
        if let img = UIImage(named: imgName) {
            
            btn.setImage(img, for: .normal)
        }
        btn.setContentMode(.scaleAspectFit)
        
        self.init(customView: btn)
        
        self.baseBtnOrNil = btn
        
    }
    
    convenience init(public_Title: String, target:Any, sel:Selector) {
        
        let textColor : UIColor
        
        switch APP_CurrentTarget {
        case .ShiTingShuo, .Xiyou:
            textColor = XYColor(custom: .main).uicolor
            break
            
        @unknown default: fatalError()
        }
        
        self.init(title: public_Title, titleColor: textColor, target: target, sel: sel)
    }
    
    convenience init(title: String, titleColor: UIColor = UIColor.FromRGB(0xffffff), target:Any, sel:Selector) {
        
        let width : CGFloat = UIW(20) * CGFloat(title.count)
        let btnSize : CGSize = CGSize(width: width, height: UIW(25))
        
        let btn : BaseButton = BaseBarButtonItem.CreateCommondBaseButton(btnSize: btnSize)
        
        btn.addTarget(target, action: sel, for: .touchUpInside)
        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
        
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = XYFont.Font(size: 18)
        
        btn.setTitleColor(titleColor, for: .normal)
        
        self.init(customView: btn)
        
        self.baseBtnOrNil = btn
    }
    
    convenience init(title: String, titleColor: UIColor, imgOrNil: UIImage?, target:Any, sel:Selector) {
        
        let width : CGFloat = UIW(16) * CGFloat(title.count) + UIW(18)
        let btnSize : CGSize = CGSize(width: width, height: UIW(25))
        
        let btn : BaseButton = BaseBarButtonItem.CreateCommondBaseButton(btnSize: btnSize)
        
        btn.addTarget(target, action: sel, for: .touchUpInside)
        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
        
        btn.customTitleLabel.setText(title)
            .setTextColor(uiColor: titleColor)
            .setFont(XYFont.Font(size: 15))
        
        btn.customImgView.setImage(imgOrNil)
        
        btn.customTitleLabel.autoAlignAxis(.horizontal, toSameAxisOf: btn)
        btn.customTitleLabel.autoPinEdge(.leading, to: .leading, of: btn, withOffset: 0)
        
        btn.customImgView.autoSetDimensions(to: CGSize(width: UIW(16), height: UIW(16)))
        btn.customImgView.autoAlignAxis(.horizontal, toSameAxisOf: btn)
        btn.customImgView.autoPinEdge(.trailing, to: .trailing, of: btn, withOffset: 0)
        
        self.init(customView: btn)
        
        self.baseBtnOrNil = btn
    }
    
    // MARK: - 创建通用BaseButton
    static func CreateCommondBaseButton(btnSize : CGSize) -> BaseButton {
        
        let btn : BaseButton
        if #available(iOS 11.0, *) {
            
            btn = BaseButton.newAutoLayout()
            
            btn.autoSetDimensions(to: btnSize)
            
        }else{
            
            btn = BaseButton(frame: CGRect(x: 0, y: 0, width: btnSize.width, height: btnSize.height))
        }
        
        btn.setTitleColor(UIColor.FromXYColor(color: XYColor.CustomColor.xdddddd), for: .disabled)
        
        return btn
    }
    
    
    //    class func PublicButtonItem(type: XYBarButtonType, target:Any, sel:Selector) -> BaseBarButtonItem {
    //
    //        let btn : BaseButton = self.PublicButton(target: target, sel: sel)
    //
    //        let imgName : String
    //        switch type {
    //        case .Back:
    //            imgName = "public_back_black"
    //            break
    //
    //        case .Close:
    //            imgName = "Public_Close2_Black"
    //            break
    //
    //        case .Next:
    //            imgName = "个人设置_向右"
    //            break
    //
    //        case .More:
    //            imgName = "PubLic_More_White"
    //            break
    //
    //        case .DownloadManager:
    //            imgName = "Public_Icon_DownloadManager"
    //            break
    //
    //        }
    //
    //        if let img = UIImage(named: imgName) {
    //
    //            btn.setImage(img, for: .normal)
    //        }
    //        btn.setContentMode(.scaleAspectFit)
    //
    //        let backButtonItem = BaseBarButtonItem(customView: btn)
    //
    //        return backButtonItem
    //    }
    
    
    
    //    class func PublicButtonItem(title: String, target:Any, sel:Selector) -> BaseBarButtonItem {
    //
    //        let btn : BaseButton
    //        if #available(iOS 10.0, *) {
    //
    //            btn = BaseButton.newAutoLayout()
    //
    //            btn.autoSetDimensions(to: CGSize(width: UIW(30), height: UIW(25)))
    //
    //        }else{
    //
    //            btn = BaseButton(frame: CGRect(x: 0, y: 0, width: UIW(30), height: UIW(25)))
    //        }
    //
    //        btn.addTarget(target, action: sel, for: .touchUpInside)
    //        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
    //
    //        btn.setTitle(title, for: .normal)
    //        btn.setTitleColor(UIColor.FromRGB(0xffffff), for: .normal)
    //
    //        let backButtonItem = BaseBarButtonItem(customView: btn)
    //
    //        return backButtonItem
    //    }
    
    //    class func PublicBackButtonItem(target:Any, sel:Selector) -> BaseBarButtonItem {
    //
    //        let btn : BaseButton
    //        if #available(iOS 10.0, *) {
    //
    //            btn = BaseButton.newAutoLayout()
    //
    //            btn.autoSetDimensions(to: CGSize(width: UIW(30), height: UIW(25)))
    //
    //        }else{
    //
    //            btn = BaseButton(frame: CGRect(x: 0, y: 0, width: UIW(30), height: UIW(25)))
    //        }
    //
    //        btn.setContentMode(.scaleAspectFit)
    //        btn.setImage(UIImage(named: "public_back_black"), for: .normal)
    ////        btn.setImage(#imageLiteral(resourceName: "public_back_white"), for: .normal)
    //        btn.setTitleColor(UIColor.FromRGB(0xffffff), for: .normal)
    //        btn.addTarget(target, action: sel, for: .touchUpInside)
    //
    //        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
    //
    //        let backButtonItem = BaseBarButtonItem(customView: btn)
    //
    //
    //        return backButtonItem
    //    }
    
    //    class func PublicCloseButtonItem(target:Any, sel:Selector) -> BaseBarButtonItem {
    //
    //        let btn : BaseButton
    //        if #available(iOS 10.0, *) {
    //
    //            btn = BaseButton.newAutoLayout()
    //
    //            btn.autoSetDimensions(to: CGSize(width: UIW(30), height: UIW(25)))
    //
    //        }else{
    //
    //            btn = BaseButton(frame: CGRect(x: 0, y: 0, width: UIW(30), height: UIW(25)))
    //        }
    //
    //        btn.setContentMode(.scaleAspectFit)
    //        btn.setImage(UIImage(named: "Public_Close2_Black"), for: .normal)
    ////        btn.setImage(UIImage(named: "Public_Close_Back_Gary"), for: .normal)
    //        btn.setTitleColor(UIColor.FromRGB(0xffffff), for: .normal)
    //        btn.addTarget(target, action: sel, for: .touchUpInside)
    //
    //        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
    //
    //        let backButtonItem = BaseBarButtonItem(customView: btn)
    //
    //
    //        return backButtonItem
    //    }
    
    //    class func PublicNextButtonItem(target:Any, sel:Selector) -> BaseBarButtonItem {
    //
    //        let btn : BaseButton
    //        if #available(iOS 10.0, *) {
    //
    //            btn = BaseButton.newAutoLayout()
    //
    //            btn.autoSetDimensions(to: CGSize(width: UIW(30), height: UIW(25)))
    //
    //        }else{
    //
    //            btn = BaseButton(frame: CGRect(x: 0, y: 0, width: UIW(30), height: UIW(25)))
    //        }
    //
    //        btn.setContentMode(.scaleAspectFit)
    //        btn.setImage(UIImage(named: "个人设置_向右"), for: .normal)
    //        btn.setTitleColor(UIColor.FromRGB(0xffffff), for: .normal)
    //        btn.addTarget(target, action: sel, for: .touchUpInside)
    //
    //        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
    //
    //        let backButtonItem = BaseBarButtonItem(customView: btn)
    //
    //
    //        return backButtonItem
    //    }
    
    //    class func PublicMoreButtonItem(target:Any, sel:Selector) -> BaseBarButtonItem {
    //
    //        let btn : BaseButton
    //        if #available(iOS 10.0, *) {
    //
    //            btn = BaseButton.newAutoLayout()
    //
    //            btn.autoSetDimensions(to: CGSize(width: UIW(30), height: UIW(25)))
    //
    //        }else{
    //
    //            btn = BaseButton(frame: CGRect(x: 0, y: 0, width: UIW(30), height: UIW(25)))
    //        }
    //
    //        btn.setContentMode(.scaleAspectFit)
    //        btn.setImage(UIImage(named: "PubLic_More_White"), for: .normal)
    //        btn.addTarget(target, action: sel, for: .touchUpInside)
    //
    //
    //        btn.enlargeEdge(UIEdgeInsetsMake(10, 15, 10, 15))
    //
    //        let backButtonItem = BaseBarButtonItem(customView: btn)
    //
    //
    //        return backButtonItem
    //    }
}
