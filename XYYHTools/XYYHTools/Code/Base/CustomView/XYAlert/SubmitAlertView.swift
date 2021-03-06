//
//  SubmitAlertView.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/11/2.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

class SubmitAlertView : BaseView {
    
    static func Show(type: SubmitType = .Submiting) -> SubmitAlertView?{
        
        guard let showedView = ProgressHudView else { return nil }
        
        let submitAlertView = SubmitAlertView.newAutoLayout()
        submitAlertView.type = type
        
        showedView.addSubview(submitAlertView)
        
        submitAlertView.autoAlignAxis(.horizontal, toSameAxisOf: showedView, withOffset: UIW(20))
        submitAlertView.autoAlignAxis(.vertical, toSameAxisOf: showedView)
        
        return submitAlertView
    }
    
    func remove() {
        
        self.removeFromSuperview()
        
    }
    
    enum SubmitType {
        case None
        case Submiting
        case Success
        case Failure
    }
    
    private var _type : SubmitType = .None
    
    var type: SubmitType {
        
        get {
            
            return self._type
        }
        
        set {
            
            guard self._type != newValue else { return }
            
            self._type = newValue
            
            self.setups()
        }
    }
    
    private func setups() {
        
        switch self.type {
            
        case .None:
            break
        
        case .Submiting:
            
            self.resultTitleLabel.setHidden(true)
            self.resultImgView.setHidden(true)
            self.animationView.setHidden(false)
            self.animationView.startAnimating()

            break
            
        case .Success:
            
            self.resultTitleLabel.xyControlStateOrNil = .normal
            self.resultImgView.xyControlStateOrNil = .normal
            
            self.resultTitleLabel.setHidden(false)
            self.resultImgView.setHidden(false)
            self.animationView.setHidden(true)
            self.animationView.stopAnimating()
            
            break
            
        case .Failure:
            
            self.resultTitleLabel.xyControlStateOrNil = .selected
            self.resultImgView.xyControlStateOrNil = .selected
            
            self.resultTitleLabel.setHidden(false)
            self.resultImgView.setHidden(false)
            self.animationView.setHidden(true)
            self.animationView.stopAnimating()
            
            break
        }
    }
    
//    class func newAutoLayout(type: SubmitType) -> SubmitAlertView {
//
//        let view = SubmitAlertView.newAutoLayout()
//
//
//        return view
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//
//    }
    
    override func initProperty() {
        super.initProperty()
        
        self.backgroundColor = UIColor.FromRGB(0x111111, 0.7)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.resultImgView)
        self.addSubview(self.resultTitleLabel)
        self.addSubview(self.animationView)
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.resultImgView.autoSetDimensions(to: CGSize(width: UIW(50), height: UIW(35)))
        self.resultImgView.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(UIW(30), UIW(35), 0, -UIW(35)), edges: .top, .leading, .trailing)
        
        self.resultTitleLabel.autoPinEdge(.top, to: .bottom, of: self.resultImgView, withOffset: UIW(15))
        self.resultTitleLabel.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, UIW(10), -UIW(10), -UIW(10)), edges: .leading, .bottom, .trailing)
        
        self.animationView.autoSetDimensions(to: CGSize(width: UIW(26), height: UIW(26)))
        self.animationView.autoAlignAxis(.vertical, toSameAxisOf: self)
        self.animationView.autoAlignAxis(.horizontal, toSameAxisOf: self)
    }
    
    lazy var resultImgView : BaseImageView = {
        
        let imgView = BaseImageView.newAutoLayout()
        imgView.setContentMode(.scaleAspectFit)
        
        imgView.xyRxControlStateObservable.subscribe(onNext: { (imgV, stateOrNil) in
            
            if stateOrNil == .normal {
                
                imgV.setImageByName("Submit_Success")
            }else if stateOrNil == .selected {
                
                imgV.setImageByName("Submit_Failure")
            }
            
        }).disposed(by: imgView.disposeBag)
        
        return imgView
    }()
    
    lazy var resultTitleLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.font = XYFont.Font(size: 13)
        label.textColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        
        label.xyRxControlStateObservable.subscribe(onNext: { (lab, stateOrNil) in
            
            if stateOrNil == .normal {
                
                lab.text = "提交成功"
            }else if stateOrNil == .selected {
                
                lab.text = "提交失败"
            }
            
        }).disposed(by: label.disposeBag)
        
        return label
    }()
    
    lazy var animationView: UIActivityIndicatorView = {
        
        let indicatorView = UIActivityIndicatorView.newAutoLayout()
        indicatorView.style = .whiteLarge
        indicatorView.color = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        
        indicatorView.setHidden(true)
        
//        indicatorView.startAnimating()
        indicatorView.stopAnimating()
        
        return indicatorView
    }()
}
