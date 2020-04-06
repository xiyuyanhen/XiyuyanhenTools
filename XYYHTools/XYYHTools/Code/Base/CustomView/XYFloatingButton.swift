//
//  XYFloatingButton.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/1/29.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

//悬浮按钮

import Foundation

class XYFloatingButton: UIButton, XYViewNewAutoLayoutProtocol {
    
    // 是否可拖拽
    var isDragEnable: Bool = true
    
    // 拖拽后是否自动移到边缘
    var isAbsortEnable: Bool = true
    
    // 背景颜色
    var bgColor: UIColor? = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
    
    // 正常情况下 透明度
    var alphaOfNormol: CGFloat = 0.3
    
    // 拖拽时的透明度
    var alphaOfDrag: CGFloat = 0.8
    
    // 圆角大小
    var radiuOfButton: CGFloat = 12
    
    // 拖拽结束后的等待时间
    var timeOfWait: CGFloat = 1.5
    
    // 拖拽结束后的过渡动画时间
    var timeOfAnimation: CGFloat = 0.3
    
    // 按钮距离边缘的内边距
    var paddingOfbutton: CGFloat = 2
    
    // 点击响应
    var clickBlockOrNil : ClickBlock?
    
    // 计时器
    fileprivate var timer: Timer? = nil
    
    // 内部使用 起到数据传递的作用
    fileprivate var allPoint: CGPoint? = nil
    
    // 内部使用
    fileprivate var isHasMove: Bool = false
    
    fileprivate var isFirstClick: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initProperty()
        
        self.updateConfig()
        
        self.setTagByPublic(.XYFloatingButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initProperty() {
        
        self.setBackgroundColor(customColor: .clear)
    }
    
    override func updateConstraints() {
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func layoutAddViews() {
        
        self.addSubview(self.bgView)
    }
    
    func layoutAllViews() {
        
        self.bgView.autoEdgesPinView(otherView: self)
    }
    
    lazy var bgView : UIView = {
        
        let view = UIView.newAutoLayout()
        
        var config = UIView.XYShadowConfig()
        config.shadowRadius = UIW(8)
        config.opacity = 0.25
        
        var shadowOrGradientConfig = config.createShadowOrGradientConfig
        shadowOrGradientConfig.cornerRadiusOrNil = UIW(8)
        shadowOrGradientConfig.bgColorOrNil = UIColor.FromXYColor(color: XYColor.CustomColor.main)
        
        view.xyShadowOrGradientOrNil = shadowOrGradientConfig
        
        return view
    }()
    
    func updateConfig() {
        
        self.bgView.backgroundColor = self.bgColor
        self.bgView.alpha =  self.alphaOfNormol
        self.bgView.layer.cornerRadius = self.radiuOfButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.bgView.alpha = self.alphaOfDrag
        // 计时器取消
        self.timer?.invalidate()
        // 不可拖拽则退出执行
        if !isDragEnable {
            return
        }
        self.allPoint = touches.first?.location(in: self)
        
        self.perform(#selector(singleClick), with: nil, afterDelay: 0.2)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHasMove = true
        if self.isFirstClick {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleClick), object: nil)
            self.isFirstClick = false
        }
        if !isDragEnable {
            return
        }
        let temp = touches.first?.location(in: self)
        // 计算偏移量
        let offsetx = (temp?.x)! - (self.allPoint?.x)!
        let offsety = (temp?.y)! - (self.allPoint?.y)!
        self.center = CGPoint.init(x: self.center.x + offsetx, y: self.center.y + offsety)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isFirstClick = true
        
        
        self.timer = Timer(timeInterval: TimeInterval(self.timeOfWait), target: self, selector: #selector(self.timerHandle(timer:)), userInfo: nil, repeats: false)
        
        // 这段代码只有在按钮移动后才需要执行
        if self.isHasMove && isAbsortEnable && self.superview != nil {
            // 移到父view边缘
            let marginL = self.frame.origin.x
            let marginT = self.frame.origin.y
            let superFrame = self.superview?.frame
            let tempy = (superFrame?.height)! - 2 * self.frame.height - self.paddingOfbutton
            let tempx = (superFrame?.width)! - self.frame.width - self.paddingOfbutton
            let xOfR = (superFrame?.width)! - self.frame.width - self.paddingOfbutton
            UIView.animate(withDuration: 0.2, animations: {
                var x = self.frame.origin.x
                if marginT < self.frame.height + self.paddingOfbutton {
                    // 靠顶部
                    if x > tempx {
                        x = tempx
                    }
                    if x < self.paddingOfbutton {
                        x = self.paddingOfbutton
                    }
                    self.frame = CGRect.init(x: x, y: self.paddingOfbutton, width: self.frame.width, height: self.frame.height)
                } else if marginT > tempy {
                    // 靠底部
                    if x > tempx {
                        x = tempx
                    }
                    if x < self.paddingOfbutton {
                        x = self.paddingOfbutton
                    }
                    let y = tempy + self.frame.height
                    self.frame = CGRect.init(x: x, y: y, width: self.frame.width, height: self.frame.height)
                } else if marginL > ((superFrame?.width)! / 2) {
                    // 靠右移动
                    self.frame = CGRect.init(x: xOfR, y: marginT, width: self.frame.width, height: self.frame.height)
                } else {
                    // 靠左移动
                    self.frame = CGRect.init(x: self.paddingOfbutton, y: marginT, width: self.frame.width, height: self.frame.height)
                }
            })
        }
        self.isHasMove = false
        // 将计时器加入runloop
        if let temptime = self.timer {
            RunLoop.current.add(temptime, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc func timerHandle(timer: Timer) {
        
        // 过渡
        UIView.animate(withDuration: TimeInterval(self.timeOfAnimation), animations: {
            self.bgView.alpha = self.alphaOfNormol
        })
    }
    
    @objc func singleClick() {

        guard let clickBlock = self.clickBlockOrNil else { return }
        
        clickBlock(self)
    }
    
    deinit {
        
        XYLog.LogNote(msg: "\(self.className) -- deinit")
    }
}


extension XYFloatingButton {
    
    typealias ClickBlock = (XYFloatingButton) -> Void
    
    func setClickBlock(_ blockOrNil: ClickBlock?) {
        
        self.clickBlockOrNil = blockOrNil
    }
}
