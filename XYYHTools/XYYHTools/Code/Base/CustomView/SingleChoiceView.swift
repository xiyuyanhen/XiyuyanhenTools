//
//  SingleChoiceView.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/6/1.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class SingleChoiceView: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    override func initProperty() {
        
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.tableview)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.tableview.autoEdgesPinView(otherView: self)
    }
    
    lazy var tableview = { () -> BaseTableView in
        
        let tableView = BaseTableView.newAutoLayout()
        tableView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        
        tableView.xyRegister(SingleChoiceTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    var tableViewDataArr : SingleChoiceModel.ModelArray = SingleChoiceModel.ModelArray()
    
    func selectedModel() -> SingleChoiceModel? {
        
        var selectedModel:SingleChoiceModel? = nil
        
        for subModel in self.tableViewDataArr {
            
            guard subModel.isSelected == true else { continue }
            
            selectedModel = subModel
            break
        }
        
        return selectedModel
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = tableViewDataArr.count
        
        return count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SingleChoiceTableViewCell.ReuseIdentifier(), for: indexPath) as! SingleChoiceTableViewCell
        
        let model = self.tableViewDataArr[indexPath.row]
        
        cell.setups(model: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        for subModel in self.tableViewDataArr {
            
            subModel.isSelected = false
        }
        
        let model = self.tableViewDataArr[indexPath.row]
        model.isSelected = true
        
        self.tableview.reloadData()

    }
    
    class SingleChoiceModel: NSObject, ModelProtocol_Array {
        var isSelected:Bool
        var title:String
        var modelId:String
        var supId:String
        
        init(isSelected:Bool, title:String, modelId:String, supId:String = "") {
            
            self.isSelected = isSelected
            self.title = title
            self.modelId = modelId
            self.supId = supId
        }
    }
    
    class SingleChoiceTableViewCell : BaseTableViewCell {
        
        var customImgView:BaseImageView = BaseImageView.newAutoLayout()
        var customTitleLabel = BaseLabel.newAutoLayout()
        
        override func initProperty() {
            
            self.cellView.backgroundColor = UIColor.FromRGB(0xffffff)
            
            self.customImgView.setContentMode(.scaleAspectFit)
            
            self.customTitleLabel.text = ""
            self.customTitleLabel.font = XYFont.Font(size: 14)
            self.customTitleLabel.textColor = UIColor.FromRGB(0x2d354c)
            self.customTitleLabel.numberOfLines = 0
            self.customTitleLabel.textAlignment = .left
            
        }
        
        override func layoutAddViews() {
        super.layoutAddViews()
            
            self.cellView.addSubview(self.customImgView)
            self.cellView.addSubview(self.customTitleLabel)
        }
        
        override func layoutAllViews() {
        super.layoutAllViews()
            
            self.cellView.autoSetDimension(.height, toSize: UIW(40))
            
            self.customImgView.autoSetDimensions(to: CGSize(width: UIW(15), height: UIW(15)))
            self.customImgView.autoPinEdge(.leading, to: .leading, of: self.cellView, withOffset: 0)
            self.customImgView.autoAlignAxis(.horizontal, toSameAxisOf: self.cellView)
            
            self.customTitleLabel.autoPinEdge(.leading, to: .trailing, of: self.customImgView, withOffset: UIW(12))
            self.customTitleLabel.autoPinView(otherView: self.cellView, edgeInsets: UIEdgeInsetsMake(UIH(10), 0, UIH(-10), 0), edges: .top, .bottom, .trailing)
        }
        
        func setups(model:SingleChoiceModel){
            
            self.updateConstraintsIfNeeded()
            
            if model.isSelected {
                
                self.customImgView.image = UIImage(named: "单选_选中")
            }else{
                
                self.customImgView.image = UIImage(named: "单选_未选中")
            }
            
            self.customTitleLabel.text = model.title
        }
    }
}
