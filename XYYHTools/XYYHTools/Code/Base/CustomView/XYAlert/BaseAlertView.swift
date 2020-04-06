//
//  BaseAlertView.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/5/24.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class BaseAlertView : BaseView {
    
    typealias DisAppearBlock = (_ alertView:BaseView) -> Void
    
    var disAppearBlock:DisAppearBlock?
    
    func setDisAppearBlock(block:@escaping DisAppearBlock){
        
        self.disAppearBlock = block
    }
    
    @discardableResult class func ShowRequestNote(dataDic: NSDictionary?) -> Bool {
        
        guard let dic = dataDic,
            let note = dic.object(forKey: "note") as? String,
            note.isNotEmpty else{ return false }
        
        ShowSingleBtnAlertView(title: note)
        
        return true
    }
    
    class func ShowNetWorkError() {
        
        ShowSingleBtnAlertView(title: "网络异常!请稍候再试~", message: nil, comfirmTitle: "确定", showedVC: AlertShowedVC, comfirmBtnBlock: nil)
    }
    
    /// 显示服务器异常
    class func ShowServiceError() {
        
        ShowSingleBtnAlertView(title: "服务器返回数据异常! 请稍候再试~", message: nil, comfirmTitle: "好的", showedVC: AlertShowedVC, comfirmBtnBlock: nil)
    }
    
    //便利构造方法
    @discardableResult class func ShowAlert(title:String? = nil, msg:String? = nil, comfirmBtnClickHandle:ClickBtnBlockHandler? = nil, cancelBtnClickHandle:ClickBtnBlockHandler? = nil) -> BaseAlertView {
        
        let alertView = self.newAutoLayout()
        alertView.autoSetDimension(.width, toSize: ScreenWidth()-UIW(80))
//        alertView.xyCornerRadius = UIView.XYCornerRadius(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0, bottomRight: 10.0)
        
        if title != nil {
            
            alertView.setupsTitle(title: title!)
            alertView.titleView.xyCornerRadius = UIView.XYCornerRadius(topLeft: 5.0, topRight: 5.0, bottomLeft: 0, bottomRight: 0)
        }
        
        if msg != nil {
            
            let msgLabel = BaseLabel.newAutoLayout()
            msgLabel.text = msg
            msgLabel.font = XYFont.Font(size: 14)
            msgLabel.textColor = UIColor.FromRGB(0x2d354c)
            msgLabel.numberOfLines = 0
            msgLabel.textAlignment = NSTextAlignment.center
            
            let extraSpace:CGFloat = (title == nil) ? 10.0 : 0.0
            
            let top:CGFloat = 15.0 + extraSpace
            let left:CGFloat = 30.0
            let bottom:CGFloat = 15.0 + extraSpace
            let right:CGFloat = 30.0 + extraSpace
            
            alertView.setupsContentView(subView: msgLabel, false, UIEdgeInsetsMake(UIW(top), UIW(left), -UIW((bottom)), -UIW(right)))
            alertView.contentView.bgCornerView.backgroundColor = UIColor.FromRGB(0xffffff)
            alertView.contentView.xyCornerRadius = UIView.XYCornerRadius(topLeft: 5.0, topRight: 5.0, bottomLeft: 0, bottomRight: 0)
        }
        
        let btns = NSMutableArray()
        
        var cancelBtn:BaseButton?
        if let cancelBtnBlock = cancelBtnClickHandle {
            
            cancelBtn = BaseButton.newAutoLayout()
            cancelBtn!.setContentMode(.scaleToFill)
            cancelBtn!.backgroundColor = UIColor.FromRGB(0xffffff)
            cancelBtn!.layer.masksToBounds = true
            cancelBtn!.layer.cornerRadius = 5.0
            cancelBtn!.layer.borderWidth = 1.0
            cancelBtn!.layer.borderColor = UIColor.FromXYColor(color: XYColor.CustomColor.main).cgColor
            cancelBtn!.setTitle("取消", for: .normal)
            cancelBtn!.setTitleColor(UIColor.FromXYColor(color: XYColor.CustomColor.main), for: .normal)
            
            cancelBtn!.setupsClickBtnBlockHandle(blockHandle: cancelBtnBlock)
            
            cancelBtn!.addTarget(alertView, action: #selector(alertView.closeHandle(btn:)), for: UIControl.Event.touchUpInside)
            
            btns.add(cancelBtn!)
        }

        let comfirmBtn = BaseButton.newAutoLayout()
        comfirmBtn.setContentMode(.scaleToFill)
        comfirmBtn.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)
        comfirmBtn.layer.masksToBounds = true
        comfirmBtn.layer.cornerRadius = 5.0
        comfirmBtn.setTitle("确认", for: .normal)
        comfirmBtn.setTitleColor(UIColor.FromRGB(0xffffff), for: .normal)
        
        if comfirmBtnClickHandle != nil {
            
            comfirmBtn.setupsClickBtnBlockHandle(blockHandle: comfirmBtnClickHandle)
        }
        
        comfirmBtn.addTarget(alertView, action: #selector(alertView.closeHandle(btn:)), for: UIControl.Event.touchUpInside)
        
        btns.add(comfirmBtn)
        
        let btnsView = BaseView.newAutoLayout()
        btnsView.setBackgroundColor(customColor: .clear)
        
        var lastBtn:BaseButton?
        for subBtn in btns {
            
            let btn = subBtn as! BaseButton
            
            btnsView.addSubview(btn)
            
            if lastBtn == nil {
                
                btn.autoPinView(otherView: btnsView, edges: .top, .leading, .bottom)
            }else{
                
                btn.autoPinEdge(.leading, to: .trailing, of: lastBtn!, withOffset: UIW(UIW(30)))
                btn.autoPinView(otherView: btnsView, edges: .top, .bottom)
            }
            
            lastBtn = btn
        }
        
        if lastBtn != nil {
            
            lastBtn?.autoPinEdge(.trailing, to: .trailing, of: btnsView)
        }
        
        btns.count >= 2 ? btns.autoMatchViewsDimension(.width) : nil
        btns.autoSetViewsDimension(.height, toSize: UIW(35))
        
        alertView.setupsBtnsView(subView: btnsView, false, UIEdgeInsetsMake(UIH(10), UIW(25), UIH(-10), UIW(-25)))
//        alertView.btnsView.backgroundColor = UIColor.FromRGB(0xffffff)
        
        alertView.btnsView.bgCornerView.backgroundColor = UIColor.FromRGB(0xffffff)
        alertView.btnsView.xyCornerRadius = UIView.XYCornerRadius(topLeft: 0, topRight: 0, bottomLeft: 5.0, bottomRight: 5.0)
        
//        alertView.setupsFooterViewByClose()
        
        alertView.show(supView: ProgressHudView)
        
        return alertView
    }
    
    //组件内部代码
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.mainView)
        self.addSubview(self.titleView)
        self.addSubview(self.contentView)
        self.addSubview(self.btnsView)
        self.addSubview(self.footerView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()

        self.mainView.autoEdgesPinView(otherView: self, edgeInsets: self.mainViewEdgeInsets)
        
        self.titleView.autoPinView(otherView: self.mainView, edgeInsets: UIEdgeInsets.zero, edges: .top, .leading, .trailing)
        
        self.contentView.autoPinEdge(.top, to: .bottom, of: self.titleView, withOffset: -1)
        self.contentView.autoPinView(otherView: self.mainView, edges: .leading, .trailing)
        
        self.btnsView.autoPinEdge(.top, to: .bottom, of: self.contentView, withOffset:-1)
        self.btnsView.autoPinView(otherView: self.mainView, edges: .leading, .trailing)
        
        self.footerView.autoPinEdge(.top, to: .bottom, of: self.btnsView)
        self.footerView.autoPinView(otherView: self.mainView, edges: .leading, .bottom, .trailing)
    }
    
    @discardableResult
    func setupsTitle(title:String, _ font:UIFont = XYFont.Font(size: 18), _ color:UIColor = UIColor.FromRGB(0x2d354c)) -> BaseLabel{
        
        let titleLabel = BaseLabel.newAutoLayout()
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = color
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.center
        
        self.setupsTitleView(subView: titleLabel, false, UIEdgeInsetsMake(UIW(20), UIW(30), UIW(-20), UIW(-30)))
        
        return titleLabel
    }
    
    func setupsTitleView(subView:UIView,_ needBottomLine:Bool = false, _ edgeInsets : UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.titleView.setupsSubView(subView: subView, edgeInsets: edgeInsets)
    }
    
    func setupsContentView(subView:UIView,_ needBottomLine:Bool = false, _ edgeInsets : UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.contentView.setupsSubView(subView: subView, edgeInsets: edgeInsets)
    }
    
    @discardableResult
    func setupsComfirmBtn(title:String) -> BaseButton {
        
        let comfirmBtn = BaseButton.newAutoLayout()
        comfirmBtn.setContentMode(.scaleToFill)
        comfirmBtn.layer.masksToBounds = true
        comfirmBtn.layer.cornerRadius = 10.0
//        comfirmBtn.layer.borderWidth = 0.0
//        comfirmBtn.layer.borderColor = UIColor.FromRGB(0x000000).cgColor
        comfirmBtn.setTitle(title, for: .normal)
        comfirmBtn.setTitleColor(UIColor.FromRGB(0xffffff), for: .normal)
        comfirmBtn.titleLabel?.font = XYFont.Font(size: 18)
        comfirmBtn.setBackgroundColor(UIColor.FromXYColor(color: XYColor.CustomColor.main), .normal)
        
        comfirmBtn.autoSetDimension(.height, toSize: UIW(50))
        self.setupsBtnsView(subView: comfirmBtn, false, UIEdgeInsetsMake(UIH(15), UIW(20), UIH(-15), UIW(-20)))
        
        return comfirmBtn
    }
    
    func setupsBtnsView(subView:UIView,_ needBottomLine:Bool = false, _ edgeInsets : UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.btnsView.setupsSubView(subView: subView, edgeInsets: edgeInsets)
    }
    
    func setupsfooterView(subView:UIView,_ needBottomLine:Bool = false, _ edgeInsets : UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.footerView.setupsSubView(subView: subView, edgeInsets: edgeInsets)
    }
    
    @discardableResult
    func setupsFooterViewByClose(_ btnImg:UIImage = #imageLiteral(resourceName: "public_close_white"), _ btnSize:CGSize = CGSize(width: UIW(30), height: UIW(30))) ->BaseButton {
        
        let closeBtn = BaseButton.newAutoLayout()
        closeBtn.setContentMode(.scaleAspectFit)
        closeBtn.setImage(btnImg, for: .normal)
        closeBtn.addTarget(self, action: #selector(self.closeHandle(btn:)), for: .touchUpInside)
        
        self.footerView.addSubview(closeBtn)
        
        closeBtn.autoSetDimensions(to: btnSize)
        closeBtn.autoAlignAxis(.vertical, toSameAxisOf: self.footerView)
        closeBtn.autoPinView(otherView: self.footerView, edgeInsets: UIEdgeInsetsMake(UIH(20), 0, 0, 0), edges: .top, .bottom)
        
        return closeBtn
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
            
            if bgView.superview != nil {
                
                bgView.removeFromSuperview()
            }
        }
        
        guard self.superview != nil else { return }
        
        self.removeFromSuperview()
        
        if let disAppearBlock = self.disAppearBlock {
            
            disAppearBlock(self)
        }
    }
    
    @objc func closeHandle(btn:BaseButton){
        
        self.disAppear()
    }
    
    var mainViewEdgeInsets : UIEdgeInsets = UIEdgeInsets.zero
    
    //所有内容
    lazy var mainView : BaseView = {
        
        let view = BaseView.newAutoLayout()
        
        return view
    }()
    
    //标题区
    var titleView: BaseShadowView = {
        
        let view = BaseShadowView.newAutoLayout()
        view.bgCornerView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        
        return view
    }()
    
    //主体区
    var contentView: BaseShadowView = {
        
        let view = BaseShadowView.newAutoLayout()
        view.bgCornerView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        
        return view
    }()
    
    //button区
    var btnsView: BaseShadowView = {
        
        let view = BaseShadowView.newAutoLayout()
        view.bgCornerView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        
        return view
    }()
    
    //footerView
    var footerView: BaseView = {
        
        let view = BaseView.newAutoLayout()
        
        return view
    }()
    
    var bgView: BaseView?
    
}
