//
//  ProvinceCityPickerView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/8/3.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

/*

import Foundation

protocol ProvinceCityPickerDelegate {

    func selectedCity(type:ProvinceCityPickerView.SelectType, cityModelOrNil:CityModel?)
}

class ProvinceCityPickerView : BaseView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    enum SelectType {
        case All
        case Province
//        case City
    }
    
    var selectType:SelectType = SelectType.All
    
    override func initProperty() {
        super.initProperty()
        
        self.setBackgroundColor(customColor: .clear)
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
    
    lazy var provinceList: ProvinceModel.ModelArray = {
        
        let list = ProvinceModel.ModelArray()
        
        return list
    }()
    
    func setupsProvinceList(provinceList:ProvinceModel.ModelArray) {
        
        self.provinceList = provinceList
        
        self.pickerView.reloadAllComponents()
        
        //自动选择当前选择的地区
        var provinceRow:Int = 0
        var cityRow:Int = 0
        
        if let oldModel = LocationGradeModel.Read() {
            
            for provinceRowIndex in 0...(self.provinceList.count-1) {
                
                let provinceModel = self.provinceList[provinceRowIndex]
                
                if provinceModel.provinceId == oldModel.provinceId {
                    
                    provinceRow = provinceRowIndex
                    
                    if provinceModel.cityList.count > 0 {
                        
                        for cityRowIndex in 0...(provinceModel.cityList.count-1){
                            
                            let cityModel = provinceModel.cityList[cityRowIndex]
                            
                            if cityModel.cityId == oldModel.cityId {
                                
                                cityRow = cityRowIndex
                                break
                            }
                        }
                    }
                    
                    break
                }
            }
        }
        
        self.pickerView.selectRow(provinceRow, inComponent: 0, animated: false)
        if let del = self.pickerView.delegate {
            
            del.pickerView!(self.pickerView, didSelectRow: provinceRow, inComponent: 0)
        }
        
        guard self.selectType == .All else { return }
        
        self.pickerView.selectRow(cityRow, inComponent: 1, animated: false)
        if let del = self.pickerView.delegate {
            
            del.pickerView!(self.pickerView, didSelectRow: cityRow, inComponent: 1)
        }
    }
    
    var delegate:ProvinceCityPickerDelegate?
    var selectedCityModel:CityModel?
    
    @objc func bgButtonHandle(btn:UIButton?){
        
        self.removeFromSuperview()
        
        guard let del = self.delegate else { return }
        
        del.selectedCity(type:self.selectType, cityModelOrNil: self.selectedCityModel)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        var count = 0
        
        switch self.selectType {
            
        case .All:
            count = 2
            break
            
        case .Province:
            count = 1
            break
            
        }
        
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count:Int = 0
        if component == 0 {
            
            count = self.provinceList.count
        }else if component == 1 {
            
            let provincIndex = self.pickerView.selectedRow(inComponent: 0)
            let provinceModel = self.provinceList[provincIndex]
            
            count = provinceModel.cityList.count
        }
        
        return count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title:String = ""
        
        if component == 0 {
            
            if row < self.provinceList.count {
                
                let provinceModel = self.provinceList[row]
                
                title = provinceModel.provinceName
            }else{
                
                DebugNote(tip: "选择省越界! row:\(row)")
            }
            
        }else if component == 1 {
            
            let provincIndex = self.pickerView.selectedRow(inComponent: 0)
            
            if provincIndex < self.provinceList.count {
                
                let provinceModel = self.provinceList[provincIndex]
                
                if row < provinceModel.cityList.count {
                    
                    let cityModel = provinceModel.cityList[row]
                    
                    title = cityModel.cityName
                }else{
                    
                    DebugNote(tip: "选择市越界! 省:\(provinceModel.provinceName) cityList:\(provinceModel.cityList.count) index:\(row)")
                }
                
            }else{
                
                DebugNote(tip: "选择省越界! index:\(provincIndex)")
            }
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var selectedCityModel:CityModel?
        
        if component == 0 {
            
            let provinceModel = self.provinceList[row]
            
            if self.selectType == .All {
                
                self.pickerView.reloadComponent(1)
                self.pickerView.selectRow(0, inComponent: 1, animated: false)
                if let del = self.pickerView.delegate {
                    
                    del.pickerView!(self.pickerView, didSelectRow: 0, inComponent: 1)
                }
                return
            }
            
            if selectedCityModel == nil {
                
                let cityModel = CityModel(provinceId: provinceModel.provinceId, provinceName: provinceModel.provinceName, cityId: provinceModel.provinceId, cityName: provinceModel.provinceName)
                
                selectedCityModel = cityModel
            }

        }else if (self.selectType == .All) && (component == 1) {
            
            let provinceIndex = self.pickerView.selectedRow(inComponent: 0)
            
            if provinceIndex < self.provinceList.count {
                
                let provinceModel = self.provinceList[provinceIndex]
                
                if row < provinceModel.cityList.count {
                    
                    let cityModel = provinceModel.cityList[row]
                    
                    selectedCityModel = cityModel
                }else {
                    
                    let cityModel = CityModel(provinceId: provinceModel.provinceId, provinceName: provinceModel.provinceName, cityId: provinceModel.provinceId, cityName: provinceModel.provinceName)
                    
                    selectedCityModel = cityModel
                }
            }
        }
        
        self.selectedCityModel = selectedCityModel
    }
    
    
    
}

 */
