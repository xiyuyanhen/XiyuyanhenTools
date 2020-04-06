//
//  XYLog_AlertTextView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/5/5.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYLog_AlertTextView : BaseView, BaseAlertProtocol {
    
    @discardableResult static func Show(note: String) -> XYLog_AlertTextView {
        
        let view = XYLog_AlertTextView.newAutoLayout()
        view.textView.text = note
        
        view.show(supView: AlertShowedVC.view)
        
        return view
    }
    
    override func initProperty() {
        super.initProperty()
        
        self.backgroundColor = UIColor.FromRGB(0x1E2028)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = UIW(6)
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubviews(self.textView, self.btnsContainerView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.autoSetDimension(.width, toSize: ScreenWidth()-UIW(30))
        
        self.textView.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(UIW(10), UIW(8), 0, -UIW(8)), edges: .top, .leading, .trailing)
        
        self.btnsContainerView.autoSetDimension(.height, toSize: UIW(44))
        self.btnsContainerView.autoTopPinViewBottom(otherView: self.textView, edgeInsets: UIEdgeInsetsMake(UIW(10), 0, 0, 0), edges: .leading, .trailing)
        self.btnsContainerView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -UIW(10))
        
    }
    
    var bgViewOrNil: UIView?
    
    var disAppearBlockOrNil: DisAppearBlock?
    
    lazy var textView: BaseTextView = {
        
        let textView = BaseTextView.newAutoLayout()
        textView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
        textView.contentInset = UIEdgeInsetsMake(8, 5, 8, 5)
        textView.font = XYFont.Font(size: 14)
        textView.textColor = UIColor.FromRGB(0x41B645)
        textView.updateConstraintsIfNeeded()
        
        return textView
    }()
    
    enum ButtonType : Int, XYEnumTypeAllCaseProtocol {
        case 复制所有 = 11
        case 文本上传 = 12
    }
    
    lazy var btnsContainerView: UIView = {
        
        let view = UIView.newAutoLayout()
        
        let (_, itemViews) = UIButton.HorizontalLayout(modelArr: ButtonType.AllCaseArr, config: XYMutableCustomViewLayoutConfig(containerView: view), createdBlock: { (index, type) -> (cellSpace: CGFloat, view: UIButton)? in
            
            let newBtn = UIButton.newAutoLayout()
            
            newBtn.tag = type.rawValue
            
            newBtn.layer.masksToBounds = true
            newBtn.layer.cornerRadius = UIW(8)
            newBtn.layer.borderColor = UIColor.FromRGB(0x41B645).cgColor
            newBtn.layer.borderWidth = 1.0
            
            newBtn.setTitle(type.name, for: .normal)
            newBtn.titleLabel?.font = XYFont.BoldFont(size: 16)
            newBtn.setTitleColor(UIColor.FromRGB(0x41B645), for: .normal)
            
            newBtn.addTarget(self, action: #selector(self.btnsClickHandle(btn:)), for: .touchUpInside)
            
            return (cellSpace: UIW(6), view: newBtn)
        })
        
        //宽度相等
        (itemViews as NSArray).autoMatchViewsDimension(.width)
        
        return view
    }()
    
    @objc func btnsClickHandle(btn: UIButton) {
        
        guard let type = ButtonType(rawValue: btn.tag),
            let text = self.textView.text else { return }
    
        switch type {
        case .复制所有:
            
            if text.isNotEmpty {
                
                text.copyToPasteboard()
                
                BaseToastView.Show(tip: "已复制至剪贴板")
                
            }else {
                
                BaseToastView.Show(tip: "内容为空，无法复制")
            }
            
            break
            
        case .文本上传:
            
            guard let textData = text.data(using: .utf8) else { return }
            
//            let hudId = XYProgressHudManager.AddProgressHud(toView: AlertShowedVC.view)
//            XYNetWorkManage.UploadLogFileData(uploadFileData: textData) { (state, resultDicOrNil, errorOrNil) in
//
//                switch state {
//                case .Cancel, .suspend, .needLogin:
//                    break
//                case .success:
//
//                    if let resultDic = resultDicOrNil,
//                        let logUrl = resultDic.object(forKey: "logUrl") as? String,
//                        logUrl.isNotEmpty {
//
//                        "\(logUrl)\n(将sts后缀改为txt即可察看)".copyToPasteboard()
//
//                        BaseToastView.Show(tip: "文本上传成功，链接已复制到剪贴板")
//
//                    }else{
//
//                        BaseToastView.Show(tip: "文本上传失败")
//
//                    }
//
//                    break
//                case .failure, .error, .unknow:
//
//                    BaseToastView.Show(tip: "文本上传失败")
//
//                    break
//                }
//
//                XYProgressHudManager.RemoveProgressHUD(removeingHudId: hudId)
//            }
        
            break
        }
    }
    
    func show(supView: UIView) {
        
        let showBgView : UIView
        
        if let bgView = self.bgViewOrNil {
            
            showBgView = bgView
        }else {
            
            let bgView = self.defaultBgBtn
            
            showBgView = bgView
            self.bgViewOrNil = bgView
        }
        
        supView.addSubview(showBgView)
        
        showBgView.autoEdgesPinView(otherView: supView)
        
        supView.addSubview(self)
        
        self.autoPinView(otherView: supView, edgeInsets: UIEdgeInsetsMake(UIW(50), UIW(20), -UIW(50), -UIW(20)), edges: .top, .leading, .bottom, .trailing)
    }
}
