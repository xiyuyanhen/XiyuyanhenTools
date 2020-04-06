//
//  BaseButton.swift
//  XYStudio
//
//  Created by Xiyuyanhen on 2017/7/17.
//  Copyright © 2017年 XyyH. All rights reserved.
//

import Foundation


@IBDesignable class BaseButton : UIButton, XYViewNewAutoLayoutProtocol {
    
    var btnData:AnyObject?
    private var _clickBtnBlockHandle:ClickBtnBlockHandler?
    
    var line:UIView?
    var tempView:UIView?

    func setupsClickBtnBlockHandle(blockHandle:ClickBtnBlockHandler?){
        
        self._clickBtnBlockHandle = blockHandle

        if blockHandle != nil {
            
            self.addTarget(self, action: #selector(self.clickBtnHandle(clickBtn:)), for: UIControl.Event.touchUpInside)
        }
    }
    
    @objc private func clickBtnHandle(clickBtn:BaseButton){
    
        if let clickBlock = self._clickBtnBlockHandle {
            
            clickBlock(self)
        }
    }
    
    //newAutoLayout()会调用此方法创建View
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
    }
    
    lazy var customTitleLabel:BaseLabel = {
        
        let titleLabel = BaseLabel.newAutoLayout()
        titleLabel.text = ""
        titleLabel.font = XYFont.Font(size: 16)
        titleLabel.textColor = UIColor.FromRGB(0x2d354c)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        self.addSubview(titleLabel)
        
        return titleLabel
    }()
    
    lazy var customImgView:BaseImageView = {
       
        let imgView = BaseImageView.newAutoLayout()
        imgView.setContentMode(.scaleAspectFit)
        
        self.addSubview(imgView)
        
        return imgView
    }()
    
    var addBgARC:Bool = false
    var bgARCColor:UIColor = UIColor.clear
    func setbgARCColor(addBgARC:Bool = true, bgARCColor:UIColor){
        
        self.addBgARC = addBgARC
        self.bgARCColor = bgARCColor
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        //获取上下文对象  只要是用了 CoreGraPhics  就必须创建他

        guard self.addBgARC == true else { return }
        
        context.clear(self.bounds)
        
        if let bgColor = self.backgroundColor {
            
            context.setFillColor(bgColor.cgColor)
            context.fill(rect)
        }
    
        context.setLineWidth(2)//显然是设置线宽
        
        let size = self.bounds.size
        
        let center = CGPoint(x: size.width/2.0, y: size.height/2.0)
        let radius = size.width/2.0 - 2
        
        context.setStrokeColor(self.bgARCColor.cgColor)// 设置颜色
        context.addArc(center: center, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(2*Double.pi), clockwise: false)
        
        context.strokePath()
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
        
    }
    
    func layoutAllViews() {
        
    }
    
    /**
     *    @description 触发间隔
     *
     */
//    var responseIntervalIsEnable : Bool = true
//    var responseIntervalTime : TimeInterval?
//
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//
//        let result = super.hitTest(point, with: event)
//
//        // MARK: - 若设置了触发间隔时间，处理该功能
//        if result == self ,
//            let responseIntervalTime = self.responseIntervalTime {
//
//            if self.responseIntervalIsEnable == false {
//
//                return nil
//            }
//
//            self.responseIntervalIsEnable = false
//
//            XYDispatchQueueType.Main.after(time: responseIntervalTime) {
//
//                self.responseIntervalIsEnable = true
//            }
//        }
//
//        return result
//    }
}


extension BaseButton{
    
    class func CreatedAutoLayout(title:String?, _ isAlign:Bool = false, _ bgColor:UIColor = UIColor.clear) -> BaseButton {
        
        let button = BaseButton.newAutoLayout()
        button.backgroundColor = bgColor
        
        if let t = title {
            
            button.customTitleLabel.text = t
            
            if isAlign {
                
                button.customTitleLabel.autoAlignAxis(.horizontal, toSameAxisOf: button)
                button.customTitleLabel.autoAlignAxis(.vertical, toSameAxisOf: button)
                
            }else{
                
                button.customTitleLabel.autoEdgesPinView(otherView: button, edgeInsets: UIEdgeInsets.zero)
            }
            
        }
        
        return button
    }
    
    class func CreatedAutoLayout(img:UIImage?, _ bgColor:UIColor = UIColor.clear) -> BaseButton {
        
        let button = BaseButton.newAutoLayout()
        button.backgroundColor = bgColor
        
        if img != nil {
            
            button.customImgView.image = img
            
            button.customImgView.autoAlignAxis(.horizontal, toSameAxisOf: button)
            button.customImgView.autoAlignAxis(.vertical, toSameAxisOf: button)
        }
        
        return button
    }
    
    class func CreatedAutoLayout(imageName:String, isAlign:Bool = false, _ bgColor:UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)) -> BaseButton {
        
        let button = BaseButton.newAutoLayout()
        
        button.backgroundColor = bgColor
        
        button.customImgView.setImageByName(imageName)
        
        if isAlign {
            
            button.customImgView.autoAlignAxis(.horizontal, toSameAxisOf: button)
            button.customImgView.autoAlignAxis(.vertical, toSameAxisOf: button)
        }else{
            
            button.customImgView.autoEdgesPinView(otherView: button)
        }
        
        return button
    }
    
    class func CreatedAutoLayout(imgName: String,
                                 title: String,
                                 viewsAlign: ALAxis,
                                 viewsSpace: CGFloat,
                                 bgColor:UIColor = UIColor.clear) -> BaseButton {
        
        let button = BaseButton.newAutoLayout()
        button.setContentMode(.scaleToFill)
        
        let imgView = button.customImgView
        let titleLabel = button.customTitleLabel
        
        imgView.setImageByName(imgName)
        
        titleLabel.text = title
        
        button.backgroundColor = bgColor
        
        if viewsAlign == .horizontal {
            
            imgView.autoPinEdge(.leading, to: .leading, of: button, withOffset: 0)
            imgView.autoPinView(otherView: button, edgeInsets: UIEdgeInsets.zero, relation: .equal, edges: .top, .bottom)
            
            
            titleLabel.autoPinEdge(.leading, to: .trailing, of: imgView, withOffset: viewsSpace)
            titleLabel.autoPinView(otherView: button, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .top, .bottom, .trailing)
            
            
        }else {
            
            imgView.autoPinView(otherView: button, edgeInsets: UIEdgeInsets.zero, relation: .equal, edges: .top, .leading, .trailing)
            
            titleLabel.autoPinEdge(.top, to: .bottom, of: imgView, withOffset: viewsSpace)
            titleLabel.autoPinView(otherView: button, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .leading, .bottom, .trailing)
        }
        
        return button
    }
    
}








