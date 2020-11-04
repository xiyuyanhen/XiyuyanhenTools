//
//  大乐透_TableViewCell.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/11/4.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

extension 大乐透_TableViewCell {
    
    func setupsBy(model: XYBmobObject_大乐透) {
        
        self.expectLabel.setText("第\(model.expect)期 \(model.date)")
        
        self.frontAreaNumber1Label.setText("\(model.frontAreaNumber1)")
        self.frontAreaNumber2Label.setText("\(model.frontAreaNumber2)")
        self.frontAreaNumber3Label.setText("\(model.frontAreaNumber3)")
        self.frontAreaNumber4Label.setText("\(model.frontAreaNumber4)")
        self.frontAreaNumber5Label.setText("\(model.frontAreaNumber5)")
        
        self.backAreaNumber1Label.setText("\(model.backAreaNumber1)")
        self.backAreaNumber2Label.setText("\(model.backAreaNumber2)")
    }
}

@IBDesignable class 大乐透_TableViewCell: BaseTableViewNibCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
    }
    
    @IBOutlet weak var expectLabel: UILabel!
    
    @IBOutlet weak var frontAreaNumber1Label: UILabel!
    
    @IBOutlet weak var frontAreaNumber2Label: UILabel!
    
    @IBOutlet weak var frontAreaNumber3Label: UILabel!
    
    @IBOutlet weak var frontAreaNumber4Label: UILabel!
    
    @IBOutlet weak var frontAreaNumber5Label: UILabel!
    
    @IBOutlet weak var backAreaNumber1Label: UILabel!
    
    @IBOutlet weak var backAreaNumber2Label: UILabel!
    
    
}
