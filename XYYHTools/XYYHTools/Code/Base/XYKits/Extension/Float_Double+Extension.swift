//
//  Float_Double+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2020/2/7.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation

extension Float {
    
    /**
     *    @description 转成指定精度的字符串数据
     *
     *    @param    length    小数位数(默认0位)
     *
     *    @param    trimmingEndZD    是否截去末尾的小数部分的0及.
     *
     *    @return   字符串
     */
    func xyDecimalLength( _ length : UInt = 0, trimmingEndZD: Bool = true) -> String {
        
        var str : String = String(format: "%.\(length)f", self)
        
        if length != 0,
            trimmingEndZD {
            
            // 截去末尾的小数部分的0及.
            str = str.trimmingEndZeroAndDot()
        }
        
        return str
    }
    
    /// 取整
    func xyDecimalRounding() -> (number: Float, text: String) {
        
        let numStr : String = String(format: "%.2f", self)
        
        let parts = numStr.components(separatedBy: ".")
        
        guard let first = parts.first,
            let newValue = first.xyToFloat() else { return (number: self, text: numStr) }
        
        return (number: newValue, text: first)
    }
    
    /**
     *    @description 截取指定精度的数据
     *
     *    @param    scale    小数位数
     *
     */
    func xyScale( _ scale : Int16) -> Float {
        
        let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: self)
        
        let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
        
        let resultFloat = resultNumber.floatValue
        
        return resultFloat
    }
    
    var separateToIntegerAndDecimal : (integer: Int, decimal: Float) {
        
        let integer : Int  = Int(self)
        let decimal : Float = self - Float(integer)
        
        return (integer: integer, decimal: decimal)
    }
}

extension Double {
    
    func xyDecimalLength( _ length : UInt = 0) -> String {
        
        let str : String = String(format: "%.\(length)f", self)
        
        return str
    }
    
    func xyScale( _ scale : Int16) -> Double {
        
        let decimaleNumber : NSDecimalNumber = NSDecimalNumber(value: self)
        
        let decimalNumberHandle : NSDecimalNumberHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        let resultNumber : NSDecimalNumber = decimaleNumber.rounding(accordingToBehavior: decimalNumberHandle)
        
        let resultDouble = resultNumber.doubleValue
        
        return resultDouble
    }
    
    var separateToIntegerAndDecimal : (integer: Int, decimal: Double) {
        
        let integer : Int  = Int(self)
        let decimal : Double = self - Double(integer)
        
        return (integer: integer, decimal: decimal)
    }
}
