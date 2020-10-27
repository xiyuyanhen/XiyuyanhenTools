//
//  BaseView.swift
//  XYStudio
//
//  Created by Xiyuyanhen on 2017/6/21.
//  Copyright © 2017年 XyyH. All rights reserved.
//

import Foundation
import RxSwift

@IBDesignable public class BaseView: UIView, XYViewNewAutoLayoutProtocol {
    
    //newAutoLayout()会调用此方法创建View
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    
        self.initProperty()
    }
    
    func initProperty() {
        
        self.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
    }
    
    override public func updateConstraints() {
        
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
    
    deinit {
        
        XYLog.LogNote(msg: "\(self.xyClassName) -- deinit")
    }

}







