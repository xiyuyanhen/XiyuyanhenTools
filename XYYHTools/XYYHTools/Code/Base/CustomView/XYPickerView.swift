//
//  XYPickerView.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/7/26.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

protocol XYPickerViewItem {
    
    var name: String { get }
}

class XYPickerView<Item: XYPickerViewItem> : BaseView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedItemRemoveFromSuperview: Bool = true
    
    override func initProperty() {
        super.initProperty()
        
        self.setBackgroundColor(customColor: .clear)
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.bgBtn)
        self.addSubview(self.pickerView)
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.bgBtn.autoEdgesPinView(otherView: self)
        
        self.pickerView.autoSetDimension(.height, toSize: UIH(200))
        self.pickerView.autoPinView(otherView: self, edges: .leading, .bottom, .trailing)
    }
    
    lazy var bgBtn: UIButton = {
        
        let bgView = UIButton.newAutoLayout()
        bgView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.black)
        bgView.alpha = 0.3
        
        bgView.addTarget(self, action: #selector(self.bgButtonHandle(btn:)), for: .touchUpInside)
        
        return bgView
    }()
    
    lazy var pickerView: UIPickerView = {
        
        let pickerView = UIPickerView.newAutoLayout()
        pickerView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        pickerView.dataSource = self
        pickerView.delegate = self
        
        return pickerView
    }()
    
    lazy var dataArr: [Item] = {
        
        let arr = [Item]()
        
        return arr
    }()

    var selectedRow:Int = 0
    lazy var rxSelectedItem: PublishSubject<Item> = {
        
        return PublishSubject<Item>()
    }()
    
    open func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        
        self.selectedRow = row
        self.pickerView.selectRow(row, inComponent: component, animated: animated)
    }
    
    @objc func bgButtonHandle(btn:UIButton?){
        
        if let item = self.dataArr.elementByIndex(self.selectedRow) {
            
            self.rxSelectedItem.onNext(item)
        }
        
        self.selectedItemRemoveFromSuperview.xyRunBlockWhenTrue { self.removeFromSuperview() }
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.dataArr.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        guard let item = self.dataArr.elementByIndex(row) else { return nil }

        return item.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedRow = row
    }
    
}
