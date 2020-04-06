//
//  XYLogChangePrintTargetPickerView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/17.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYLogChangePrintTargetPickerDelegate {
    
    func selectedTarget(target: XYLogPrintTarget)
}

class XYLogChangePrintTargetPickerView : BaseView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func settingTarget(target:XYLogPrintTarget) {
        
        self.selectedTarget = target
        
//        self.pickerView.selectedRow(inComponent: target.rawValue)
    }
    
    override func initProperty() {
        super.initProperty()
        
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.bgView)
        self.addSubview(self.pickerView)
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.bgView.autoEdgesPinView(otherView: self)
        
        self.pickerView.autoSetDimension(.height, toSize: UIH(200))
        self.pickerView.autoPinView(otherView: self, edges: .leading, .bottom, .trailing)
    }
    
    lazy var bgView: UIButton = {
        
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
    
    var delegate:XYLogChangePrintTargetPickerDelegate?
    var selectedTarget:XYLogPrintTarget = XYLogPrintTarget.None
    
    @objc func bgButtonHandle(btn:UIButton?){
        
        self.removeFromSuperview()
        
        guard let del = self.delegate else { return }
        
        del.selectedTarget(target: self.selectedTarget)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 4
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title:String = ""
        
        if let target = XYLogPrintTarget(rawValue: row) {
            
            title = target.name()
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var selectedTarget:XYLogPrintTarget = XYLogPrintTarget.None
        
        if let target = XYLogPrintTarget(rawValue: row) {
            
            selectedTarget = target
        }
        
        self.selectedTarget = selectedTarget
    }
    
    
    
}
