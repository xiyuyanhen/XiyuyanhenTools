//
//  XYLogBrowseTableViewCell.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/24.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYLogBrowseTableViewCell : BaseTableViewCell {
    
    override func initProperty() {
        super.initProperty()
        
        self.cellView.addLine(.bottom, size: 1.0, color: UIColor.FromXYColor(color: XYColor.CustomColor.xeeeeee))
    }
    
    func setups(msg: WCDB_XYLogMsg){
        
        self.titleLabel.text = msg.outMsg.trimmingCharacters(in: ["\n", " "])
        
        let bgColor : UIColor
        switch msg.type {
        case .Error:
            bgColor = UIColor.FromRGB(0xf73737, 0.3)
            break
            
        case .Warnning:
            bgColor = UIColor.FromRGB(0xFFF68F)
            break
            
        case .Request:
            bgColor = UIColor.FromRGB(0xFFBBFF, 0.7)
            break
            
        case .Debug:
            bgColor = UIColor.FromRGB(0xFFA500, 0.5)
            break
            
        case .Note, .Brief, .Function:
            bgColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
            break
        }
        self.cellView.backgroundColor = bgColor
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.cellView.addSubview(self.titleLabel)
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.titleLabel.autoPinView(otherView: self.cellView, edgeInsets: UIEdgeInsetsMake(UIW(15), UIW(16), 0, -UIW(16)), edges: .top, .leading, .bottom, .trailing)
    }
    
    lazy var titleLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.font = XYFont.Font(size: 14)
        label.textColor = UIColor.FromXYColor(color: XYColor.CustomColor.x333333)
        label.numberOfLines = 30 //最多显示n行内容
        label.textAlignment = NSTextAlignment.left
        
        label.xy_AddCopyActionByLongPressGR()
        
        return label
    }()
    
}
