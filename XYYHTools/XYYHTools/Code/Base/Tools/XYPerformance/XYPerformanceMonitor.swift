//
//  XYPerformanceMonitor.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/22.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYPerformanceMonitor : XYFloatingButton {
    
    var delegateOrNil : XYPerformanceMonitorDelegate?
    
    static func Create() -> XYPerformanceMonitor {
             
        let view = XYPerformanceMonitor(frame: CGRect(x: 0, y: UIW(80), width: UIW(50), height: UIW(50)))
        view.updateConstraintsIfNeeded()
        
        return view
    }
    
    override func initProperty() {
        super.initProperty()

    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubviews(self.msgLabel)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()

        self.msgLabel.autoEdgesPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(UIW(10), UIW(5), -UIW(10), -UIW(5)))
    }
    
    lazy var msgLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.font = XYFont.Font(size: 10)
        label.textColor = UIColor.FromRGB(0x00FF00)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var performanceCalculator: XYPerformanceCalculator = {
        
        let pc = XYPerformanceCalculator()
        
        pc.onReport = { [weak self] (performanceReport) in
            
            DispatchQueue.main.async {
                
                self?.performanceReportHandle(report: performanceReport)
            }
        }
        
        return pc
    }()
    
    override func singleClick() {
        super.singleClick()
        
        guard let delegate = self.delegateOrNil else { return }
        
        delegate.performanceMonitorClickHandle(monitor: self)
    }
    
    /**
     *    @description 退出此控件并相对处理事项
     *
     */
    func disAppearAndHandle() {
        
        self.performanceCalculator.onReport = nil
        
        self.performanceCalculator.pause()
        
        self.removeFromSuperview()
        
        guard let window = AppDelegate.AppWindow else { return }
        
        window.performanceMonitorOrNil = nil
    }
}

// MARK: - 性能监测
extension XYPerformanceMonitor {
    
    func performanceReportHandle(report: XYPerformanceReport) {
        
        self.msgLabel.text = "C: \(report.cpuUsage.xyDecimalLength(0))%\nM: \(self.performanceCalculator.memoryUsagePercent.xyDecimalLength(0))%"
    }
}

extension XYPerformanceMonitor {
    
    /**
     *    @description 获取已经存在于AppWindow的监控悬浮窗
     *
     */
    static var AppWindowPerformanceMonitorOrNil : XYPerformanceMonitor? {
        
        guard let window = AppDelegate.AppWindow,
            let performanceMonitor = window.performanceMonitorOrNil else { return nil }
        
        return performanceMonitor
    }
    
    /**
     *    @description 使目标ViewController成为代理
     *
     *    @param    viewController    目标ViewController
     *
     */
    static func BecomePerformanceMonitorDelegate(viewController: BaseViewController) {
        
        guard let performanceMonitor = self.AppWindowPerformanceMonitorOrNil else { return }
        
        performanceMonitor.delegateOrNil = viewController
    }
    
    /**
     *    @description 将目标ViewController失去代理权
     *
     *    @param    viewController    目标ViewController
     *
     */
    static func RegisterPerformanceMonitorDelegate(viewController: BaseViewController) {
        
        guard let performanceMonitor = self.AppWindowPerformanceMonitorOrNil,
            let delegate = performanceMonitor.delegateOrNil as? BaseViewController,
            delegate == viewController else { return }
        
        performanceMonitor.delegateOrNil = nil
    }
    
    
}

// MARK: - XYPerformanceMonitor Delegate

protocol XYPerformanceMonitorDelegate {
    
    func performanceMonitorClickHandle(monitor: XYPerformanceMonitor) -> Void
    
    
}
