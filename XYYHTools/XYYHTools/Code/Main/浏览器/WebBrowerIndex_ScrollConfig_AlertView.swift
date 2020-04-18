//
//  WebBrowerIndex_ScrollConfig_AlertView.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/18.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

class WebBrowerIndex_ScrollConfig_AlertView : BaseView, BaseAlertProtocol {
    
    @discardableResult static func Show(note: String) -> WebBrowerIndex_ScrollConfig_AlertView {
        
        let view = WebBrowerIndex_ScrollConfig_AlertView.newAutoLayout()
        view.speedLabel.text = note
        
        view.show(supView: AlertShowedVC.view)
        
        return view
    }
    
    override func initProperty() {
        super.initProperty()
        
        self.backgroundColor = UIColor.FromRGB(0x1E2028)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = UIW(6)
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubviews(self.speedLabel, self.btnsContainerView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.autoSetDimension(.width, toSize: UIW(300))
        
        self.speedLabel.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(UIW(10), UIW(8), 0, -UIW(8)), edges: .top, .leading, .trailing)
        
        self.btnsContainerView.autoSetDimension(.height, toSize: UIW(44))
        self.btnsContainerView.autoTopPinViewBottom(otherView: self.speedLabel, edgeInsets: UIEdgeInsetsMake(UIW(30), 0, 0, 0), edges: .leading, .trailing)
        self.btnsContainerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -UIW(10))
        
    }
    
    var bgViewOrNil: UIView?
    
    var disAppearBlockOrNil: DisAppearBlock?
    
    lazy var speedLabel: BaseLabel = {
        
        let newValue = BaseLabel.newAutoLayout()
        newValue.text = ""
        newValue.font = XYFont.Font(size: 14)
        newValue.textColor = XYColor(custom: .white).uicolor
        newValue.numberOfLines = 0
        newValue.textAlignment = NSTextAlignment.center
        
        return newValue
    }()
    
    enum ButtonType : Int, XYEnumTypeAllCaseProtocol {
        case 减速 = 10
        case 启停 = 11
        case 加速 = 12
        
        var speedOrNil: CGFloat? {
            
            switch self {
                
            case .减速: return -0.25
                
            case .启停: return nil
                
            case .加速: return 0.25
            }
        }
    }
    
    lazy var btnsContainerView: UIView = {
        
        let view = UIView.newAutoLayout()
        
        let (_, itemViews) = UIButton.HorizontalLayout(modelArr: ButtonType.AllCaseArr, config: XYMutableCustomViewLayoutConfig(containerView: view), createdBlock: { (index, type) -> (cellSpace: CGFloat, view: UIButton)? in
            
            let newBtn = UIButton.newAutoLayout()
            
            newBtn.tag = type.rawValue
            
            newBtn.layer.masksToBounds = true
            newBtn.layer.cornerRadius = UIW(8)
            newBtn.layer.borderColor = UIColor.FromRGB(0x41B645).cgColor
            newBtn.layer.borderWidth = 1.0
            
            newBtn.setTitle(type.name, for: .normal)
            newBtn.titleLabel?.font = XYFont.BoldFont(size: 16)
            newBtn.setTitleColor(UIColor.FromRGB(0x41B645), for: .normal)
            
            newBtn.addTarget(self, action: #selector(self.btnsClickHandle(btn:)), for: .touchUpInside)
            
            return (cellSpace: UIW(6), view: newBtn)
        })
        
        //宽度相等
        (itemViews as NSArray).autoMatchViewsDimension(.width)
        
        return view
    }()
    
    @objc func btnsClickHandle(btn: UIButton) {
        
        guard let type = ButtonType(rawValue: btn.tag) else { return }
    
        self.rxClickSubject.onNext(type)
    }
    
    lazy var rxClickSubject: PublishSubject<ButtonType> = {
        
        return PublishSubject<ButtonType>()
    }()
}
