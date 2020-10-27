//
//  BaseViewController.swift
//  XYStudio
//
//  Created by Xiyuyanhen on 2017/6/20.
//  Copyright © 2017年 XyyH. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

/// 视图控制器状态
enum XYViewControllerStatus : Int, XYEnumTypeAllCaseProtocol{
    case Unknow             = 0
    case ViewDidLoad        = 1
    case ViewWillAppear     = 2
    case ViewDidAppear      = 3
    case ViewWillDisappear  = 4
    case ViewDidDisappear   = 5
    
    var isShowing : Bool {
        
        switch self {
            
        case .ViewDidAppear : return true
            
        case .Unknow, .ViewDidLoad, .ViewWillAppear, .ViewWillDisappear, .ViewDidDisappear : return false
        }
    }
}

class BaseViewController: UIViewController, XYNibLoadViewControllerProtocol {
    
    /// 是否隐藏底部Bar
    var bottomBarHidden = true
    
    // 是否响应 XYPerformanceMonitorDelegate
    var enablePerformanceMonitor : Bool = true
    
    init(){
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.white
        
        if self.responds(to: #selector(setter: self.edgesForExtendedLayout)) {
            
            self.edgesForExtendedLayout = UIRectEdge.bottom
        }
        
        self.initProperty()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        if #available(iOS 13.0, *) {
            
            if self.navigationBarHidden {
                
                return .darkContent
            }
            
            return .default
        }
        
        return .default
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        if self.responds(to: #selector(setter: self.edgesForExtendedLayout)) {
            
            self.edgesForExtendedLayout = UIRectEdge.bottom
        }
        
    }
    
    //MARK: - Custom
    
    func initProperty() {

        self.xyLocationNotificationAddObservers()
    }
    
    // MARK: - 析构过程
    deinit {
        
        self.xyLocationNotificationRemoveObservers()
        
        XYLog.LogNote(msg: "\(self.xyClassName) -- deinit")
    }
    
    /**
     *    @description 是否可以执行 xy_DealWithDeinit() 方法
     *
     *    此参数一般用不上，但当一个ViewController多次出现时可能用到
     *
     */
    var canDealWithDeinit : Bool = true
    
    /// 内部执行 xy_DealWithDeinit() 的语法糖
    fileprivate func dealWithDeinit() {
        
        guard self.canDealWithDeinit else { return }
            
        self.xy_DealWithDeinit()
    }
    
    /**
     *    @description 用于解除引用关系来准备销毁内存
     *
     */
    func xy_DealWithDeinit() {
        
    }
    
    // MARK: - 通知序列
    
    /**
     *    @description 添加通知
     *
     */
    func xyLocationNotificationAddObservers() {

    }

    /**
     *    @description 响应通知与处理
     *
     */
    @objc func xyLocationNotificationHandle(notification: Notification) {


    }
    
    /**
     *    @description 移除通知
     *
     */
    fileprivate func xyLocationNotificationRemoveObservers() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //autolayout
    
    override func updateViewConstraints() {
        
        if self.xyIsDidUpdateViewConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateViewConstraints = true
        }
        
        super.updateViewConstraints()
        

    }
    
    private var xyIsDidUpdateViewConstraints : Bool = false
    
    func layoutAddViews() {
        

    }
    
    func layoutAllViews() {
        

    }
    
    //MARK: - ViewController的生命周期
    
    override func loadView() {
        super.loadView()
        
        //更新约束
        self.view.setNeedsUpdateConstraints()
    }
    
    /// 当前视图控制器状态
    private var _xy_ViewStatus : XYViewControllerStatus = .Unknow
    
    /// 更新视图控制器状态，只对内部提供的setter方法
    private func setXY_ViewStatus(newValue: XYViewControllerStatus) {
        
        guard newValue != self._xy_ViewStatus else { return }
        
        self._xy_ViewStatus = newValue
        
        guard let _xy_RxViewStatus = self._xy_RxViewStatusOrNil else { return }
        
        _xy_RxViewStatus.onNext(newValue)
    }
    
    /// 视图控制器状态(对外的getter方法)
    var xy_ViewStatus: XYViewControllerStatus { return self._xy_ViewStatus }
    
    private var _xy_RxViewStatusOrNil: PublishSubject<XYViewControllerStatus>?
    
    var rxViewStatusDisposeBagOrNil: DisposeBag?
    
    // 提供给外部调用
    var rxViewStatusOrNil: PublishSubject<XYViewControllerStatus>? {
        
        guard let _xy_RxViewStatus = self._xy_RxViewStatusOrNil else {
            
            let newValue = PublishSubject<XYViewControllerStatus>()
            
            self._xy_RxViewStatusOrNil = newValue
            
            return newValue
        }
        
        return _xy_RxViewStatus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setXY_ViewStatus(newValue: XYViewControllerStatus.ViewDidLoad)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setXY_ViewStatus(newValue: XYViewControllerStatus.ViewWillAppear)
        
        self.changeCommondBackButtonItem()
        
        XYLog.LogWarnning(msg: "\(self.xyClassName)--viewWillAppear", mark: "显示页面变动")
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setXY_ViewStatus(newValue: XYViewControllerStatus.ViewDidAppear)

        
        XYPerformanceMonitor.BecomePerformanceMonitorDelegate(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setXY_ViewStatus(newValue: XYViewControllerStatus.ViewWillDisappear)

        
        XYPerformanceMonitor.RegisterPerformanceMonitorDelegate(viewController: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setXY_ViewStatus(newValue: XYViewControllerStatus.ViewDidDisappear)
        
        self.viewDidDisappearCompletionHandle()
        
        XYLog.LogWarnning(msg: "\(self.xyClassName)--viewDidDisappear", mark: "显示页面变动")
        
        guard let completionBlock = self.viewDidDisappearCompletionBlockOrNil else { return }
        
        completionBlock(self)
    }
    
    // MARK: - NaviagationItem Setting
    
    /// 是否隐藏返回按钮
    var isHiddenBack:Bool = false
    
    /// 是否隐藏NavigationBar
    var navigationBarHidden = false

    /**
     *    @description 改变backBarButtonItem
     *
     */
    func changeCommondBackButtonItem() {
        
        if self.isHiddenBack == true {
            
            self.navigationItem.backBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
            
            self.navigationItem.hidesBackButton = true
            
        }else if self.navigationController != nil {
            
            let backButtonItem = BaseBarButtonItem(type: .Back, target: self, sel: #selector(self.popHandle(btn:)))
            self.navigationItem.backBarButtonItem = backButtonItem
            self.navigationItem.leftBarButtonItem = backButtonItem
            
            self.navigationItem.hidesBackButton = false
        }
    }
    
    typealias ViewDidDisappearCompletionBlock = ((_ viewController : BaseViewController) -> Void)
    var viewDidDisappearCompletionBlockOrNil : ViewDidDisappearCompletionBlock?
    
    func setViewDidDisappearCompletionBlock(blockOrNil : ViewDidDisappearCompletionBlock?) {
        
        self.viewDidDisappearCompletionBlockOrNil = blockOrNil
    }
    
    /**
     *    @description viewController 提供视图消失后可自定义执行的方法
     *
     */
    func viewDidDisappearCompletionHandle() {
        
        
    }
    
    /// 左右拖拽手势响应 (设计在首页拖拽切换TabbleBar的Item使用)
//    func xy_PanGestureRecognizerForTabbleBar(panGR: UIPanGestureRecognizer) { }
    
    /// 全局侧滑返回手势(首页显示时)响应
    @discardableResult @objc func interactivePopGestureRecognizerHandle(btn: UIButton?) -> Bool {
        
        self.popViewController()
        
        return true
    }
    
    @objc func popHandle(btn:UIButton){
        
        self.popViewController()
    }
    
    /// 是否应该Dismiss退出
    var isShouldDissmiss : Bool = false

    func popViewController(animated: Bool = true) {
        
        if let nc = self.navigationController {
            
            if nc.viewControllers.count == 1 {
                
                nc.dismiss(animated: animated) {
                    
                    self.dealWithDeinit()
                }
            }else{
                
                if self.isShouldDissmiss {
                    
                    nc.dismiss(animated: animated) {
                        
                        self.dealWithDeinit()
                    }
                    
                }else {
                    
                    nc.popViewController(animated: animated)
                    
                    self.dealWithDeinit()
                }
            }
            
        }else{
            
            self.dismiss(animated: animated, completion: {
                
                self.dealWithDeinit()
            })
        }
    }
    
    func xyDismiss(animated: Bool, completion: (() -> Void)? = nil) {
        
        (self.navigationController ?? self).dismiss(animated: animated) { [weak self] in
            
            if let com = completion { com() }
            
            self?.dealWithDeinit()
        }
    }
    
    /**
     *    @description 生成基于自身的NavigationController
     *
     *    @return   navigationController
     */
    func newNavigationController() -> BaseNavigationController {
        
        let navigationController = BaseNavigationController(xyRootViewController: self)
        
        return navigationController
    }
}

extension BaseViewController {
    
    /// 是否触发LogNote信息显示
    var xyLogNoteActive: Bool { return true }
    
}

extension BaseViewController : XYPerformanceMonitorDelegate {
    
    func performanceMonitorClickHandle(monitor: XYPerformanceMonitor) {
        
        guard self.enablePerformanceMonitor else { return }
        
        var style = UIAlertController.Style.actionSheet
        
        if XYDevice.Model() == .iPad {
            
            style = .alert
        }
        
        let selectPhotoAS = UIAlertController(title: nil, message: nil, preferredStyle: style)
        
        //调试控制中心
//        selectPhotoAS.addAction(UIAlertAction(title: DebugToolsMainManagerViewController.Title, style: .default) { (alertAction) in
//
//            let debugToolsMainManagerVC = DebugToolsMainManagerViewController()
//            AlertShowedVC.present(debugToolsMainManagerVC.newNavigationController(), animated: true, completion: nil)
//        })
        
        //日志管理
        selectPhotoAS.addAction(UIAlertAction(title: XYLogBrowseContainerViewController.Title, style: .default) { (alertAction) in
            
            let logBrowseContainerVC = XYLogBrowseContainerViewController()
            AlertShowedVC.present(logBrowseContainerVC.newNavigationController(), animated: true, completion: nil)
        })
        
        // 退出悬浮窗
        selectPhotoAS.addAction(UIAlertAction(title: "退出悬浮窗", style: .default) { (alertAction) in
            
            if let performanceMonitor = XYPerformanceMonitor.AppWindowPerformanceMonitorOrNil {
                
                performanceMonitor.disAppearAndHandle()
            }
            
            selectPhotoAS.dismiss(animated: true, completion: nil)
        })
        
        // 取消
        selectPhotoAS.addAction(UIAlertAction(title: "取消", style: .cancel) { (alertAction) in
            
            selectPhotoAS.dismiss(animated: true, completion: nil)
        })
        
        let presentVC : UIViewController
        if let navigationController = self.navigationController {
            
            presentVC = navigationController
        }else {
            
            presentVC = self
        }
        
        presentVC.present(selectPhotoAS, animated: true, completion: nil)
        
    }
}




