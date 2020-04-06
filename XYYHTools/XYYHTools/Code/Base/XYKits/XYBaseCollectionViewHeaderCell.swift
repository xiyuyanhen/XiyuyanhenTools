//
//  XYBaseCollectionViewHeaderCell.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/6/8.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYBaseCollectionViewHeaderCell : BaseCollectionViewCell {
    
    override func initProperty() {
        super.initProperty()
    }
    
    class func ItemSize(newHeight: CGFloat = UIW(24)) -> CGSize {
        
        return CGSize(width: UIW(300), height: newHeight)
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.cellView.addSubview(self.titleLabel)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.cellView.autoSetDimensions(to: XYBaseCollectionViewHeaderCell.ItemSize())
        
        self.titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self.cellView)
        self.titleLabel.autoPinEdge(.leading, to: .leading, of: self.cellView, withOffset: UIW(12))
        self.titleLabel.autoPinEdge(.trailing, to: .trailing, of: self.cellView, withOffset: -UIW(12), relation: .lessThanOrEqual)
        
    }
    
    lazy var titleLabel : BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.numberOfLines = 1
        label.font = XYFont.Font(size: 17)
        label.textColor = UIColor.FromRGB(0x040F17)
        label.textAlignment = NSTextAlignment.left
        
        return label
    }()
    
}
