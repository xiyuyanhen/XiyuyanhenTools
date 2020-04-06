//
//  XYProgressHud.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/5/31.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class XYProgressHudId: NSObject, NSCopying {
    
    
    var hudId: String = ""
    var retaining: Int = 0
    
    class func create(with hudId: String?) -> XYProgressHudId {
        
        let progressHudId = XYProgressHudId()
        progressHudId.hudId = hudId ?? ""
        progressHudId.retaining = 0

        return progressHudId
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let phId = XYProgressHudId()

        phId.hudId = "\(self.hudId)"
        phId.retaining = self.retaining

        return phId
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if (object is XYProgressHudId) && (((object as? XYProgressHudId)?.hudId) == hudId) {
            return true
        }
        return false
    }
    
    override var hash: Int {
        let hash: Int = hudId.hash
        return hash
    }
}



class XYProgressHudManager : NSObject {
    
    //单例
    static let `default` = XYProgressHudManager();
    
    class func ShareManager() -> XYProgressHudManager{
        
        let progressHudManager:XYProgressHudManager = self.default
        
        return progressHudManager;
    }
    
    override private init() {
        
        super.init()
    }
    
    var manageHuds = [XYProgressHudId:UIView]()
    
    /**
     *    @description 添加Hud动画
     *
     *    @param    view    添加Hud动画的目标View
     *
     *    @param    type    Hud动画类型
     *
     *    @param    hudId    Hud id
     *
     *    @param    animated    是否有添加动画
     *
     *    @return   Hud id
     */
    @discardableResult
    class func AddProgressHud(toView:UIView?, animationType:XYProgressHudAnimationType = .FourDots, hudId:XYProgressHudId? = nil)->XYProgressHudId{
        
        let targetView:UIView = toView ?? ProgressHudView!
        
        //检查将要添加HUD动画的View是否已经添加了HUD动画，如果是，那么retaining+1，直接返回DPProgressHudId
        for subHudId in self.default.manageHuds.keys {
            
            let subHud = self.default.manageHuds[subHudId]
            
            if let superView = subHud?.superview {
                
                if superView == targetView {
                    
                    subHudId.retaining += 1
                    return subHudId
                }
            }
        }
        
        //将要添加HUD动画的View不存在已有的HUD动画。。。
        
        let hudId:XYProgressHudId = hudId ?? XYProgressHudId.create(with: self.AutoCreateHudId(NSStringFromClass(type(of: targetView))))
        hudId.retaining += 1
        
        switch animationType {
        case .Normal:
            
            break
            
        case .FourDots:
            
            let gifAnimationView = XYGifAnimationView.Create(gifName: "Loading-effect-Balls-200")
            // MARK: - 动画时长
            gifAnimationView.setupsTimes(newTotalTime: 1.5)
            gifAnimationView.startAnimation()
            gifAnimationView.autoSetDimensions(to: CGSize(width: UIW(100), height: UIW(100)))
            gifAnimationView.show(supView: targetView)
            
            self.default.manageHuds[hudId] = gifAnimationView
            
            break
        }
        
        return hudId
    }
    
    /**
     *    @description 根据hudId及retaining值移除Hud动画
     *
     *    @param    progressHUDId    目标hudId
     *
     *    @param    animated    是否需要动画
     *
     *
     */
    class func RemoveProgressHUD( removeingHudId hudIdOrNil:XYProgressHudId?){
        
        guard let hudId = hudIdOrNil else { return }
        
        for subHud in self.default.manageHuds.keys {
            
            if subHud.hudId == hudId.hudId {
                
                if subHud.retaining > 1 {
                    
                    subHud.retaining -= 1
                }else{
                    
                    subHud.retaining = 0
                    
                    let hudAnimationView = self.default.manageHuds[subHud] as! XYGifAnimationView
                    hudAnimationView.disAppear()
                    
                    self.default.manageHuds.removeValue(forKey: subHud)
                }
                
                break
            }
        }
    }
    
    /**
     *    @description 根据View移除Hud动画
     *
     *    @param    view    目标View
     *
     *    @param    animated    是否需要动画
     *
     *
     */
    class func RemoveAllProgressHUD( targetView:UIView){
        
        var willRemoveHudIds = [XYProgressHudId:UIView]()
        
        for subHudId in self.default.manageHuds.keys {
            
            let hudAnimationView = self.default.manageHuds[subHudId]
            let superView = hudAnimationView?.superview

            if superView == targetView {
                
                willRemoveHudIds[subHudId] = hudAnimationView
            }
        }
        
        guard willRemoveHudIds.count > 0 else {
            
            return
        }
        
        for subHudId in willRemoveHudIds.keys {
            
            self.RemoveProgressHUD(removeingHudId: subHudId)
        }
    }
    
    class func RemoveAllProgressHUD() {
        
        for hudId in self.default.manageHuds.keys {
            
            guard let hudAnimationView = self.default.manageHuds[hudId] as? XYGifAnimationView else { continue }
            
            hudAnimationView.disAppear()
            
            self.default.manageHuds.removeValue(forKey: hudId)
        }
    }

    enum XYProgressHudAnimationType {
//        case System
        case Normal
        case FourDots
    }
    
    class func AutoCreateHudId(_ className: String?) -> String? {

        let microsecond = String.MicroSecondString()
        
        let newClassName = className ?? "unknowClass"
        let hudId = "MBProgressHUD_Id_\(newClassName)_\(microsecond)"
        
        return hudId
    }
}


import UIKit
import ImageIO
import QuartzCore

class XYGifAnimationView : UIView {
    
    private var gifurl:URL!
    private var imageArray:Array<CGImage> = []
    private var timeArray:Array<NSNumber> = []
    private var totalTime:Float = 0
    
    public var speedRate:Float = 1.0
    public var bgView: BaseView?
    
    /// 是否根据动画状态自动隐藏与显示
    public var isAutoHiddenByAnimation: Bool = true
    
    class func Create(gifName:String) -> XYGifAnimationView{

        let gifAnimationView = XYGifAnimationView.newAutoLayout()
        
        gifAnimationView.setups(gifName: gifName)

        gifAnimationView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        gifAnimationView.layer.cornerRadius = 5.0
        gifAnimationView.layer.masksToBounds = true

        return gifAnimationView
    }
    
    /**
     *    @description 当前显示的gif资源是否与gifName相同
     *
     */
    func isEqualGif(gifName: String) -> Bool {
        
        guard let gitUrl = XYBundle.FileURLOfGifByMain(name: gifName),
            self.gifurl.absoluteString == gitUrl.absoluteString else { return false }
        
        return true
    }
    
    func setups(gifName:String){
    
        guard let gitUrl = XYBundle.FileURLOfGifByMain(name: gifName) else { return }
        
        // clear
        self.imageArray.removeAll()
        self.totalTime = 0.0
        
        self.gifurl = gitUrl
        
        let url: CFURL = gitUrl as CFURL
        
        let gifSource = CGImageSourceCreateWithURL(url,nil)
        
        let imageCount = CGImageSourceGetCount(gifSource!)
        
        for i in 0..<imageCount{
            
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i,nil)
            
            self.imageArray.append(imageRef!)
            
            let sourceDict = CGImageSourceCopyPropertiesAtIndex(gifSource!, i,nil)! as NSDictionary
            
            let gifDict = sourceDict.value(forKey:kCGImagePropertyGIFDictionary as String) as! NSDictionary
            
            let time = gifDict.value(forKey:kCGImagePropertyGIFDelayTime as String) as! NSNumber
            
            self.timeArray.append(time)
            
            self.totalTime += time.floatValue
            
        }
        
    }
    
    func setupsTimes(newTotalTime:Float) {
        
        let rate = newTotalTime/self.totalTime
        
        self.speedRate = rate
    }
    
    func startAnimation() {
        
        if self.isAutoHiddenByAnimation {
            
            self.setHidden(false)
        }
        
        let animationLayer: CALayer = self.layer
        
        let animation = CAKeyframeAnimation.init(keyPath:"contents")
        
        var timeKeys:Array<NSNumber> = []
        var current:Float = 0
        let totalTime = self.totalTime * self.speedRate
        
        for time in self.timeArray {
            
            let progress = current/totalTime
            
            timeKeys.append(NSNumber.init(value: progress))
    
            current += (time.floatValue * self.speedRate)
            
        }
        
        animation.keyTimes = timeKeys
        animation.values = self.imageArray
        animation.duration = CFTimeInterval(totalTime)
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        animationLayer.add(animation, forKey:"GIFVIEW")
        
        self.isAnimating = true
    }
    
    var isAnimating : Bool = false
    
    /**
     *    @description 暂停动画
     *
     */
    func suspend() {
        
        if self.isAutoHiddenByAnimation {
            
            self.setHidden(true)
        }
        
        let animationLayer: CALayer = self.layer
        
        animationLayer.speed = 0.0
        
        ///当前暂停的时间
        let pausedTime = animationLayer.convertTime(CACurrentMediaTime(), from: nil)
        
        animationLayer.timeOffset = pausedTime
        
        self.isAnimating = false
    }
    
    /**
     *    @description 停止动画
     *
     */
    func pause() {
        
        if self.isAutoHiddenByAnimation {
            
            self.setHidden(true)
        }

        let animationLayer: CALayer = self.layer
        
        animationLayer.speed = 0.0
        
        // 恢复到第一桢图片
        animationLayer.timeOffset = 0.0
        
        self.isAnimating = false
    }
    
    /**
     *    @description 恢复动画
     *
     */
    func resume() {
        
        if self.isAutoHiddenByAnimation {
            
            self.setHidden(false)
        }
        
        let animationLayer: CALayer = self.layer
        
//        let pausedTime = animationLayer.timeOffset
//        let timeSincePause = animationLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        
        animationLayer.speed = 1.0
        animationLayer.timeOffset = 0.0
        animationLayer.beginTime = 0.0
        
//        animationLayer.beginTime = timeSincePause
        
        self.isAnimating = true
    }
    
    func show(supView:UIView?, _ needBgView:Bool = true){
        
        var superView:UIView
        if supView != nil {
            
            superView = supView!
        }else{
            
            superView = ProgressHudView!
        }
        
        if needBgView {
            
            let bgView = BaseView.newAutoLayout()
            bgView.backgroundColor = UIColor.FromRGB(0x000000)
            bgView.alpha = 0.5
            
            superView.addSubview(bgView)
            
            bgView.autoEdgesPinView(otherView: superView)
            
            self.bgView = bgView
        }
        
        superView.addSubview(self)
        
        self.autoAlignAxis(.horizontal, toSameAxisOf: superView)
        self.autoAlignAxis(.vertical, toSameAxisOf: superView)
    }
    
    func disAppear() {
        
        if let bgView = self.bgView {
            
            bgView.removeFromSuperview()
        }
        
        self.removeFromSuperview()
    }
    
    lazy var tapGR: UITapGestureRecognizer = {
        
        let tapGR = UITapGestureRecognizer()
        
//        tapGR.rx.event.subscribe(onNext: { [weak self] (tapGR) in
//
//            guard let weakSelf = self else { return }
//
//        }).disposed(by: self.disposeBag)
        
        self.addGestureRecognizer(tapGR)
        
        return tapGR
    }()
    
}

extension XYGifAnimationView {
    
    
}
