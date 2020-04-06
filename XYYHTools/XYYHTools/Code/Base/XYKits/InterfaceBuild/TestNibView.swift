//
//  TestNibView.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2019/1/1.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

@IBDesignable class TestNibView: UIView, XYViewNewByNibProtocol {
    
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
    
    func xyDidAddNibContentView() {
        
        
        
    }
    
}








