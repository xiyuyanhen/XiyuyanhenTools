//
//  HomeworkItemTableViewCell.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/3/20.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

extension HomeworkItemTableViewCell {
    
    func setupsBy(model: VirtualCurrencyModel) {
        
        self.dateLabel.setText("\(model.timestampOrNil ?? 0)")

        self.nameLabel.setText(model.modelId)

        self.detailLabel.setText(nil)

        self.clazzNameLabel.setText("当前:\(model.vwapOrNil?.xyDecimalLength(2, trimmingEndZD: true) ?? "-")")

        self.scoreLabel.setText("开盘:\(model.openOrNil?.xyDecimalLength(2, trimmingEndZD: true) ?? "-")")

        self.completedCountLabel.setText("最低:\(model.lowOrNil?.xyDecimalLength(2, trimmingEndZD: true) ?? "-")")

        self.statusLabel.setText("最高:\(model.highOrNil?.xyDecimalLength(2, trimmingEndZD: true) ?? "-")")
    }
}

@IBDesignable class HomeworkItemTableViewCell: BaseTableViewNibCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var clazzNameLabel: UILabel!

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var completedCountLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
}


