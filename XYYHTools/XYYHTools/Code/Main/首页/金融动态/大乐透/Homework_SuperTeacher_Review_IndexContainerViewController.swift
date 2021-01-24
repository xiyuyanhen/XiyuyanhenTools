//
//  Homework_SuperTeacher_Review_IndexContainerViewController.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/11/17.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 作业 -> 首页显示内容方式
enum Homework_SuperTeacher_Review_ShowType: Int, XYEnumTypeAllCaseProtocol {
    
    case 按名称查看 = 201
    case 按教师查看 = 202
    case 我的布置 = 203
    
}

/// 作业列表
class Homework_SuperTeacher_Review_IndexContainerViewController : BaseViewController {
    
    override func initProperty() {
        super.initProperty()
        
        self.navigationBarHidden = true
    }
    
    override func xyLocationNotificationAddObservers() {
           
    }
    
    override func xyLocationNotificationHandle(notification: Notification) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.titleContainerView.addSubviews(self.showTypeBtn)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.showTypeBtn.autoAlignAxis(.horizontal, toSameAxisOf: self.titleContainerView)
        self.showTypeBtn.autoPinEdge(.trailing, to: .trailing, of: self.titleContainerView, withOffset: -UIW(14))
        
    }
    
    @IBOutlet weak var titleContainerView: UIView!
    
    lazy var showTypeBtn: BaseButton = {
        
        let newValue = BaseButton.newAutoLayout()
        newValue.contentMode = .scaleToFill
        
        newValue.customTitleLabel.setText("按名称查看")
            .setFont(XYFont.Font(size: 14))
            .setTextColor(customColor: .main)
        
        newValue.customImgView.setImageByName("Public_Direct_BottomRight_Blue")
        
        newValue.customTitleLabel.autoPinEdge(.leading, to: .leading, of: newValue, withOffset: 0)
        newValue.customTitleLabel.autoAlignAxis(.horizontal, toSameAxisOf: newValue)
        
        newValue.customImgView.autoSetDimensions(to: CGSize(width: UIW(8), height: UIW(4)))
        newValue.customImgView.autoPinEdge(.leading, to: .trailing, of: newValue.customTitleLabel, withOffset: UIW(2))
        newValue.customImgView.autoPinEdge(.trailing, to: .trailing, of: newValue, withOffset: 0)
        newValue.customImgView.autoPinEdge(.bottom, to: .bottom, of: newValue.customTitleLabel, withOffset: 0)
    
        newValue.rx.tap.subscribe(onNext: { [weak self] () in
            guard let weakSelf = self,
                weakSelf.alertViewOrNil == nil else { return }
            
            let alertView = HW_ChangeShowTypeAlertView.Show(supView: weakSelf.view, types: .按名称查看, .按教师查看, .我的布置)
            
            alertView.setAllBtnToUnSelectAndSelect(type: weakSelf.rxShowType.value)
            
            for btn in alertView.btns {
                
                btn.addTarget(self, action: #selector(weakSelf.clickHandle(btn:)), for: .touchUpInside)
            }
            
            weakSelf.alertViewOrNil = alertView
            
            alertView.setDisAppearBlock { (_) in
                
                weakSelf.alertViewOrNil = nil
            }
            
        }).disposed(by: self.disposeBag)
        
        return newValue
    }()
    
    fileprivate var alertViewOrNil: HW_ChangeShowTypeAlertView?
    
    /// 当前显示的列表方式
    lazy var rxShowType: BehaviorRelay<Homework_SuperTeacher_Review_ShowType> = {
        
        return BehaviorRelay<Homework_SuperTeacher_Review_ShowType>(value: Homework_SuperTeacher_Review_ShowType.按名称查看)
    }()
    
}

extension Homework_SuperTeacher_Review_IndexContainerViewController {
    
    @objc fileprivate func clickHandle(btn: BaseButton) {
        
        var selectType: Homework_SuperTeacher_Review_ShowType = Homework_SuperTeacher_Review_ShowType.按名称查看
        
        switch btn.tag {
        case Homework_SuperTeacher_Review_ShowType.按名称查看.rawValue:
            
            selectType = Homework_SuperTeacher_Review_ShowType.按名称查看
            
            break
            
        case Homework_SuperTeacher_Review_ShowType.按教师查看.rawValue:
            
            selectType = Homework_SuperTeacher_Review_ShowType.按教师查看
            
            break
            
        case Homework_SuperTeacher_Review_ShowType.我的布置.rawValue:
            
            selectType = Homework_SuperTeacher_Review_ShowType.我的布置
            
            break
            
        default: break
        }
        
        self.alertViewOrNil?.disAppear()
    
        self.changeBy(selectType)
    }
    
    /// 根据显示类型更新显示样式并发送信号
    func changeBy(_ type: Homework_SuperTeacher_Review_ShowType) {
        
        self.showTypeBtn.customTitleLabel.setText(type.name)
            
        self.rxShowType.accept(type)
    }
    
}

extension Homework_SuperTeacher_Review_IndexContainerViewController {
    
    
}

extension Homework_SuperTeacher_Review_IndexContainerViewController {
    
    
}

extension Homework_SuperTeacher_Review_IndexContainerViewController: XYStoryboardLoadProtocol {
    
    static var StoryboardName: String { return "Homework_Review_Storyboard"}
    
    static var StoryboardIdentifier: String { return "Homework_SuperTeacher_Review_IndexContainerViewController" }
}
