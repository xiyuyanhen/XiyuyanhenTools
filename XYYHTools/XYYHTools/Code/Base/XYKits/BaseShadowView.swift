//
//  BaseShadowView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/14.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

class BaseShadowView : BaseView {

    var bgCornerView:UIView = UIView.newAutoLayout()

    override func initProperty() {
        super.initProperty()

        
    }

    override func layoutAddViews() {
        super.layoutAddViews()

        self.insertSubview(self.bgCornerView, at: 0)
    }

    override func layoutAllViews() {
        super.layoutAllViews()

        self.bgCornerView.autoPinView(otherView: self, edges: .top, .leading, .bottom, .trailing)
    }
    
}
