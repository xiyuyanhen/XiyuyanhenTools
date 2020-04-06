//
//  BaseTextView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/7/7.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class BaseTextView : UITextView, XYViewNewAutoLayoutProtocol {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard 0 < self.frame.size.width else{ return }
        
        var contentInset = self.contentInset
        
        self.contentInset = contentInset
        
        if let topLC = self.placeHolderLabel.xyLayoutConstraints.top {
            
            topLC.constant = contentInset.top-3
        }
        
        if let leadingLC = self.placeHolderLabel.xyLayoutConstraints.leading {
            
            leadingLC.constant = contentInset.left-3
        }
        
        if let trailingLC = self.placeHolderLabel.xyLayoutConstraints.trailing {
            
            trailingLC.constant = contentInset.right
        }
        
    }
    
    func initProperty() {
        
        self.setBackgroundColor(customColor: .clear)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChangeHandle), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    @objc func textDidChangeHandle() {
        
        self.placeHolderLabel.isHidden = (self.text.count > 0)
        
//        self.layoutIfNeeded()
    }
    
    override func updateConstraints() {
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func layoutAddViews() {
        
        self.addSubview(self.placeHolderLabel)
    }
    
    func layoutAllViews() {
        
        let contentInset = self.contentInset
        
        self.placeHolderLabel.autoPinEdge(.top, to: .top, of: self, withOffset: contentInset.top)
        self.placeHolderLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: contentInset.left)
        self.placeHolderLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: contentInset.right)

    }
    
    override var text: String!{
        
        set{
            
            super.text = newValue
            
            self.placeHolderLabel.isHidden = (newValue.count > 0)
        }
        
        get{
            
            return super.text
        }
    }
    
    var placeHolder : String {
        
        set{
            
            self.placeHolderLabel.text = newValue
        }
        
        get{
            
            guard let text = self.placeHolderLabel.text else {
                return ""
            }
            
            return text
        }
    }
    
    override var font: UIFont?{
        
        set{
            
            super.font = newValue
            
            self.placeHolderLabel.font = newValue
        }
        
        get{
            
            return super.font
        }
    }
    
    lazy var placeHolderLabel: BaseLabel = {
        
        let label = BaseLabel.newAutoLayout()
        label.text = ""
        label.font = self.font ?? XYFont.Font(size: 14)
        label.textColor = XYColor(custom: .xcccccc).uicolor
        label.numberOfLines = 0
        label.textAlignment = self.textAlignment
        
        label.isHidden = (self.text.count > 0)
        
        return label
    }()
    
    // MARK: - XYCustomBlock
    
    var didChangeBlock : XYTextViewDidChangeBlock?
    
    func setDidChangeBlock(blockOrNil: XYTextViewDidChangeBlock?) {
        
        guard let block = blockOrNil  else {
            
            self.didChangeBlock = nil
            self.delegate = nil
            return
        }
        
        self.delegate = self
        self.didChangeBlock = block
    }
}

extension BaseTextView : UITextViewDelegate {
    
    typealias XYTextViewDidChangeBlock = (BaseTextView) -> Swift.Void
    
    //在text view获得焦点之前会调用textViewShouldBeginEditing: 方法
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    //当text view获得焦点之后，并且已经是第一响应者（first responder），那么会调用textViewDidBeginEditing: 方法
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
    }
    
    //焦点发生改变
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        
    }
    
    //当text view失去焦点之前会调用textViewShouldEndEditing
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    
    
    //内容将要发生改变编辑
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    //内容发生改变编辑
    func textViewDidChange(_ textView: UITextView) {
        
        if let didChangeBlock = self.didChangeBlock,
            let bTV = textView as? BaseTextView {
            
            didChangeBlock(bTV)
        }
    }
    
    //结束编辑
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
    }
    
    //指定范围的内容与 URL 将要相互作用时激发该方法——该方法随着 IOS7被使用;
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
        return true
    }
    
    //textView指定范围的内容与文本附件将要相互作用时,自动激发该方法——该方法随着 IOS7被使用;
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        
        return true
    }
}
