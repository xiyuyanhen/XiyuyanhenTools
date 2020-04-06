//
//  DataNotNormalView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/7/6.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class DataNotNormalView : BaseView {
    
    class func CreatedByTip(tip:String) -> DataNotNormalView{
        
        let view = self.newAutoLayout()
        
        view.tipLabel.text = tip
        
        return view
    }
    
    typealias SetupsBottomViewBlock = (_ bottomView: UIView) -> Void
    
//    private var setupsBVBlockOrNil : SetupsBottomViewBlock? = nil
    
    func setupsBottomView(block: SetupsBottomViewBlock) {
        
        block( self.bottomView)
    }
    
    override func initProperty() {
        super.initProperty()
        
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubviews(self.imgView, self.tipLabel, self.bottomView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.autoSetDimension(.width, toSize: UIW(300))
    
        if self.imgView.xyLayoutConstraints.width == nil {
            
            self.imgView.autoSetDimension(.width, toSize: UIW(80))
        }
        self.imgView.autoPinEdge(.top, to: .top, of: self)
        self.imgView.autoAlignAxis(.vertical, toSameAxisOf: self)
        
        self.tipLabel.autoPinEdge(.top, to: .bottom, of: self.imgView, withOffset: UIH(10))
        self.tipLabel.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, UIW(-20), 0, UIW(20)), edges: .leading, .trailing)
        
        self.bottomView.autoPinEdge(.top, to: .bottom, of: self.tipLabel, withOffset: 0)
        self.bottomView.autoPinView(otherView: self, edges: .leading, .trailing, .bottom)
    }
    
    lazy var imgView: BaseImageView = {
        
        let imgView = BaseImageView.newAutoLayout()
        imgView.setContentMode(.scaleAspectFit)
        imgView.image = UIImage(named: "空空如也")
        
        return imgView
    }()
    
    lazy var tipLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.font = XYFont.Font(size: 14)
        label.textColor = UIColor.FromRGB(0x2d354c)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    lazy var bottomView: UIView = {
        
        let view = UIView.newAutoLayout()
        
        return view
    }()
    
    
}
