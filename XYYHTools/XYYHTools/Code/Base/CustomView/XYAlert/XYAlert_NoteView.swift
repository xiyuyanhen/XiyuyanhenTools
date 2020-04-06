//
//  XYAlert_NoteView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/22.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYAlert_NoteView : BaseView, BaseAlertProtocol {
    
    @discardableResult static func Show(note: String) -> XYAlert_NoteView {
        
        let view = XYAlert_NoteView.newAutoLayout()
        view.textLabel.text = note
        
        view.show(supView: AlertShowedVC.view)
        
        return view
    }
    
    override func initProperty() {
        super.initProperty()
        
        self.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = UIW(6)
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.textLabel)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.autoSetDimension(.width, toSize: ScreenWidth()-UIW(30))
        
        self.textLabel.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(UIW(30), UIW(20), -UIW(30), -UIW(20)), edges: .top, .leading, .bottom, .trailing)
        
    }
    
    var bgViewOrNil: UIView?
    
    var disAppearBlockOrNil: DisAppearBlock?
    
    lazy var textLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.font = XYFont.Font(size: 14)
        label.textColor = UIColor.FromXYColor(color: XYColor.CustomColor.x666666)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
}
