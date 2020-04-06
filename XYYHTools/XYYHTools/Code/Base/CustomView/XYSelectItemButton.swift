//
//  XYSelectItemButton.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/12.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYSelectItemButton<Item> : UIButton, XYViewNewAutoLayoutProtocol{
    
    var dataItemOrNil: Item?
    
    //newAutoLayout()会调用此方法创建View
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initProperty() {
        
        self.setLayerCornerRadius(UIW(8))
        
        self.setXYControlStateChangeBlock { (btnOrNil, state) in
            
            guard let btn = btnOrNil as? XYSelectItemButton else { return }
            
            switch state {
            case .normal:
                
                btn.setTitleColor(XYColor(custom: .x333333).uicolor, for: .normal)
                btn.setBackgroundColor(customColor: .white)
                    .setLayerBorder(width: 1.0, color: .xC8C8C8)
                break
                
            default:
                
                btn.setTitleColor(XYColor(custom: .main).uicolor, for: .normal)
                btn.setBackgroundColor(argb: 0xfffff1ed)
                    .setLayerBorder(width: 1.0, color: .main)
                break
            }
        }
        self.xyControlState = .normal
        
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
        
        self.autoSetDimension(.width, toSize: UIW(80), relation: .greaterThanOrEqual)
    }
    
    func setups(name: String, item: Item) {
        
        self.setTitle(name, for: .normal)
        
        self.dataItemOrNil = item
    }
}
