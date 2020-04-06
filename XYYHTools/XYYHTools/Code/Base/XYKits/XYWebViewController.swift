//
//  XYWebViewController.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/7/30.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
import WebKit

class XYWebViewController : BaseViewController, UIWebViewDelegate {
    
    class func Presented(url: URL, title: String, presentedVC: UIViewController) {
        
        let webVC = XYWebViewController()
        webVC.loadUrl(url: url)
        webVC.title = title
        
        let webNavi = BaseNavigationController(xyRootViewController: webVC)
        
        if let navigationController = presentedVC.navigationController {
            
            navigationController.present(webNavi, animated: true, completion: nil)
        }else{
            
            presentedVC.present(webNavi, animated: true, completion: nil)
        }
    }
    
    override func initProperty() {
        super.initProperty()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        XYProgressHudManager.RemoveProgressHUD(removeingHudId: self.hudId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.view.addSubview(self.wkWebView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.wkWebView.autoEdgesPinView(otherView: self.view)
    }
    
    lazy var wkWebView: WKWebView = {
        
        let webView = WKWebView.newAutoLayout()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        
        return webView
    }()
    
    func loadUrl(url:URL){
        
        let request = URLRequest(url: url)
        
        self.wkWebView.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if keyPath == "title",
            (object as? WKWebView) == self.wkWebView,
            let newTitle = self.wkWebView.title,
            newTitle.isNotEmpty {
            
            self.title = newTitle
        }
    }
    
    deinit {
        
        self.wkWebView.removeObserver(self, forKeyPath: "title")
    }
    
    lazy var hudId: XYProgressHudId = {
        
        let hudId = XYProgressHudId.create(with: "XYWebView_StartLoadUrl")
        
        return hudId
    }()
}

extension XYWebViewController : WKNavigationDelegate {
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        XYLog.LogFunction()
        
        XYProgressHudManager.AddProgressHud(toView: self.view, animationType: .FourDots, hudId: self.hudId)
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        XYLog.LogFunction()
        
        defer {
            
            XYProgressHudManager.RemoveProgressHUD(removeingHudId: self.hudId)
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
        
        XYProgressHudManager.RemoveProgressHUD(removeingHudId: self.hudId)
        
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

extension XYWebViewController : WKUIDelegate {

    
}
