//
//  WebBrowerIndexViewController.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/18.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation
import WebKit
import RxSwift
import RxCocoa

class WebBrowerIndexViewController : BaseViewController {
    
    override func initProperty() {
        super.initProperty()

        self.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = self.rxScrollSpeedSubject
        let _ = self.rxTimerSubject
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard self.webView.url == nil else { return }
        
        if let cache = DataCache.Read(),
            let urlText = cache.urlOrNil,
            let url = URL(string: urlText) {
            
            self.rxScrollSpeedSubject.accept(cache.speed)
            
            self.webView.load(URLRequest(url: url))
            
        }else if let url = URL(string: "https://www.baidu.com") {
            
            self.webView.load(URLRequest(url: url))
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
        
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
    }
    
    @IBOutlet weak var scrollBtn: UIButton! {
        
        willSet {
            
            newValue.rx.tap.subscribe(onNext: { [weak self] () in
                guard let weakSelf = self else { return }
                
                weakSelf.scrollConfigAlertView.show(supView: weakSelf.view)
                
            }).disposed(by: self.disposeBag)
        }
    }
    
    lazy var scrollConfigAlertView: WebBrowerIndex_ScrollConfig_AlertView = {
        
        let newValue = WebBrowerIndex_ScrollConfig_AlertView.newAutoLayout()
        
        newValue.rxClickSubject.subscribe(onNext: { [weak self] (type) in
            guard let weakSelf = self else { return }
            
            if let speed = type.speedOrNil {
                
                weakSelf.rxScrollSpeedSubject.accept(weakSelf.rxScrollSpeedSubject.value+speed)
            }else {
                
                weakSelf.enableAutoScrollWebView = !weakSelf.enableAutoScrollWebView
            }
            
        }).disposed(by: self.disposeBag)
        
        return newValue
    }()
    
    lazy var rxScrollSpeedSubject: BehaviorRelay<CGFloat> = {
        
        let newValue = BehaviorRelay<CGFloat>(value: 5.0)
        
        newValue.distinctUntilChanged().subscribe(onNext: { [weak self] (value) in
            guard let weakSelf = self else { return }
            
            var cache = weakSelf.readDataCacheAndSetSpeed(value)
            cache.speed = value
            cache.save()
            
            weakSelf.scrollConfigAlertView.speedLabel.text = String(format: "%.\(1)f", value)
            
        }).disposed(by: self.disposeBag)
        
        return newValue
    }()
    
    fileprivate var enableAutoScrollWebView: Bool = false
    
    lazy var rxTimerSubject: Observable<Int64> = {
        
        let newValue = Observable<Int64>.timer(DispatchTimeInterval.seconds(0), period: DispatchTimeInterval.milliseconds(250), scheduler: MainScheduler.asyncInstance)
        
        newValue.filter({ (_) -> Bool in
            
            return self.enableAutoScrollWebView
        }).subscribe(onNext: { [weak self] (value) in
            guard let weakSelf = self else { return }
            
            //XYLog.LogNote(msg: "rxTimerSubject.value: \(value)")
            
            weakSelf.changeOffsetByScrollSpeed()
            
        }).disposed(by: self.disposeBag)
        
        return newValue
    }()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var webView: WKWebView! {
        
        willSet {
            
            newValue.uiDelegate = self
            newValue.navigationDelegate = self
            
            // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
            newValue.allowsBackForwardNavigationGestures = true
            
            newValue.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if keyPath == "title",
            (object as? WKWebView) == self.webView,
            let newTitle = self.webView.title,
            newTitle.isNotEmpty {
            
            //self.title = newTitle
        }
    }
    
    deinit {
        
        self.webView.removeObserver(self, forKeyPath: "title")
    }
    
    lazy var hudId: XYProgressHudId = {
        
        let hudId = XYProgressHudId.create(with: "XYWebView_StartLoadUrl")
        
        return hudId
    }()
    
    override func xyLocationNotificationAddObservers() {
        
    }
    
    override func xyLocationNotificationHandle(notification: Notification) {
        
    }
    
    fileprivate func changeOffsetByScrollSpeed() {
        
        let scrollView = self.webView.scrollView
        
        var newOffset = scrollView.contentOffset
        newOffset.y += CGFloat(self.rxScrollSpeedSubject.value)
        
        XYLog.LogNote(msg: "Y:\(scrollView.contentOffset.y) newY: \(newOffset.y)")
        
        scrollView.setContentOffset(newOffset, animated: true)
    }
    
}

extension WebBrowerIndexViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        XYLog.LogNote(msg: "searchBarTextDidEndEditing")
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        XYLog.LogNote(msg: "searchBarSearchButtonClicked")
        
        guard let text = searchBar.text,
            let url = URL(string: text) else { return }
        
        XYLog.LogNote(msg: "webView.loadUrl: \(text)")
        
        self.webView.load(URLRequest(url: url))
        
        self.searchBar.searchTextField.canResignFirstResponder.xyRunBlockWhenTrue {
            
            self.searchBar.searchTextField.resignFirstResponder()
        }
    }
    
}

extension WebBrowerIndexViewController {
    
    fileprivate func loadUrlBy(_ url: String) {
        
        guard let url = URL(string: url) else { return }
        
        self.load(URLRequest(url: url))
    }
    
    fileprivate func load(_ request: URLRequest) {
    
        self.webView.load(request)
    }
    
    fileprivate func changeFor(_ urlOrNil: String?) {
        
        guard let url = urlOrNil else { return }
        
        self.searchBar.searchTextField.setText(url)
        
        var cache = self.readDataCacheAndSetSpeed(self.rxScrollSpeedSubject.value)
        
        cache.urlOrNil = url
        
        cache.save()
    }
}

extension WebBrowerIndexViewController : WKNavigationDelegate {
    
    /*
     官方解释：决定是否允许或取消导航（继续加载）。
     您的委托可以立即调用块或保存块并在稍后时间异步调用它。
     可以理解成就是比如，一个想要加载URL前，想做点其他事时候才调用。
     
     实际应用中，比如
      1.通过一个判断一个合法URL，是否需要拉起支付宝app
      2.需求：判断加载的url包含XXXX字符，全部屏蔽掉，并跳转到相应的界面
     下面的其他代理方法都可以铺抓到加载的URL，为什么要在此方法开始做处理。
     原因，该代理方法，就是要在webview加载前拦截下来，第一时间处理，节省内存等。
    */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let webViewUrl = webView.url?.absoluteString {
            
            XYLog.LogNote(msg: "来源url: \(webViewUrl)")
        }
        
        if let requestUrl = navigationAction.request.url?.absoluteString {
            
            XYLog.LogNote(msg: "请求url: \(requestUrl)")
        }
        
        self.changeFor(navigationAction.request.url?.absoluteString)
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        XYLog.LogFunction()
        
        //XYProgressHudManager.AddProgressHud(toView: self.view, animationType: .FourDots, hudId: self.hudId)
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        XYLog.LogFunction()
        
        defer {
            
            //XYProgressHudManager.RemoveProgressHUD(removeingHudId: self.hudId)
        }
        
        guard let nsError = error as? NSError,
            let urlUnknow = nsError.userInfo[NSURLErrorFailingURLErrorKey],
            let url = urlUnknow as? URL,
            AppDelegate.ShareApplication.openURL(url) else {
            
            ShowSingleBtnAlertView(title: "网络异常", message: "无法请求数据！即将退出此页面~", comfirmTitle: "确定", showedVC: self) { (action) in
                
                self.popViewController()
            }
            
            return
        }
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        XYLog.LogFunction()
    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //XYProgressHudManager.RemoveProgressHUD(removeingHudId: self.hudId)
        
        XYLog.LogFunction()
    }
    
    //提交发生错误时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        XYLog.LogFunction()
    }
    
    // 接收到服务器跳转请求即服务重定向时之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        XYLog.LogFunction()
    }
}

extension WebBrowerIndexViewController : WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        XYLog.LogFunction()
        
        if let url = navigationAction.request.url?.absoluteString {
            
            self.searchBar.searchTextField.setText(url)
        }
        
        self.webView.load(navigationAction.request)
        
        return nil
    }
}

extension WebBrowerIndexViewController {
    
    fileprivate struct DataCache : XYUserDefaultsProtocol {
        
        var speed : CGFloat = 5.0
        var urlOrNil: String? = nil
        
        init(speed: CGFloat) {
            
            self.speed = speed
        }
        
        static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any? = nil) -> DataCache? {
            
            guard let dataDic = dataDicOrNil,
                dataDic.isNotEmpty,
                let speed: CGFloat = dataDic.xyObject("speed") else { return nil }
            
            var newValue = DataCache(speed: speed)
            
            if let url: String = dataDic.xyObject("url") {
                
                newValue.urlOrNil = url
            }
            
            return newValue
        }
        
        //Cache
        static var CacheBrifKey: String = "WebBrowerIndex_DataCache"
        
        var modelDataDic: DataType? {
            
            var dic = DataType()
            
            dic["speed"] = self.speed
            
            if let url = self.urlOrNil {
                
                dic["url"] = url
            }
            
            return dic
        }
    }
    
    fileprivate func readDataCacheAndSetSpeed(_ speed: CGFloat) -> DataCache {
        
        var newValue: DataCache
        
        if var cache = DataCache.Read() {
            
            cache.speed = speed
            
            newValue = cache
        }else {
            
            newValue = DataCache(speed: speed)
        }
        
        return newValue
    }
}



extension WebBrowerIndexViewController: XYStoryboardLoadProtocol {
    
    static var StoryboardName: String { return "WebBrower_Storyboard"}
    
    static var StoryboardIdentifier: String { return "WebBrowerIndexViewController" }
}
