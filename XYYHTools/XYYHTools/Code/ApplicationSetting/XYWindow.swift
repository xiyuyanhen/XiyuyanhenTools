//
//  XYWindow.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/2.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYWindow : UIWindow, XYViewNewAutoLayoutProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initProperty()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    var performanceMonitorOrNil : XYPerformanceMonitor?
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        guard let performanceMonitor = self.performanceMonitorOrNil,
            view != performanceMonitor else { return }

        self.bringSubviewToFront(performanceMonitor)
    }
}
