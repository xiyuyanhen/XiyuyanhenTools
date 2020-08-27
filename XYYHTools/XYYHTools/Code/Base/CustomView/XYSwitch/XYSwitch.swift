//
//  XYSwitch.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/5/21.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

@IBDesignable class XYSwitch: UIView, XYViewNewByNibProtocol {
    
    //newAutoLayout()会调用此方法创建View
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
        
        self.xyAddContentViewByNib()
    }
    
    /**
     *    @description 将实时渲染的代码放到 prepareForInterfaceBuild() 方法中，该方法并不会在程序运行时调用
     *
     */
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.initProperty()
        self.layoutAddViews()
        self.layoutAllViews()
    }
    
    func initProperty() {
        
        self.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
        
        let tapGR = UITapGestureRecognizer()

        tapGR.rx.event.subscribe(onNext: { [weak self] (tapGR) in

            guard let weakSelf = self else { return }

            weakSelf.isOn = !weakSelf.isOn

        }).disposed(by: self.disposeBag)

        self.addGestureRecognizer(tapGR)
        
    }
    
    override func updateConstraints() {
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
        
        
    }
    
    //添加SubView
    func layoutAddViews() {
        
        
    }
    
    func layoutAllViews() {
        
        
    }
    
    //
    func xyDidAddNibContentView() {
        
        
    }
    
    //Rx mode
    lazy var rx_IsOn : BehaviorRelay<Bool> = {
        
        let behavior = BehaviorRelay(value: false)
        
        self.rightLabel.xyControlStateOrNil = .selected
        
        behavior.subscribe(onNext: { [weak self] (isOn) in
            
            guard let weakSelf = self else { return }
            
            if isOn {
                
                weakSelf.animation(fromValue: 0, toValue: weakSelf.bounds.size.width/2)
                
                weakSelf.leftLabel.xyControlStateOrNil = .normal
                weakSelf.rightLabel.xyControlStateOrNil = .selected
                
            }else {
                
                weakSelf.animation(fromValue: weakSelf.bounds.size.width/2, toValue: 0)
                
                weakSelf.leftLabel.xyControlStateOrNil = .selected
                weakSelf.rightLabel.xyControlStateOrNil = .normal
                
            }
            
        }).disposed(by: self.disposeBag)
        
        return behavior
    }()
    
    func animation(fromValue: CGFloat, toValue: CGFloat) {
        
        guard let animation = POPBasicAnimation(propertyNamed: kPOPLayoutConstraintConstant) else {
            
            self.bgViewLeadingLC.constant = toValue
            return
        }
        
        animation.name = "POPAnimation_XYSwitch_Animation"
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.beginTime = CACurrentMediaTime()
        animation.duration = 0.25
        
        animation.completionBlock = { [weak self] (anim, finished) in
            
            self?.layoutIfNeeded()
        }
        
        self.bgViewLeadingLC.pop_add(animation, forKey: animation.name)
    }
    
    var isOn : Bool {
        
        get {
            
            return self.rx_IsOn.value
        }
        
        set {
            
            guard newValue != self.rx_IsOn.value else { return }
            
            self.rx_IsOn.accept(newValue)
        }
    }
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var bgViewLeadingLC: NSLayoutConstraint!
    
    @IBOutlet weak var leftLabel: UILabel! {
        
        willSet{
            
            newValue.xyRxControlStateObservable.subscribe(onNext: { (label, stateOrNil) in
                
                let color : XYColor.CustomColor
                if stateOrNil == .selected {
                    
                    color = .white
                }else {
                    
                    color = .x666666
                }
                
                label.textColor = color.uiColor
                
            }).disposed(by: newValue.disposeBag)
            
            newValue.xyControlStateOrNil = .selected
            
        }
    }
    
    @IBOutlet weak var rightLabel: UILabel! {
        
        willSet{
            
            newValue.xyRxControlStateObservable.subscribe(onNext: { (label, stateOrNil) in
                
                let color : XYColor.CustomColor
                if stateOrNil == .selected {

                    color = .white
                }else {

                    color = .x666666
                }
                
                label.textColor = color.uiColor
                
            }).disposed(by: newValue.disposeBag)
            
            newValue.xyControlStateOrNil = .normal
            
        }
    }

}
