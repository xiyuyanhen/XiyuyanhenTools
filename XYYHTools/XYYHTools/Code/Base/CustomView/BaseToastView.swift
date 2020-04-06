//
//  BaseToastView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/6/24.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

func DebugNote(tip tipOrNil:String?, showTime:TimeInterval = 5.0, tipContentBlock:BaseToastView.TipContentBlock? = nil) {
    
    guard XYLog.Share().printTarget != XYLogPrintTarget.None else { return }
    
    var showTipOrNil : String?
    
    if let tip = tipOrNil,
        tip.isNotEmpty {
        
        showTipOrNil = tip
        
    }else if let block = tipContentBlock {
        
        let tempTip = block()
        
        if tempTip.isNotEmpty {
            
            showTipOrNil = tempTip
        }
    }
    
    guard let showTip = showTipOrNil else { return }
    
    BaseToastView.Show(tip: showTip, showTime: showTime)
}

class BaseToastView : BaseView {
    
    typealias TipContentBlock = () -> String
    
    //单例
    static let `default` = BaseToastView.defaultView();
    
    private class func defaultView() -> BaseToastView{
        
        let view:BaseToastView = self.newAutoLayout()
        
        view.isUserInteractionEnabled = false
        
        return view;
    }
    
    @discardableResult class func Show(tip:String, showTime:TimeInterval = 3.0) -> BaseToastView{
        
        let toastView = self.default

        guard tip.isNotEmpty else { return toastView }
        
        if toastView.superview != nil {
            
            
        }else if let targetView = AppDelegate.AppWindow {
            
            targetView.addSubview(toastView)
            
            toastView.autoAlignAxis(.vertical, toSameAxisOf: targetView)
            toastView.autoPinEdge(.bottom, to: .bottom, of: targetView, withOffset: UIW(-100))
            toastView.autoPinEdge(.leading, to: .leading, of: targetView, withOffset: UIW(14), relation: .greaterThanOrEqual)
            toastView.autoPinEdge(.trailing, to: .trailing, of: targetView, withOffset: UIW(14), relation: .lessThanOrEqual)
        }
        
        toastView.appendSubTip(tip: tip, showTime: showTime)
        
        return toastView
    }
    
    var tipLabel:BaseLabel = BaseLabel.newAutoLayout()
    
    override func initProperty() {
        super.initProperty()
        
        self.tipLabel.text = ""
        self.tipLabel.font = XYFont.Font(size: 14)
        self.tipLabel.textColor = UIColor.FromRGB(0xffffff)
        self.tipLabel.numberOfLines = 0
        self.tipLabel.textAlignment = NSTextAlignment.center
        
        self.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.black)
        self.alpha = 0.5
        self.xyCornerRadius = UIView.XYCornerRadius(5.0)
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.tipLabel)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.tipLabel.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(UIW(10), UIW(25), UIW(-10), UIW(-25)), edges: .top, .leading, .bottom, .trailing)
    }
    
    var tipModelsArr = [TipModel]()
    
    var tipAll:String {
        
        var result:String = ""
        
        for subTipModel in self.tipModelsArr {
            
            let subText = subTipModel.text
            
            if result.count > 0{
                
                result = "\n" + result
            }
            
            result = subText + result
        }
        
        return result
    }
    
    lazy var timer: Timer = {
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerHandle(timer:)), userInfo: nil, repeats: true)
        
        //定时器暂停
        timer.fireDate = Date.distantFuture
        
        return timer
    }()
    
    @objc func timerHandle(timer:Timer) {
        
        self.updateTipContent()
    }
    
    func changeTimerState() {
        
        if self.tipModelsArr.count > 0 {
            
            self.timer.fireDate = Date.distantPast
        }else {
            
            self.timer.fireDate = Date.distantFuture
        }
    }
    
    func appendSubTip(tip:String, showTime:TimeInterval) {
        
        let key = tip.MD5String()
        let disAppearTime = Date.timeIntervalSinceReferenceDate + showTime
        
        let model = TipModel(key: key, text: tip, disAppearTime: disAppearTime)
    
        self.updateTipContent(insertModel: model)
    }
    
    func updateTipContent(insertModel:TipModel? = nil) {
        
        var newTipModelsArr = [TipModel]()
        let oldModelCount:Int = self.tipModelsArr.count
        
        if let model = insertModel {
            
            newTipModelsArr.append(model)
        }
        
        for tipModel in self.tipModelsArr {
            
            let nowTime = Date.timeIntervalSinceReferenceDate
            let disTime = tipModel.disAppearTime
            guard nowTime < disTime else {
                
                //有过期的tip
                continue
            }
            
            newTipModelsArr.append(tipModel)
        }

        self.tipModelsArr.removeAll()
        self.tipModelsArr = newTipModelsArr
        let newModelCount = self.tipModelsArr.count
        
        guard (newModelCount != oldModelCount) else { return }
        
        self.changeTimerState()
        
        guard self.tipModelsArr.count > 0 else {
            
            self.tipLabel.text = ""
            self.disAppear()
            return
        }
        
        self.tipLabel.text = self.tipAll
        
    }
    
    func disAppear() {
        
        self.removeFromSuperview()
    }
    
    struct TipModel {
        
        let key:String
        let text:String
        let disAppearTime:TimeInterval
        
        init(key:String, text:String, disAppearTime:TimeInterval) {
            
            self.key = key
            self.text = text
            self.disAppearTime = disAppearTime
        }
    }
}
