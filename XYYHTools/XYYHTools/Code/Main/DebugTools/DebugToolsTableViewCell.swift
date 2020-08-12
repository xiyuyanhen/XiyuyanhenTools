//
//  DebugToolsTableViewCell.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class DebugToolsTableViewCell : BaseTableViewCell {
    
    var typeOrNil : DebugToolsType?
    func setups(type : DebugToolsType) {
        
        self.updateConstraintsIfNeeded()
        
        self.typeOrNil = type
        
        if type == .设备推送Token,
            let token = DebugToolsManage.DeviceRemoteNotificationTokenOrNil {
            
            self.customTitleLabel.text = "\(type.name): \(token)"
            
        }else if type == .PGY {
            
            self.customTitleLabel.setText("\(XYPGYTools.EncodeText.Name.decryptText())更新")
            
        }else if type == .PGYIndex {
            
            self.customTitleLabel.setText("\(XYPGYTools.EncodeText.Name.decryptText())链接")
            
        }else if type == .内存使用参考 {
            
            let count: UInt = DebugToolsManage.ObjecRetainCount
            
            self.customTitleLabel.setText("\(type.name): \(count)")
            
        }else {
            
            self.customTitleLabel.setText(type.name)
        }
        
        if let status = type.statusSwitchOrNil {
            
            self.statusSwitch.isOn = status
            self.statusSwitch.setHidden(false)
            
        }else {
            
            self.statusSwitch.setHidden(true)
        }
    }
    
    var sectionTopLine:UIView?
    var sectionBottomLine:UIView?
    
    override func initProperty() {
        
        self.cellView.backgroundColor = UIColor.FromRGB(0xffffff)
        
        let _ = self.bottomLine
        
        self.sectionTopLine = self.cellView.addLine(.top, size: 0.5, color: UIColor.FromRGB(0xcccccc))
        self.sectionBottomLine = self.cellView.addLine(.bottom, size: 0.5, color: UIColor.FromRGB(0xcccccc))
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.cellView.addSubview(self.customTitleLabel)
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.cellView.autoSetDimension(.height, toSize: UIW(44))
        
        self.customTitleLabel.autoPinEdge(.leading, to: .leading, of: self.cellView, withOffset: UIW(20))
        self.customTitleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self.cellView)
    }
    
    lazy var customTitleLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.font = XYFont.Font(size: 16)
        label.textColor = UIColor.FromRGB(0x2d354c)
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var bottomLine : UIView = {
        
        return self.cellView.addLine(.bottom, size: 0.5, color: UIColor.FromRGB(0xcccccc), edgeInsets:UIEdgeInsetsMake(0, UIW(12), 0, UIW(-12)))
    }()
    
    lazy var statusSwitch : UISwitch = {
        
        let view = UISwitch.newAutoLayout()
        view.isEnabled = false
        
        self.cellView.addSubview(view)
        
        view.autoAlignAxis(.horizontal, toSameAxisOf: self.cellView)
        view.autoPinEdge(.trailing, to: .trailing, of: self.cellView, withOffset: -UIW(15))
        
        view.addTarget(self, action: #selector(self.modeSwitchHandle(swit:)), for: .valueChanged)
        
        return view
    }()
    
    @objc func modeSwitchHandle(swit: UISwitch) {
        
        guard let type = self.typeOrNil else { return }
        
//        switch type {
//        case .能否快速浏览答案及试题数据:
//
//            DebugToolsManage.EnableQuickLookUpAnswer = swit.isOn
//
//            break
//            
//        default: return
//        }
        
        if let tableView = self.superTableViewOrNil {
            
            tableView.reloadData()
        }
    }
}
