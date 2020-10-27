//
//  DebugToolsMainManagerViewController.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/5/7.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class DebugToolsMainManagerViewController : BaseViewController {
    
    static let Title : String = "调试中心"
    
    override func initProperty() {
        super.initProperty()
        
        self.enablePerformanceMonitor = false

        self.view.setBackgroundColor(customColor: .xf6f6f6)
        
        self.title = DebugToolsMainManagerViewController.Title
    }
    
    override func popViewController(animated: Bool = true) {
        
        for vc in self.pageView.showedViewControllers {
            
            guard let toolsVC = vc as? DebugToolsViewController else { continue }
            
            toolsVC.delegateOrNil = nil
        }
        
        super.popViewController(animated: animated)
    }
    
//    override func willMove(toParent parent: UIViewController?) {
//        super.willMove(toParent: parent)
//
//        XYLog.LogFunction()
//    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//
//        XYLog.LogFunction()
//    }
    
    deinit {
        
        self.pageView.xyPageViewScrollDelegate = nil
        
        self.pageView.removeByDeinit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        XYLog.LogNoteBlock { () -> String? in
            
            return "APPDocumentPath:\(APPDocumentPath())"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.view.addSubview(self.pageView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        
    }
    
    private lazy var layout: LTLayout = {
        
        let layout = LTLayout()
        
        layout.titleViewBgColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        layout.titleColor = UIColor.FromXYColor(color: XYColor.CustomColor.x333333)
        layout.titleSelectColor = XYColor(argb: APP_CurrentTarget.filter(sts: 0xff20DB71, xy: XYColor.CustomColor.main.argb)).uicolor
        layout.titleFont = XYFont.Font(size: 15)
        layout.titleMargin = UIW(15)
        layout.bottomLineColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
        
        layout.isAverage = true
        layout.isNeedScale = false
        layout.showsHorizontalScrollIndicator = false
        
        return layout
    }()
    
    private lazy var pageView : LTPageView = {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let height = ScreenHeight() - (StatusBarHeight() + XYUIAdjustment.Share().navigationBarHeight + SafeAreaBottomHeight())
        
        let newPageView = LTPageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth(), height: height), currentViewController: self, viewControllers: self.detailViewControllerArr, titles: self.detailTitleArr, layout: self.layout)
        
        if let pageTitleView = newPageView.pageTitleViewOrNil {
            
            pageTitleView.setBackgroundColor(customColor: .xf6f6f6)
            pageTitleView.addLine(.bottom, size: 1.0, color: UIColor.FromXYColor(color: XYColor.CustomColor.xdddddd))
        }
        
        newPageView.xyPageViewScrollDelegate = self
        
        newPageView.didSelectIndexBlock = { (pageView, index) in

            guard let dtViewController = pageView.showedViewControllers.elementByIndex(index) as? DebugToolsViewController else { return }
            
            dtViewController.updateTypes()
            dtViewController.view.updateConstraintsIfNeeded()
        }
        
        return newPageView
    }()
}

extension DebugToolsMainManagerViewController : XYLTPageViewExtraDelegate {
    
    
}

extension DebugToolsMainManagerViewController {
    
    private var detailTitleArr : [String] {
    
        return DebugToolsMainManagerType.AllNameArr
    }
    
    private var detailViewControllerArr : [DebugToolsViewController] {
        
        var vcArr = [DebugToolsViewController]()
    
        for type in DebugToolsMainManagerType.AllCaseArr {

            let typeVC = DebugToolsViewController(type: type)
            typeVC.delegateOrNil = self
            
            if vcArr.isEmpty {
                
                typeVC.updateTypes()
            }

            vcArr.append(typeVC)
        }
        
        return vcArr
    }
}

extension DebugToolsMainManagerViewController : DebugToolsViewControllerDelegate {
    
    func selectType(viewController : DebugToolsViewController, type : DebugToolsType) {
        
        switch type {
            
        case .重置调试工具权限:
            
            DebugToolsManage.ClearCache()
            
            break
            
        case .调试悬浮窗:
            
            if let window = AppDelegate.AppWindow {
                
                if let oldMonitor = window.performanceMonitorOrNil {
                    
                    oldMonitor.disAppearAndHandle()
                    
                }else {
                    
                    let monitor = XYPerformanceMonitor.Create()
                    
                    window.addSubview(monitor)
                    
                    monitor.performanceCalculator.start()
                    
                    window.performanceMonitorOrNil = monitor
                }
                
            }else {
                
                DebugNote(tip: "无法获取Window视图窗")
            }
            
            break
            
        case .日志管理:
            
            self.settingLogPrintTarget()
            
            break
            
        case .查看日志:
            
            let logBrowseContainerVC = XYLogBrowseContainerViewController()
            self.navigationController?.pushViewController(logBrowseContainerVC, animated: true)
            
            break
            
        case .测试A:
            
            break
            
        case .设置虚假的应用版本号:
            
            self.settingFakeVersion()
            
            break
            
        case .重置网络请求地址:
            
            self.resetRequestScheme()
            
            break
            
        case .显示Document路径:
            
            XYLog.LogNoteBlock { () -> String? in
            
                return "Document路径: \(APPDocumentPath())"
            }
            
            break
            
        case .内存泄漏测试:
            
            break
            
        case .内存使用参考:
            
            XYLog_AlertTextView.Show(note: DebugToolsManage.ObjecRetainCountText)
            
            break
            
        case .PGY:
            
            XYPGYTools.CheckVersion()
            
            break
            
        case .PGYIndex:
            
            if let link = XYPGYTools.AppIndexLinkOrNil,
                link.isNotEmpty {
                
                var msg: String = "链接: \(link)"
                
                if let password = XYPGYTools.BuildPasswordOrNil,
                    password.isNotEmpty {
                    
                    msg.append("\n密码: \(password)")
                }
                
                ShowThreeAlertView(title: "", message: msg, comfirmTitle: "浏览器打开", secondTitle: "复制内容", cancelTitle: "取消", comfirmBtnBlock: { (_) in
                    
                    if AppDelegate.OpenUrl(url: link) {

                        
                    }else {
                        
                        ShowSingleBtnAlertView(title: "跳转失败")
                    }
                    
                }, secondBtnBlock: { (_) in
                    
                    msg.copyToPasteboard()
                    
                    BaseToastView.Show(tip: "内容已复制到剪贴板")
                    
                }, cancelBtnBlock: nil)
                
            }else {
                
                BaseToastView.Show(tip: "无法生成链接")
            }
            
            break
            
        case .设备推送Token:
            
            if let token = DebugToolsManage.DeviceRemoteNotificationTokenOrNil,
                token.isNotEmpty {
                
                token.copyToPasteboard()
                
                BaseToastView.Show(tip: "Token已经复制到剪贴板")
            }
            
            break
            
        case .关闭应用:
            
            XYExitApp()
            
            break
            
        default: break
        }
    }
    
}

// MARK: - 输出日志
extension DebugToolsMainManagerViewController : XYLogChangePrintTargetPickerDelegate {
    
    /**
     *    @description 设置日志输出方向
     *
     */
    func settingLogPrintTarget() {
        
        let pickerView = XYLogChangePrintTargetPickerView.newAutoLayout()
        
        pickerView.delegate = self
        
        self.view.addSubview(pickerView)
        
        pickerView.autoEdgesPinView(otherView: self.view)
        
        pickerView.settingTarget(target: XYLog.Share().printTarget)
        
        //        let currentTargetMsg = "当前输出: \(XYLog.Share().printTarget.rawValue)"
        //
        
    }
    
    func selectedTarget(target: XYLogPrintTarget) {
        
        switch target {
        case .None, .Console, .LogFile:
            
            XYLog.Share().printTarget = target
            
            BaseToastView.Show(tip: "修改日志输出！当前输出: \(target.name())")
            
            break
            
        case .Network:
            
            let alertView = UIAlertController(title: "\(target.name())地址", message: nil, preferredStyle: .alert)
            
            alertView.addTextField { (hostTF:UITextField) in
                hostTF.placeholder = "Host"
                hostTF.text = XYLog.Share().networkLogRequestHost
                
                let label = BaseLabel.init(frame: CGRect(x: 0, y: 0, width: UIW(35), height: UIW(20)))
                label.text = "Host: "
                label.font = XYFont.Font(size: 12)
                label.textColor = UIColor.FromRGB(0x2d354c)
                label.numberOfLines = 1
                label.textAlignment = NSTextAlignment.left
                
                hostTF.leftView = label
                hostTF.leftViewMode = .always
            }
            
            alertView.addTextField { (pathTF:UITextField) in
                pathTF.placeholder = "Path"
                pathTF.text = XYLog.Share().networkLogRequestPath
                
                let label = BaseLabel.init(frame: CGRect(x: 0, y: 0, width: UIW(35), height: UIW(20)))
                label.text = "Path: "
                label.font = XYFont.Font(size: 12)
                label.textColor = UIColor.FromRGB(0x2d354c)
                label.numberOfLines = 1
                label.textAlignment = NSTextAlignment.left
                
                pathTF.leftView = label
                pathTF.leftViewMode = .always
                
                
            }
            
            let comfirmAction = UIAlertAction(title: "确定", style: .default) { (alertAction) in
                
                guard let hostTF = alertView.textFields?.first,
                    let host = hostTF.text,
                    host.isNotEmpty else {
                        
                        BaseToastView.Show(tip: "输入的Host非法！请重新输入")
                        return
                }
                
                guard let pathTF = alertView.textFields?[1],
                    let path = pathTF.text,
                    path.isNotEmpty else {
                        
                        BaseToastView.Show(tip: "输入的Path非法！请重新输入")
                        return
                }
                
                XYLog.Share().networkLogRequestHost = host
                XYLog.Share().networkLogRequestPath = path
                
                XYLog.Share().printTarget = .Network
                
                BaseToastView.Show(tip: "修改日志输出！当前输出: \(XYLog.Share().printTarget.name())")
            }
            
            alertView.addAction(comfirmAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (alertAction) in
                
                guard let hostTF = alertView.textFields?.first,
                    let host = hostTF.text,
                    host.isNotEmpty else {
                        
                        return
                }
                
                guard let pathTF = alertView.textFields?[1],
                    let path = pathTF.text,
                    path.isNotEmpty else {
                        
                        return
                }
                
                XYLog.Share().networkLogRequestHost = host
                XYLog.Share().networkLogRequestPath = path
                
                XYLog.Share().printTarget = .Network
                
                BaseToastView.Show(tip: "修改日志输出！当前输出: \(XYLog.Share().printTarget.name())")
                
                self.dismiss(animated: true, completion: nil)
            }
            alertView.addAction(cancelAction)
            
            self.present(alertView, animated: true, completion: nil)
            
            break
        }
        
    }
}

// MARK: - 设置虚拟版本号
extension DebugToolsMainManagerViewController {
    
    /**
     *    @description 设置虚拟版本号
     *
     */
    func settingFakeVersion() {
        
        let currentVersion = ProjectSetting.Share().currentAppVersionPair.appVersionForService
        
        var versionMsg: String = "当前接口请求版本:\(currentVersion)"
        
        if let fakeAppVersion = DebugToolsManage.FakeAppVersionOrNil {
            
            versionMsg = "\(versionMsg)\n当前虚拟版本号:\(fakeAppVersion)"
        }
        
        let alertView = UIAlertController(title: "请输入虚拟版本号", message: versionMsg, preferredStyle: .alert)
        
        alertView.addTextField { (textfield:UITextField) in
            textfield.placeholder = "虚拟版本号"
            textfield.tag = 31
            
            
        }
        
        let comfirmAction = UIAlertAction(title: "确定", style: .default) { (alertAction) in
            
            guard let textField = alertView.textFields?.first,
                let version = textField.text,
                version.isNotEmpty else { return }
            
            DebugToolsManage.FakeAppVersionOrNil = version
            
            //检查更新
            //XYAppVersionUpdateManager.Check(checkVersionByService: false)
            
            BaseToastView.Show(tip: "虚拟版本号设置为:\(version)")
        }
        alertView.addAction(comfirmAction)
        
        let cancelAction = UIAlertAction(title: "取消/清除", style: .cancel) { (alertAction) in
            
            DebugToolsManage.FakeAppVersionOrNil = nil
            
            //检查更新
            //XYAppVersionUpdateManager.Check(checkVersionByService: false)
            
            self.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(cancelAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
}

// MARK: - 重置网络请求地址
extension DebugToolsMainManagerViewController {
    
    func resetRequestScheme() {
        
        let backgroundView = UIView.newAutoLayout()
        backgroundView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.black)
        backgroundView.alpha = 0.7
        
        let contentView = UIView.newAutoLayout()
        contentView.xyCornerRadius = UIView.XYCornerRadius(8.0)
        contentView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        
        let choiceView = SingleChoiceView.newAutoLayout()
        
        choiceView.tableViewDataArr.removeAll()
        
        for scheme in APP_RequestRootAddress.AllCaseArr {
            
            let isSelected : Bool = scheme == ProjectSetting.Share().requestAddress
            
            let model = SingleChoiceView.SingleChoiceModel(isSelected: isSelected,
                                                           title: scheme.name,
                                                           modelId: scheme.name)
            
            choiceView.tableViewDataArr.append(model)
        }
        
        let confirmBtn = BaseButton.newAutoLayout()
        confirmBtn.setContentMode(.scaleToFill)
        confirmBtn.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)
        confirmBtn.xyCornerRadius = UIView.XYCornerRadius(6.0)
        
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.FromRGB(0xffffff), for: .normal)
        confirmBtn.setupsClickBtnBlockHandle { (btn) in
            
            guard let selectdModel = choiceView.selectedModel(),
                let newScheme = APP_RequestRootAddress(rawValue: selectdModel.modelId) else { return }
            
            if newScheme != ProjectSetting.Share().requestAddress {
                
                if newScheme == APP_RequestRootAddress.Custom {
                    
                    // 若要自定义域名
                    
                    let alertView = UIAlertController(title: "自定义地址", message: nil, preferredStyle: .alert)
                    
                    alertView.addTextField { (textfield:UITextField) in
                        textfield.placeholder = "地址"
                        textfield.tag = 31
                        
                        textfield.text = "http://"
                    }
                    
                    let comfirmAction = UIAlertAction(title: "确定", style: .default) { (alertAction) in
                        
                        guard let textField = alertView.textFields?.first,
                            let schemePath = textField.text,
                            schemePath.isNotEmpty else {
                                
                                DebugNote(tip: "地址无效")
                                return
                        }
                        
                        APP_RequestRootAddress_Custom_SchemePath = schemePath
                        ProjectSetting.Share().requestAddress = APP_RequestRootAddress.Custom
                        
                        DebugToolsManage.RequestAddressOrNil = schemePath
                        
                        DebugNote(tip: "成功修改网络环境为: \(newScheme.name): \(schemePath)")
                        
                    }
                    alertView.addAction(comfirmAction)
                    
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (alertAction) in
                        
                        //                        self.dismiss(animated: true, completion: nil)
                    }
                    alertView.addAction(cancelAction)
                    
                    self.present(alertView, animated: true, completion: nil)
                    
                }else {
                    
                    
                    ProjectSetting.Share().requestAddress = newScheme
                    
                    DebugToolsManage.RequestAddressOrNil = newScheme.name
                    
                    DebugNote(tip: "成功修改网络环境为: \(newScheme.name)")
                    
                }
            }
            
            contentView.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
        
        let supView : UIView
        if let hudView = ProgressHudView {
            
            supView = hudView
        }else {
            
            supView = self.view
        }
        
        contentView.addSubviews(choiceView, confirmBtn)
        
        supView.addSubviews(backgroundView, contentView)
        
        backgroundView.autoEdgesPinView(otherView: supView)
        
        contentView.autoPinView(otherView: backgroundView, edgeInsets: UIEdgeInsetsMake(0, UIW(25), 0, -UIW(25)), edges: .leading, .trailing)
        contentView.autoSetDimension(.height, toSize: UIW(300))
        contentView.autoAlignAxis(.horizontal, toSameAxisOf: backgroundView)
        
        confirmBtn.autoSetDimension(.height, toSize: UIW(50))
        confirmBtn.autoPinView(otherView: contentView, edgeInsets: UIEdgeInsetsMake(0, UIW(50), -UIW(10), -UIW(50)), edges: .leading, .bottom, .trailing)
        
        choiceView.autoPinView(otherView: contentView, edgeInsets: UIEdgeInsetsMake(UIW(10), UIW(50), 0, -UIW(50)), edges: .top, .leading, .trailing)
        choiceView.autoPinEdge(.bottom, to: .top, of: confirmBtn, withOffset: -UIW(10))
        
    }
}

extension DebugToolsMainManagerViewController {
    
}


