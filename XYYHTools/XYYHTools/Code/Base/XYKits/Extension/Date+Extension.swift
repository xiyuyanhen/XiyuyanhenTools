//
//  Date+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/10.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension Date {
    
    static func Create(dateString:String, cFormatter:DateFormatter.CustomFormatter, timeZone:TimeZone = TimeZone.current) -> Date? {
        
        let formatter = DateFormatter(cFormatter: cFormatter, timeZone: timeZone)
        if let date = formatter.date(from: dateString) {
            
            return date
        }
        
        return nil
    }
    
    /**
     *    @description 获取当前时间处于周几
     *
     *    @return   例: 周一
     */
    func weekTitle() -> String{
        
        let weekNumString = self.dateString(cFormatter: .Week)
        
        var weekString:String = ""
        if weekNumString == "01" {
            
            weekString = "周日"
        }else if weekNumString == "02" {
            
            weekString = "周一"
        }else if weekNumString == "03" {
            
            weekString = "周二"
        }else if weekNumString == "04" {
            
            weekString = "周三"
        }else if weekNumString == "05" {
            
            weekString = "周四"
        }else if weekNumString == "06" {
            
            weekString = "周五"
        }else if weekNumString == "07" {
            
            weekString = "周六"
        }
        
        return weekString
    }
    
    func dateString(cFormatter:DateFormatter.CustomFormatter) -> String {
        
        let formatter = DateFormatter(cFormatter: cFormatter)
        
        let string = formatter.string(from: self)
        
        return string
    }
    
}

extension String {
    
    /**
     *    @description 根据提供的自定义方式获取时间
     *
     *    @param    cFormatter    自定义方式
     *
     *    @return   Date?
     */
    func xyToDate(cFormatter:DateFormatter.CustomFormatter, timeZone:TimeZone = TimeZone.current) -> Date? {
        
        return Date.Create(dateString: self, cFormatter: cFormatter, timeZone: timeZone)
    }
    
    /**
     *    @description 根据提供的自定义方式转成另外一种字符样式
     *
     *    @param    fFormatter    解析时间的方式
     *
     *    @param    fFormatter    将时间的转成的结果方式
     *
     *    @return   String?
     */
    func xyToOtherDateText(fFormatter: DateFormatter.CustomFormatter, tFormatter: DateFormatter.CustomFormatter, timeZone:TimeZone = TimeZone.current) -> String? {
        
        guard let date = self.xyToDate(cFormatter: fFormatter, timeZone: timeZone) else {
            
            return nil
        }
        
        return date.dateString(cFormatter: tFormatter)
    }
    
    func xyToOtherDateTextFromRequest(tFormatter: DateFormatter.CustomFormatter, timeZone:TimeZone = TimeZone.current) -> String? {
        
        let dateText = self.replacingOccurrences(of: "T", with: " ")
        
        guard let date = dateText.xyToDate(cFormatter: DateFormatter.CustomFormatter.Custom_A, timeZone: timeZone) else {
            
            return nil
        }
        
        return date.dateString(cFormatter: tFormatter)
    }
}

// MARK: - 时间差的处理
extension Date {
    
    /**
     *    @description 时间差(单位：秒)
     *
     *    @param    date    基准时间
     *
     *    @param    otherDate    比较时间
     *
     *    @return   时间差
     */
    static func TimeIntervalSecond(date: Date = Date(), otherDate: Date) -> TimeInterval {
        
        let timeInterval = date.timeIntervalSince(otherDate) // 时间单位s
        
        return timeInterval
    }
    
    /**
     *    @description 时间差(单位：毫秒)
     *
     *    @param    date    基准时间
     *
     *    @param    otherDate    比较时间
     *
     *    @return   时间差
     */
    static func TimeIntervalMilliSecond(date: Date = Date(), otherDate: Date) -> TimeInterval {
        
        let timeInterval = self.TimeIntervalSecond(date: date, otherDate: otherDate) * 1000 // 将时间单位s转为ms

        return timeInterval
    }
}
