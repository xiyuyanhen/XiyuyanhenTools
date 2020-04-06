//
//  TMsgView.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/11/12.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

struct TMsgModel : ModelProtocol_Array {
    
    var title : String = ""
    var titlefont : UIFont = XYFont.Font(size: 14)
    var titletextColor : UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.x999999)
    var titlenumberOfLines = 0
    var titletextAlignment : NSTextAlignment = NSTextAlignment.left
    
    var msg   : String = ""
    var msgfont : UIFont = XYFont.Font(size: 14)
    var msgtextColor : UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.x333333)
    var msgnumberOfLines = 0
    var msgtextAlignment : NSTextAlignment = NSTextAlignment.right
    
    init(title: String, msg: String) {
        
        self.title = title
        self.msg = msg
    }
}

class TMsgView : BaseView, ModelProtocol_Array {
    
    var model : TMsgModel = TMsgModel(title: "", msg: "")

    convenience init(model newModel: TMsgModel) {
        
        self.init(autoLayout: true)
        
        self.model = newModel
        
        self.reSetups()
    }
    
    override func initProperty() {
        super.initProperty()
        
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubviews(self.titleLabel, self.msgLabel)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.titleLabel.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .top, .leading)
        self.titleLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0, relation: .lessThanOrEqual)
        
        self.msgLabelLeadingLC = self.msgLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: self.reSetupsConstantOrNil ?? UIW(50))
        self.msgLabel.autoPinEdge(.top, to: .top, of: self, withOffset: 0)
        self.msgLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: 0)
        self.msgLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
        
    }
    
    lazy var titleLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        
        return label
    }()
    
    var msgLabelLeadingLC: NSLayoutConstraint? = nil
    
    lazy var msgLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        
        return label
    }()
    
    var reSetupsConstantOrNil : CGFloat? = nil
    
    func reSetups() {
        
        self.titleLabel.text = self.model.title
        self.titleLabel.font = self.model.titlefont
        self.titleLabel.textColor = self.model.titletextColor
        self.titleLabel.numberOfLines = self.model.titlenumberOfLines
        self.titleLabel.textAlignment = self.model.titletextAlignment
        
        self.msgLabel.text = self.model.msg
        self.msgLabel.font = self.model.msgfont
        self.msgLabel.textColor = self.model.msgtextColor
        self.msgLabel.numberOfLines = self.model.msgnumberOfLines
        self.msgLabel.textAlignment = self.model.msgtextAlignment
        
        self.titleLabel.layoutIfNeeded()
        
        let constant = self.titleLabel.frame.size.width + UIW(10)
        
        self.reSetupsConstantOrNil = constant
        
//        if let msgLabelLeadingLC = self.msgLabelLeadingLC {
//
//            msgLabelLeadingLC.constant = constant
//
//        }else {
//
//            self.msgLabelLeadingLC = self.msgLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: constant)
//        }
    }
    
}

class TCMsgMultableView : BaseView {
    
    override func initProperty() {
        super.initProperty()
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
       self.addSubviews(self.contentView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.contentView.autoEdgesPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    var tMsgViewArr: TMsgView.ModelArray = TMsgView.ModelArray()
    
    lazy var contentView : UIView = {
        
        let view = UIView.newAutoLayout()
        
        return view
    }()
    
    var verticalSpace : CGFloat = UIW(12)
    
    func setups(modelArr: TMsgModel.ModelArray) {
        
        guard 0 < modelArr.count else { return }
        
        let contentView = self.contentView
        
        contentView.removeSubviews()
//        self.modelArr.removeAll()
//        self.modelArr.append(contentsOf: modelArr)
        
        self.tMsgViewArr.removeAll()
        
        var lastTMsgViewOrNil : TMsgView? = nil
        for subModel in modelArr {
            
            let subTMsgView = TMsgView(model: subModel)
            
            subTMsgView.updateConstraintsIfNeeded()
            if let leadingLC = subTMsgView.msgLabelLeadingLC {
                
                leadingLC.constant = UIW(80)
            }
            
            contentView.addSubview(subTMsgView)
            self.tMsgViewArr.append(subTMsgView)
            
            if let lastTMsgView = lastTMsgViewOrNil {
                
                subTMsgView.autoTopPinViewBottom(otherView: lastTMsgView, edgeInsets: UIEdgeInsetsMake(self.verticalSpace, 0, 0, 0), edges: .leading, .trailing)
            }else {
                
                subTMsgView.autoPinView(otherView: contentView, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .top, .leading, .trailing)
            }
            
            lastTMsgViewOrNil = subTMsgView
        }
        
        if let lastTMsgView = lastTMsgViewOrNil {
            
            lastTMsgView.autoPinEdge(.bottom, to: .bottom, of: contentView, withOffset: 0)
        }
        
        
    }
    
}
