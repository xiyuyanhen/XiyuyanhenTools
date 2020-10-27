//
//  BaseTableViewNibCell.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/3/23.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

@IBDesignable class BaseTableViewNibCell: UITableViewCell, XYViewNewByNibProtocol {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
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
        
        self.setBackgroundColor(customColor: .clear)
        self.contentView.setBackgroundColor(customColor: .clear)
    }
    
    override func updateConstraints() {
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
        
        XYLog.LogNote(msg: "\(self.xyClassName)--updateConstraints")
    }
    
    func layoutAddViews() {
        
        XYLog.LogNote(msg: "\(self.xyClassName)--layoutAddViews")
    }
    
    func layoutAllViews() {
        
        XYLog.LogNote(msg: "\(self.xyClassName)--layoutAllViews")
    }
    
    func xyDidAddNibContentView() {
    
    }
    
}
