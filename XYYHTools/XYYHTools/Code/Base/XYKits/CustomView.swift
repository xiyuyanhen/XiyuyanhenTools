//
//  CustomView.swift
//  XY_EStudy
//
//  Created by Xiyuyanhen on 2018/5/18.
//  Copyright © 2018年 Xiyuyanhen. All rights reserved.
//

import Foundation

class CustomView: BaseView{
    
    enum MainViewMode {
        case top
        case center
        case bottom
    }
    
    public class func newAutoLayout(viewMode:MainViewMode) -> Self{
        
        let view = self.newAutoLayout()
        
        view.backgroundView.backgroundColor = UIColor.FromRGB(0x000000);
        view.backgroundView.alpha = 0.5
        view.mainView.backgroundColor = UIColor.FromRGB(0xffffff)
        
        view.setupsWithMainViewMode(viewMode)
        
        return view
    }
    
    var backgroundView = BaseView.newAutoLayout()
    var mainView = BaseView.newAutoLayout()
    
    public func setupsWithMainViewMode(_ viewMode:MainViewMode){
        
        for view in self.subviews {
            
            view.removeFromSuperview()
        }
        
        self.addSubview(backgroundView)
        self.addSubview(mainView)
        
        backgroundView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(0, 0, 0, 0))
        
        switch viewMode {
        case MainViewMode.top:
            mainView.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
        case MainViewMode.center:
            mainView.autoAlignAxis(.horizontal, toSameAxisOf: self)
        case MainViewMode.bottom:
            mainView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
        }
        mainView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 0)
        mainView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: 0)
    }
    
}
