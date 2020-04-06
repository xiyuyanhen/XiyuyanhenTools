//
//  XYAlert_TextView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/24.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYAlert_TextView : BaseView, BaseAlertProtocol {
    
    @discardableResult static func Show(note: String) -> XYAlert_TextView {
        
        let view = XYAlert_TextView.newAutoLayout()
        view.textView.text = note
        
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
        
        self.addSubview(self.textView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.autoSetDimension(.width, toSize: ScreenWidth()-UIW(30))
        
        self.textView.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(UIW(10), UIW(8), -UIW(10), -UIW(8)), edges: .top, .leading, .bottom, .trailing)
        
    }
    
    var bgViewOrNil: UIView?
    
    var disAppearBlockOrNil: DisAppearBlock?
    
    lazy var textView: BaseTextView = {
        
        let textView = BaseTextView.newAutoLayout()
        textView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
        textView.contentInset = UIEdgeInsetsMake(8, 5, 8, 5)
        textView.font = XYFont.Font(size: 14)
        textView.textColor = UIColor.FromRGB(0x41B645)
        textView.updateConstraintsIfNeeded()
        
        return textView
    }()
    
    func show(supView: UIView) {
        
        let showBgView : UIView
        
        if let bgView = self.bgViewOrNil {
            
            showBgView = bgView
        }else {
            
            let bgView = self.defaultBgBtn
            
            showBgView = bgView
            self.bgViewOrNil = bgView
        }
        
        supView.addSubview(showBgView)
        
        showBgView.autoEdgesPinView(otherView: supView)
        
        supView.addSubview(self)
        
        self.autoPinView(otherView: supView, edgeInsets: UIEdgeInsetsMake(UIW(50), UIW(20), -UIW(50), -UIW(20)), edges: .top, .leading, .bottom, .trailing)
    }
    
}
