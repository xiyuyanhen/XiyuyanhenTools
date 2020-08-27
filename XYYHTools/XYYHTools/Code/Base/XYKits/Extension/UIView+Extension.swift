//
//  UIView+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/4.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
import QuartzCore.CALayer

// MARK: - Rx - disposeBag
import RxSwift
import RxCocoa

// MARK: - Rx

protocol UIView_RxObject_Extension {
    
}

extension UIView_RxObject_Extension where Self: UIView {
    
    var xyRxControlStateObservable: PublishSubject<(Self, UIView.XYControlState?)> {
        
        set{
            objc_setAssociatedObject(self, &UIView.XYRx_XYViewAndControlState_NameKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            
            guard let newValue = objc_getAssociatedObject(self, &UIView.XYRx_XYViewAndControlState_NameKey) as? PublishSubject<(Self, UIView.XYControlState?)> else {
                
                let newValue = PublishSubject<(Self, UIView.XYControlState?)>()

                self.xyRxControlState.distinctUntilChanged().subscribe(onNext: { [weak self] (stateOrNil) in
                    guard let weakSelf = self else { return }
                    
                    newValue.onNext((weakSelf, stateOrNil))
                    
                }).disposed(by: self.disposeBag)
                
                return newValue
            }
            
            return newValue
        }
    }
    
    /// 更新 UIView.XYControlState 状态
    @discardableResult func setXYControlState(_ stateOrNil: UIView.XYControlState?) -> Self {
        
        self.xyControlStateOrNil = stateOrNil
        
        return self
    }
    
}

extension UIView: UIView_RxObject_Extension {}

extension UIView {
    
    static private let XYDisposeBagNameKey = UnsafeRawPointer.init(bitPattern: "UIView_DisposeBag_Key".hashValue)
    var disposeBag: DisposeBag {
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYDisposeBagNameKey!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            
            guard let bag = objc_getAssociatedObject(self, UIView.XYDisposeBagNameKey!) as? DisposeBag else {
                
                let newBag = DisposeBag()
                
                self.disposeBag = newBag
                
                return newBag
            }
            
            return bag
        }
    }
    
    static private var XYRxLayoutSubviewsNameKey: String = "UIView_XYRxLayoutSubviews_NameKey"
    private var _xyRxLayoutSubviewsOrNil: PublishSubject<CGRect>? {
        
        set{
            
            objc_setAssociatedObject(self, &UIView.XYRxLayoutSubviewsNameKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get{
            
            guard let newValue = objc_getAssociatedObject(self, &UIView.XYRxLayoutSubviewsNameKey) as? PublishSubject<CGRect> else { return nil }
            
            return newValue
        }
    }
    
    private var rxLayoutSubviews: PublishSubject<CGRect> {
        
        guard let value = self._xyRxLayoutSubviewsOrNil else {
            
            let newValue = PublishSubject<CGRect>()
            
            self._xyRxLayoutSubviewsOrNil = newValue
            
            return newValue
        }
        
        return value
    }
    
    var rxLayoutSubviewsObservable: Observable<CGRect> {

        return self.rxLayoutSubviews.distinctUntilChanged { (value, newValue) -> Bool in
            
            guard (newValue.isZero == false) else { return true }
            
            let result = (value.width != newValue.width) || (value.height != newValue.height)
            
            return !result
        }
    }
    
    static private var XYRx_XYControlState_NameKey: String = "UIView_XYRx_XYControlState_NameKey"
    
    fileprivate var xyRxControlState: BehaviorRelay<UIView.XYControlState?> {
        
        set{
            objc_setAssociatedObject(self, &UIView.XYRx_XYControlState_NameKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            
            guard let newValue = objc_getAssociatedObject(self, &UIView.XYRx_XYControlState_NameKey) as? BehaviorRelay<UIView.XYControlState?> else {
                
                let newValue = BehaviorRelay<UIView.XYControlState?>(value: nil)
                
                self.xyRxControlState = newValue
                
                return newValue
            }
            
            return newValue
        }
    }
    
    /// 当前 UIView.XYControlState 状态
    var xyControlStateOrNil: UIView.XYControlState? {
        
        get { return self.xyRxControlState.value }
        
        set { self.xyRxControlState.accept(newValue) }
    }
    
    static var XYRx_XYViewAndControlState_NameKey: String = "UIView_XYRx_XYViewAndControlState_NameKey"
    
}

extension UIView : XYNibLoadViewProtocol { }

//extension UIView : XYViewNewAutoLayoutProtocol {
//
//    func initProperty() {
//

//    }
//
//    func layoutAddViews() {
//

//    }
//
//    func layoutAllViews() {
//

//    }
//
//
//
//}

// MARK: - Runtime 方法替换
extension UIView {
    
    class func XY_MethodSwizzing_LayoutSubviews() {
        
        XYLog.LogNoteBlock { () -> String? in
            
            return "[Runtime-Method_Swizzing] UIView: layoutSubviews 替换为 xyLayoutSubviews"
        }
        
        /*
         layoutSubviews这个方法，默认没有做任何事情，需要子类进行重写 。 系统在很多时候会去调用这个方法，初始化不会触发layoutSubviews，但是如果设置了不为CGRectZero的frame的时候就会触发。
         */
        
        let originalSelector = #selector(self.layoutSubviews)
        let swizzledSelector = #selector(self.xyLayoutSubviews)
        
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        
        //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        
        if didAddMethod {
            
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    /**
     *    @description 替换layoutSubviews
     *
     */
    @objc func xyLayoutSubviews() {
        
        self._xyRxLayoutSubviewsOrNil?.onNext(self.frame)

        guard let (layer, isDashLine) = self.shapeLayerEdgeCorner() else { return }
        
        guard isDashLine else {
            
            self.layer.masksToBounds = true
            self.layer.mask = layer
            return
        }
    
        if let sublayers = self.layer.sublayers {
            
            for sublayer in sublayers {
                
                guard let tag = sublayer.xyExtraDataOrNil as? String,
                    tag == UIView.DashLineShapeLayerTag  else { continue }
                
                sublayer.removeFromSuperlayer()
            }
        }
        
        self.layer.addSublayer(layer)
    }
}

// MARK: - Public Function
extension UIView{
    
    enum XYViewState : Int{
        case Unknow
        case DidLoad
        case WillAppear
        case DidAppear
        case WillDisappear
        case DidDisappear
        
        func nextState() -> XYViewState {
            
            let currentNum = self.rawValue
            
            var nextNum = currentNum + 1
            
            if 4 < nextNum {
                
                nextNum = 0
            }
            
            guard let newState = XYViewState(rawValue: nextNum) else { return .Unknow }
            
            return newState
        }
    }
    
    func addSubviews(_ subViews: UIView...) {
        
        for subView in subViews {
            
            self.addSubview(subView)
        }
    }
    
    func removeSubviews() {
        
        for view in self.subviews {
            
            view.removeFromSuperview()
        }
    }
    
    func removeSubviewsConstraints() {
        
        for view in self.subviews {
            
            view.removeAllConstraints()
        }
    }
    
    func removeAllConstraints() {
        
        let constraints = self.constraints
        self.removeConstraints(constraints)
    }
    
    var originBottomY : CGFloat {
        
        let y = self.frame.origin.y
        let height = self.frame.size.height
        
        let bottomY = y + height
        
        return bottomY
    }
    
    var originRightX : CGFloat {
        
        let x = self.frame.origin.x
        let width = self.frame.size.width
        
        let rightX = x + width
        
        return rightX
    }
}

extension UIView {
    
    /**
     *    @description 添加长按手势
     *
     */
    var xyAddLongPressGR: UILongPressGestureRecognizer {
        
        self.isUserInteractionEnabled.xyRunBlockWhenFalse {
            // 如果当前不响应交互，则修改
            
            self.setUserInteraction(true)
        }
        
        let newValue = UILongPressGestureRecognizer()
        
        self.addGestureRecognizer(newValue)
        
        return newValue
    }
    
    /// 添加点击手势并返回该手势
    var xyAddTapGR: UITapGestureRecognizer {
        
        self.isUserInteractionEnabled.xyRunBlockWhenFalse {
            // 如果当前不响应交互，则修改
            
            self.setUserInteraction(true)
        }
    
        let newValue = UITapGestureRecognizer()

//        newValue.rx.event.subscribe(onNext: { [weak self] (tapGR) in
//            guard let weakSelf = self else { return }
//
//        }).disposed(by: self.disposeBag)

        self.addGestureRecognizer(newValue)
        
        return newValue
    }
}

// MARK: - XYControlState

extension UIView {
    
    enum XYControlState : Int, XYEnumTypeAllCaseProtocol {
        case normal
        case abNormal
        case selected
        case disable
        case highlighted
        
        case Success
        case Failure
        
        case willPlay
        case playing
        case willSuspend
        case willStop
        case buffering
        case Recording
    }
}

// MARK: - 添加阴影效果
extension UIView {
    
    struct XYGradientConfig : Equatable {
    
        var startPoint: CGPoint
        var endPoint: CGPoint
        var colors : [XYColorARGB]
        
        var typeOrNil: CAGradientLayerType?
        
        init(startPoint: CGPoint, endPoint: CGPoint, colors : [XYColorARGB]) {
            
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.colors = colors
        }
        
        init(startPoint: CGPoint, endPoint: CGPoint, colors : XYColorARGB...) {
            
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.colors = colors
        }
        
        var colorsForLayer : [Any] {
            
            var results = [Any]()
            
            for colorValue in self.colors {
                
                results.append(XYColor(argb: colorValue).cgcolor)
            }
            
            return results
        }
        
        var createShadowOrGradientConfig : XYShadowOrGradientConfig {
            
            return XYShadowOrGradientConfig(gradientConfig: self)
        }
    }
    
    struct XYShadowConfig : Equatable {
        
        var offset:CGSize = CGSize(width: 3, height: 3)
        var color : UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.black)
        var opacity:Float = 0.5
        var shadowRadius: CGFloat = UIW(8)
        
        init(offset: CGSize = CGSize(width: 3, height: 3)) {
            
            self.offset = offset
        }
        
        var createShadowOrGradientConfig : XYShadowOrGradientConfig {
            
            return XYShadowOrGradientConfig(shadowConfig: self)
        }
    }
    
    struct XYShadowOrGradientConfig : Equatable {
        
        var cornerRadiusOrNil : CGFloat?
        
        var bgColorOrNil: UIColor?
        
        var borderColorARGBOrNil : XYColorARGB?
        var borderWidthOrNil : CGFloat?
        
        //阴影相关属性
        var shadowConfigOrNil : XYShadowConfig?
        
        //渐变色相关属性
        var gradientConfigOrNil : XYGradientConfig?
        
        init(shadowConfig sc: XYShadowConfig) {
            
            self.shadowConfigOrNil = sc
        }
        
        init(gradientConfig gc : XYGradientConfig) {
            
            self.gradientConfigOrNil = gc
        }
        
        init(shadowConfig sc: XYShadowConfig, gradientConfig gc : XYGradientConfig) {
            
            self.shadowConfigOrNil = sc
            self.gradientConfigOrNil = gc
        }
    }
    
    static private let XYShadowOrGradientConfigNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYShadowOrGradientConfig_Key".hashValue)
    var xyShadowOrGradientOrNil : XYShadowOrGradientConfig? {
        
        set{
            
            let oldValueOrNil = self.xyShadowOrGradientOrNil
            
            objc_setAssociatedObject(self, UIView.XYShadowOrGradientConfigNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            guard let value = newValue else {
                
                //清理
                self.xyShadowConfigRxOrNil?.dispose()
                return
            }
            
            //若为空，设置
            guard self.xyShadowConfigRxOrNil == nil else {
                
                guard let oldValue = oldValueOrNil,
                    oldValue != value else { return }
                
                self.setupsShadow(config: value)
                
                return
            }
            
            let dBag = self.rx.observe(CGRect.self, "bounds")
                .takeUntil(self.rx.sentMessage(#selector(self.removeFromSuperview)))
                .subscribe(onNext: { [weak self] (frameOrNil) in
                    
                    guard let config = self?.xyShadowOrGradientOrNil else { return }
                    
                    self?.setupsShadow(config: config)
                    
                })
            dBag.disposed(by: self.disposeBag)
            
            self.xyShadowConfigRxOrNil = dBag
        }
        
        get{
            guard let config = objc_getAssociatedObject(self, UIView.XYShadowOrGradientConfigNameKey!) as? XYShadowOrGradientConfig else {
                
                return nil
            }
            
            return config
        }
    }
    
    static private let XYShadowLayerNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYShadowLayer_Key".hashValue)
    fileprivate var xyShadowLayerOrNil:CAGradientLayer?{
        
        set{
            objc_setAssociatedObject(self, UIView.XYShadowLayerNameKey!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            
            let layer = objc_getAssociatedObject(self, UIView.XYShadowLayerNameKey!) as? CAGradientLayer
            
            return layer
        }
    }
    
    static private let XY_ShadowConfigDisposable_NameKey = UnsafeRawPointer.init(bitPattern: "UIView_ShadowConfigDisposable_Key".hashValue)
    private var xyShadowConfigRxOrNil:Disposable?{
        
        set{
            objc_setAssociatedObject(self, UIView.XY_ShadowConfigDisposable_NameKey!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            
            let disposable = objc_getAssociatedObject(self, UIView.XY_ShadowConfigDisposable_NameKey!) as? Disposable
            
            return disposable
        }
    }
    
    fileprivate func setupsShadow(config: XYShadowOrGradientConfig) {
        
        let frame = self.frame
        
        if let oldShadow = self.xyShadowLayerOrNil {
            
            oldShadow.removeFromSuperlayer()
            
            self.xyShadowLayerOrNil = nil
        }
        
        let shadowLayer = CAGradientLayer()
        shadowLayer.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        
        shadowLayer.masksToBounds = false
        
        if let borderWidth = config.borderWidthOrNil,
            let borderColorARGB = config.borderColorARGBOrNil {
            
            shadowLayer.borderWidth = borderWidth
            shadowLayer.borderColor = XYColor(argb: borderColorARGB).cgcolor
        }
        
        if let cornerRadius = config.cornerRadiusOrNil {
            
            shadowLayer.cornerRadius = cornerRadius
        }
        
        if let bgColor = config.bgColorOrNil {
            
            shadowLayer.backgroundColor = bgColor.cgColor
            
        }else if let bgColor = self.backgroundColor {
            
            shadowLayer.backgroundColor = bgColor.cgColor
        }
        
        if let shadowConfig = config.shadowConfigOrNil {
            
            shadowLayer.shadowOffset = shadowConfig.offset
            shadowLayer.shadowRadius = shadowConfig.shadowRadius //阴影的发散长度，值越大，颜色越淡
    
            shadowLayer.shadowColor = shadowConfig.color.cgColor
            shadowLayer.shadowOpacity = shadowConfig.opacity
        }
        
        if let gradientConfig = config.gradientConfigOrNil {
            
            shadowLayer.startPoint = gradientConfig.startPoint
            shadowLayer.endPoint = gradientConfig.endPoint
            
            shadowLayer.colors = gradientConfig.colorsForLayer
        }
        
        
//        self.layer.addSublayer(shadowLayer)
        self.layer.insertSublayer(shadowLayer, at: 0)
        
        self.layer.masksToBounds = false
        self.xyShadowLayerOrNil = shadowLayer
    }
    
    /**
     *    @description
     *
     *    @param    cornerRadius    圆角
     *
     */
    func shadowOrGradientConfigForNormal(cornerRadius cornerRadiusOrNil: CGFloat? = nil) -> XYShadowOrGradientConfig? {
        
        var colors: [XYColorARGB]

        switch APP_CurrentTarget {
        case .ShiTingShuo:
            
            colors = [XYColor.CustomColor.main.argb, 0xFF4471F8]
            
            break
            
        case .Xiyou:
            
            colors = [XYColor.CustomColor.main.argb, 0xFFFFB383]
            
            break
        }
        
        var config = UIView.XYGradientConfig(startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5), colors: colors).createShadowOrGradientConfig
        
        if let cornerRadius = cornerRadiusOrNil,
            0.0 < cornerRadius {
            
            config.cornerRadiusOrNil = cornerRadius
        }
        
        return config
    }
    
    /**
     *    @description 渐进式颜色(左深右浅)
     *
     *    @param    cornerRadius    圆角
     *
     */
    @discardableResult func setShadowOrGradientForNormal(cornerRadius cornerRadiusOrNil: CGFloat? = nil) -> XYShadowOrGradientConfig? {
        
        guard let config = self.shadowOrGradientConfigForNormal(cornerRadius: cornerRadiusOrNil) else { return nil }
        
        self.xyShadowOrGradientOrNil = config
        
        return config
    }
    
    /**
     *    @description 渐进式颜色(左白右透明)
     *
     *    @param    cornerRadius    圆角
     *
     */
    @discardableResult func setShadowOrGradientForHorizontalWhite(cornerRadius cornerRadiusOrNil: CGFloat? = nil) -> XYShadowOrGradientConfig? {
        
        var config = UIView.XYGradientConfig(startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0), colors: 0xffffffff, 0x00ffffff).createShadowOrGradientConfig
        config.bgColorOrNil = XYColor(custom: .clear).uicolor
        
        if let cornerRadius = cornerRadiusOrNil,
            0.0 < cornerRadius {
            
            config.cornerRadiusOrNil = cornerRadius
        }
        
        self.xyShadowOrGradientOrNil = config
        
        return config
    }
    
    
}

// MARK: - 渐变色
extension UIView {
    
    static private let XYGradientLayerNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYGradientLayer_Key".hashValue)
    var xyGradientLayerOrNil:CAGradientLayer?{
        
        set{
            objc_setAssociatedObject(self, UIView.XYGradientLayerNameKey!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            
            let layer = objc_getAssociatedObject(self, UIView.XYGradientLayerNameKey!) as? CAGradientLayer
            
            return layer
        }
    }
    
    func setupsGradient() {
        
        let frame = self.frame
    
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        
        //设置开始和结束位置(设置渐变的方向)
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)

        layer.colors = [UIColor.FromRGB(0x15D524).cgColor, UIColor.FromRGB(0x45EF89).cgColor]
        
        if self.xyShadowLayerOrNil == nil {
            
            self.layer.insertSublayer(layer, at: 0)
        }else {
            
            self.layer.insertSublayer(layer, at: 1)
        }
        
        self.xyGradientLayerOrNil = layer
    }
}

// MARK: - 四周圆角
extension UIView {
    
    public struct XYDashLineConfig {
        
        public var pattern: [NSNumber]
        
        public var fillColor: XYColorARGB = XYColor.CustomColor.clear.argb
        public var strokeColor: XYColorARGB = XYColor.CustomColor.x979797.argb
        public var lineWidth: CGFloat = 1.0
        
        public init(_ pattern: [NSNumber] = [NSNumber(value: 4), NSNumber(value: 5)]) {
            
            self.pattern = pattern
        }
    }
    
    public struct XYCornerRadius {
        
        public var topLeft : CGFloat
        
        public var topRight : CGFloat
        
        public var bottomLeft : CGFloat
        
        public var bottomRight : CGFloat
        
        public var dashLineConfigOrNil: XYDashLineConfig?
        
        public init(_ radius:CGFloat = 0.0) {
            
            self.topLeft = radius
            self.topRight = radius
            self.bottomLeft = radius
            self.bottomRight = radius
        }
        
        public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat){
            
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }
        
        var isNeedMask : Bool {
            
            let count = self.topLeft + self.topRight + self.bottomLeft + self.bottomRight
            
            return (0.0 < count)
        }
    }
    
    static private let XYCornerRadiusNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYCornerRadius_Key".hashValue)
    var xyCornerRadius:XYCornerRadius{
        set{
            
            objc_setAssociatedObject(self, UIView.XYCornerRadiusNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get{
            guard let xycr = objc_getAssociatedObject(self, UIView.XYCornerRadiusNameKey!) as? XYCornerRadius else {
                
                return XYCornerRadius()
            }
            
            return xycr
        }
    }
    
    // MARK: - 切割异形View
    
    /// 虚线标识
    static let DashLineShapeLayerTag: String = "DashLineShapeLayer"
    
    // MARK: - 添加圆角(与cornerRadius属性配合使用)
    /**
     *    @description 添加圆角(与cornerRadius属性配合使用)
     *
     */
    func shapeLayerEdgeCorner() -> (layer: CAShapeLayer, isDashLine: Bool)? {
        
        guard self.xyCornerRadius.isNeedMask else { return nil }
        
        let rect: CGRect = self.bounds
        let width: CGFloat = rect.size.width
        let height: CGFloat = rect.size.height
        let bezierPath = UIBezierPath()
        var startPoint: CGPoint
        //topLeft
        let masksToTopLeft: Bool = Bool(self.xyCornerRadius.topLeft > 0.0)
        if masksToTopLeft {
            var radius = CGFloat(self.xyCornerRadius.topLeft)
            startPoint = CGPoint(x: 0, y: radius)
            bezierPath.move(to: startPoint)
            let clockwise: Bool = radius >= 0
            if !clockwise {
                radius = -radius
            }
            var center: CGPoint
            var startAngle: CGFloat
            var endAngle: CGFloat
            if clockwise {
                center = CGPoint(x: radius, y: radius)
                startAngle = CGFloat.pi
                endAngle = startAngle + (CGFloat.pi / 2)
            } else {
                center = CGPoint(x: 0, y: 0)
                startAngle = (CGFloat.pi / 2)
                endAngle = startAngle - (CGFloat.pi / 2)
            }
            bezierPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        } else {
            startPoint = CGPoint(x: 0, y: 0)
            bezierPath.move(to: startPoint)
        }
        
        //topRight
        let masksToTopRight: Bool = Bool(self.xyCornerRadius.topRight > 0.0)
        if masksToTopRight {
            var radius = CGFloat(self.xyCornerRadius.topRight)
            bezierPath.addLine(to: CGPoint(x: width - radius, y: 0))
            let clockwise: Bool = radius >= 0
            if !clockwise {
                radius = -radius
            }
            var center: CGPoint
            var startAngle: CGFloat
            var endAngle: CGFloat
            if clockwise {
                center = CGPoint(x: width - radius, y: radius)
                startAngle = CGFloat.pi + (CGFloat.pi / 2)
                endAngle = startAngle + (CGFloat.pi / 2)
            } else {
                center = CGPoint(x: width, y: 0)
                startAngle = CGFloat.pi
                endAngle = startAngle - (CGFloat.pi / 2)
            }
            bezierPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: 0))
        }
        //bottomRight
        let masksToBottomRight: Bool = Bool(self.xyCornerRadius.bottomRight > 0.0)
        if masksToBottomRight {
            var radius = CGFloat(self.xyCornerRadius.bottomRight)
            bezierPath.addLine(to: CGPoint(x: width, y: height - radius))
            let clockwise: Bool = radius >= 0
            if !clockwise {
                radius = -radius
            }
            var center: CGPoint
            var startAngle: CGFloat
            var endAngle: CGFloat
            if clockwise {
                center = CGPoint(x: width - radius, y: height - radius)
                startAngle = 0
                endAngle = startAngle + (CGFloat.pi / 2)
            } else {
                center = CGPoint(x: width, y: height)
                startAngle = CGFloat.pi + (CGFloat.pi / 2)
                endAngle = startAngle - (CGFloat.pi / 2)
            }
            bezierPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: height))
        }
        
        //bottomLeft
        let masksToBottomLeft: Bool = Bool(self.xyCornerRadius.bottomLeft > 0.0)
        if masksToBottomLeft {
            var radius = CGFloat(self.xyCornerRadius.bottomLeft)
            bezierPath.addLine(to: CGPoint(x: radius, y: height))
            let clockwise: Bool = radius >= 0
            if !clockwise {
                radius = -radius
            }
            var center: CGPoint
            var startAngle: CGFloat
            var endAngle: CGFloat
            if clockwise {
                center = CGPoint(x: radius, y: height - radius)
                startAngle = (CGFloat.pi / 2)
                endAngle = startAngle + (CGFloat.pi / 2)
            } else {
                center = CGPoint(x: 0, y: height)
                startAngle = 0
                endAngle = startAngle - (CGFloat.pi / 2)
            }
            bezierPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        } else {
            bezierPath.addLine(to: CGPoint(x: 0, y: height))
        }
        
        bezierPath.addLine(to: startPoint)
        
        bezierPath.close()
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = bezierPath.cgPath
        
        // 虚线
        guard let dashLineConfig = self.xyCornerRadius.dashLineConfigOrNil else {
            
            return (layer: maskLayer, isDashLine: false)
        }
        
        maskLayer.xyExtraDataOrNil = UIView.DashLineShapeLayerTag
        
        maskLayer.fillColor = XYColor(argb: dashLineConfig.fillColor).cgcolor
        maskLayer.strokeColor = XYColor(argb: dashLineConfig.strokeColor).cgcolor
        maskLayer.lineWidth = dashLineConfig.lineWidth
        
        maskLayer.lineCap = .square
        maskLayer.lineDashPattern = dashLineConfig.pattern
        
        return (layer: maskLayer, isDashLine: true)
    }
}

// MARK: - AutoLayout属性集
extension UIView {
    
    public struct XYLayoutConstraints {
        
        public var top: NSLayoutConstraint? = nil
        public var leading: NSLayoutConstraint? = nil
        public var trailing: NSLayoutConstraint? = nil
        public var bottom: NSLayoutConstraint? = nil
        
        public var height: NSLayoutConstraint? = nil
        public var width: NSLayoutConstraint? = nil
        
        public var horizontal: NSLayoutConstraint? = nil
        public var vertical: NSLayoutConstraint? = nil
        
        @discardableResult func adjust(edge: ALEdge, _ constant: CGFloat) -> XYLayoutConstraints {
            switch edge {
            case ALEdge.top:
                self.top?.constant = constant
                return self
                
            case ALEdge.leading, ALEdge.left:
                self.leading?.constant = constant
                return self
                
            case ALEdge.bottom:
                self.bottom?.constant = constant
                return self
                
            case ALEdge.trailing, ALEdge.right:
                self.trailing?.constant = constant
                return self
            @unknown default: return self
            }
        }
        
        @discardableResult func adjust(dimension: ALDimension, _ constant: CGFloat) -> XYLayoutConstraints {
            switch dimension {
            case ALDimension.width:
                self.width?.constant = constant
                return self
            
            case ALDimension.height:
                self.height?.constant = constant
                return self
                
            @unknown default: return self
            }
        }
        
        @discardableResult func adjust(axis: ALAxis, _ constant: CGFloat) -> XYLayoutConstraints {
            switch axis {
            case ALAxis.horizontal:
                self.horizontal?.constant = constant
                return self
            
            case ALAxis.vertical:
                self.vertical?.constant = constant
                return self
                
            default: return self
            }
        }
    }
    
    static private let XYLayoutConstraintsNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYLayoutConstraints_Key".hashValue)
    var xyLayoutConstraints:XYLayoutConstraints{
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYLayoutConstraintsNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get{
            guard let layoutConstraints = objc_getAssociatedObject(self, UIView.XYLayoutConstraintsNameKey!) as? XYLayoutConstraints else {
                
                return XYLayoutConstraints()
            }
            
            return layoutConstraints
        }
    }
    
//
    
    static private let XYIsDidUpdateConstraintsNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYIsDidUpdateConstraints_Key".hashValue)
    var xyIsDidUpdateConstraints : Bool{
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYIsDidUpdateConstraintsNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get{
            guard let isDidUpdateConstraints = objc_getAssociatedObject(self, UIView.XYIsDidUpdateConstraintsNameKey!) as? Bool else {
                
                return false
            }
            
            return isDidUpdateConstraints
        }
    }
}

// MARK: - Add Line
extension UIView {
    
    @discardableResult
    func addLine(_ edge: ALEdge, size: CGFloat, color bgColor: UIColor?) -> UIView {
        
        return addLine(edge, size: size, color: bgColor, edgeInsets: UIEdgeInsets.zero)
    }
    
    @discardableResult
    func addLine(_ edge: ALEdge, size: CGFloat, color bgColor: UIColor?, edgeInsets: UIEdgeInsets) -> UIView {
        
        let line = UIView.newAutoLayout()
        
        if bgColor != nil {
            line.backgroundColor = bgColor
        }
        
        addSubview(line)
        
        if edge == ALEdge.top || edge == ALEdge.bottom {
            //若为Top/Bottom
            
            line.autoSetDimension(ALDimension.height, toSize: size)
            line.autoPinView(otherView: self, edgeInsets: edgeInsets, edges: ALEdge.leading, ALEdge.trailing, edge)
            
        } else if edge == ALEdge.leading || edge == ALEdge.trailing || edge == ALEdge.left || edge == ALEdge.right {
            //若为Left/Right
            
            line.autoSetDimension(ALDimension.width, toSize: size)
            line.autoPinView(otherView: self, edgeInsets: edgeInsets, edges: ALEdge.top, ALEdge.bottom, edge)
            
        }
        
        return line
    }
    
    /**
     *    @description 将本视图添加到父视图
     *
     *    @param    edgeInsets    本视图与父视图的四周间距
     *
     *    @param    superViewOrNil    指定的父视图(可无)
     *
     *    @return   父视图
     */
    @discardableResult func addToSuperView(edgeInsets: UIEdgeInsets, superViewOrNil: UIView? = nil) -> UIView {
        
        let newValue = superViewOrNil ?? UIView.newAutoLayout()
        
        newValue.addSubview(self)
        
        self.autoEdgesPinView(otherView: newValue, edgeInsets: edgeInsets)
        
        return newValue
    }
}

// MARK: - ExtraData
extension UIView {
    
    static private let XYExtraDataNameKey = UnsafeRawPointer.init(bitPattern: "UIView_XYExtraData_Key".hashValue)
    var xyExtraDataOrNil:Any?{
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYExtraDataNameKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get{
            guard let extraDic = objc_getAssociatedObject(self, UIView.XYExtraDataNameKey!) else {
                
                return nil
            }
            
            return extraDic
        }
    }
}

extension UIView {
    
    /// 以自动布局更新Frame值并关闭自动布局
    func xyUpdateFrameFromAutoLayout() {
    
        self.xyAdjustFrameBySystemLayoutFittedSize()
        
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    /// 修改视图的位置
    func changeFrameByNewOrigin(_ origin: CGPoint = CGPoint.zero) {
        
        var newValue = self.frame
        newValue.origin = origin
        
        self.frame = newValue
    }
    
}

// MARK: - systemLayoutSizeFitting系统方法的相关拓展
extension UIView {
    
    /**
     *    @description 使用系统方法根据约束条件所确定的视图宽度重新计算正确的视图高度
     *
     *    @param    width 视图的宽度
     *
     *    @param    referenceHeight 视图参考高度
     *
     *    @return   如果与原来的不一致，返回新的高度
     */
    func xySystemLayoutFittedHeightBy(_ width: CGFloat, referenceHeight: CGFloat = 0.0) -> CGFloat? {
        
        /// 重新计算实际大小
        let newSize = self.systemLayoutSizeFitting(CGSize(width: width, height: 0))
        
        guard newSize.height != referenceHeight else { return nil }
            
        return newSize.height
    }
    
    /**
     *    @description 使用系统方法根据约束条件所确定的视图宽度重新计算正确的视图高度
     *
     *    @return   如果与原来的不一致，返回新的高度
     */
    var xySystemLayoutFittedSizeOrNil: CGSize? {
        
        self.updateConstraintsIfNeeded()
        
        self.layoutIfNeeded()
        
        var size = self.bounds.size
        
        if let widthLC = self.xyLayoutConstraints.width {
            
            size.width = widthLC.constant
        }
        
        guard let newHeight: CGFloat = self.xySystemLayoutFittedHeightBy(size.width, referenceHeight: size.height) else { return nil }
        
        size.height = newHeight
        
        return size
    }
    
    /**
    *    @description 根据重新计算的视图大小调整视图Frame值
    *
    *    @return   是否有调整
    */
    @discardableResult func xyAdjustFrameBySystemLayoutFittedSize() -> Bool {
        
        guard let newSize = self.xySystemLayoutFittedSizeOrNil else { return false }
        
        /// 新的frame值
        var newFrame = self.frame
        newFrame.size = newSize
        
        self.frame = newFrame
        
        return true
    }
    
    /**
     *    @description 使用系统方法根据确定的视图高度重新最新的视图大小
     *
     *    @param    height 视图的高度
     *
     *    @param    widthLC 视图的宽度约束
     *
     *    @return   视图大小
     */
    @discardableResult func xySystemLayoutFittingWithBy(_ height: CGFloat, widthLC widthLCOrNil: NSLayoutConstraint? = nil) -> CGFloat {
    
        // 将宽度约束失效，否则会影响计算
        widthLCOrNil?.isActive = false
        
        /// 计算实际需要的大小
        let fittingSize = self.systemLayoutSizeFitting(CGSize(width: 0, height: height))
        
        //XYLog.Log(msg: "size: w:\(fittingSize.width) h:\(fittingSize.height)")
        
        // 修改宽度约束值并使之生效
        widthLCOrNil?.constant = fittingSize.width
        widthLCOrNil?.isActive = true
        
        return fittingSize.width
    }
}

// MARK: - Animation
extension UIView {
    
    static private let XYTransform_RotateAngleValueNameKey = UnsafeRawPointer.init(bitPattern: "UIView_Transform_RotateAngleValue_Key".hashValue)
    
    /// 当前翻转角度值
    var xyTransform_Rotate_Angle: CGFloat {
        
        set{
            
            objc_setAssociatedObject(self, UIView.XYTransform_RotateAngleValueNameKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get{
            
            guard let value = objc_getAssociatedObject(self, UIView.XYTransform_RotateAngleValueNameKey!) as? CGFloat else {
                
                return 0.0
            }
            
            return value
        }
    }
    
    /**
     *    @description 视图翻转
     *
     *    @param    angle    翻转角度
     *
     *    @param    animateDurationOrNil    翻转动画时间
     *
     */
    func xyTransform_Rotate(angle: CGFloat, _ animateDurationOrNil: TimeInterval? = nil) {
        
        defer {
            
            // 缓存当前的翻转角度
            self.xyTransform_Rotate_Angle = angle + self.xyTransform_Rotate_Angle
        }
        
        
        guard let animateDuration = animateDurationOrNil,
            0 < animateDuration else {
            
            self.transform = self.transform.rotated(by: angle * CGFloat.pi/180.0)
            return
        }
        
        UIView.animate(withDuration: animateDuration, animations: {
            
            self.transform = self.transform.rotated(by: angle * CGFloat.pi/180.0)
        })
    }
    
    /**
     *    @description 视图翻转至原始状态
     *
     *    @param    animateDurationOrNil    翻转动画时间
     *
     */
    func xyTransform_RotateToZeroAngle(_ animateDurationOrNil: TimeInterval? = nil) {
        
        /// 翻转角度
        var angle = self.xyTransform_Rotate_Angle
        
        guard angle != 0.0 else { return }
        
        angle = -angle
        
        defer {
            
            // 缓存当前的翻转角度
            self.xyTransform_Rotate_Angle = 0.0
        }
        
        guard let animateDuration = animateDurationOrNil,
            0 < animateDuration else {
            
            self.transform = self.transform.rotated(by: angle * CGFloat.pi/180.0)
            return
        }
        
        UIView.animate(withDuration: animateDuration, animations: {
            
            self.transform = self.transform.rotated(by: angle * CGFloat.pi/180.0)
        })
    }
    
}

