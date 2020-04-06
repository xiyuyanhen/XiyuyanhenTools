//
//  BaseTextField.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/5/22.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

/// 本地通知: TextField
enum LN_TextField : XYLocationNotificationProtocol {
    
    /// 所有输入框视图退出第一响应者
    case ResignFirstResponder
    
}

@IBDesignable class BaseTextField: UITextField, XYNewSettingProtocol {
    
    //使用代码加载的对象调用
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initProperty()
    }
    
    //只要对象是从文件解析来的，就会调用,
    //会被先调用initWithCoder:
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
    }
    
    //从xib或者storyboard加载完毕就会调用
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func initProperty() {
        
        self.addResignFirstResponderNotification()
    }
    
    func layoutAddViews() {
        
    }
    
    func layoutAllViews() {
        
    }
    
    deinit {
        
        self.removeResignFirstResponderNotification()
    }
    
    lazy var rxTextChanged: PublishSubject<String> = {
        
        self.delegate = self
        
        return PublishSubject<String>()
    }()
    
    
    // MARK: - XYTextEntryPredicateEvaluate -- 输入内容校验
    private var textEntryPredicateType:String.XYPredicateType = String.XYPredicateType.None //校验方式
    private var textEntryMaxCount:Int = Int.max //最多输入多少个字符
    private var textEntryErrorBlock:XYTextEntryErrorBlock? = nil
}

extension BaseTextField {
    
    private func addResignFirstResponderNotification() {
        
        LN_TextField.ResignFirstResponder.addObserver(self, selector: #selector(self.resignFirstResponderNotification(notification:)))
    }
    
    private func removeResignFirstResponderNotification() {
        
        LN_TextField.ResignFirstResponder.removeObserver(self)
    }
    
    @objc private func resignFirstResponderNotification( notification: NSNotification) {
        
        guard self.canResignFirstResponder else { return }
        
        self.resignFirstResponder()
    }
    
}

// MARK: - XYTextEntryPredicateEvaluate_UITextFieldDelegate
extension BaseTextField: UITextFieldDelegate {
    
    //错误类型
    enum XYTextEntryError {
        case PredicateType
        case MaxCount
    }
    
    typealias XYTextEntryErrorBlock = (_ textField:BaseTextField, _ error:XYTextEntryError, _ range: NSRange, _ string: String) -> Void
    
    func setTextEntryPredicateEvaluate(type:String.XYPredicateType, maxCount:Int = Int.max, errorBlock:XYTextEntryErrorBlock?) {
        
        guard type != String.XYPredicateType.None else {
            
            self.textEntryPredicateType = String.XYPredicateType.None
            self.textEntryErrorBlock = nil
            self.delegate = nil
            return
        }
        
        self.textEntryPredicateType = type
        self.textEntryMaxCount = maxCount
        self.textEntryErrorBlock = errorBlock
        
        self.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        XYLog.LogNoteBlock { () -> String? in
            
            return "\(string)"
        }
        
        guard self.textEntryPredicateType != String.XYPredicateType.None else {
            
            return true
        }
        
        //校验输入内容是否符合
        guard string.predicateEvaluate(type: self.textEntryPredicateType, minNum: 0) else{
            
            if let textEntryEB = self.textEntryErrorBlock {
                
                textEntryEB(self, XYTextEntryError.PredicateType, range, string)
            }
            return false
        }
        
        guard let text = textField.text as NSString? else{ return true }
        
        let newtext = text.replacingCharacters(in: range, with: string)
        
        //校验输入内容长度是否符合
        guard newtext.count <= self.textEntryMaxCount else{
            
            if let textEntryEB = self.textEntryErrorBlock {
                
                textEntryEB(self, XYTextEntryError.MaxCount, range, string)
            }
            return false
        }
        
        self.rxTextChanged.onNext(newtext)
        
        if textField.isSecureTextEntry == true {
            //若是密码模式，此处理方式可避免原来的内容被清空
            
            textField.text = newtext
            
            /// 此处修改会导致rx.text.changed失效
            return false
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        LN_TextField.ResignFirstResponder.postNotification()
        
        return true
    }
}
