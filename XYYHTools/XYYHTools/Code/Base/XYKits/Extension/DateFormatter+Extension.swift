//
//  DateFormatter+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/10.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    enum CustomFormatter : String {
        
        /// yyyy-MM-dd HH:mm:ss
        case Custom_A = "yyyy-MM-dd HH:mm:ss"
        
        /// yyyy-MM-dd HH:mm
        case Custom_B = "yyyy-MM-dd HH:mm"
        
        /// E/dd/MM/yyyy
        case Custom_C = "E/dd/MM/yyyy"
        
        /// yyyy-MM-dd HH:mm E
        case Custom_D = "yyyy-MM-dd HH:mm ee"
        
        /// 2019年04月19日 08:00
        case Custom_E = "yyyy年MM月dd日 HH:mm"
        
        /// 2019-05-28
        case Custom_F = "yyyy-MM-dd"
        
        /// 05-28
        case Custom_G = "MM-dd"
        
        /// 05-28 08:00
        case Custom_H = "MM-dd HH:mm"
        
        /// 分:秒:毫秒
        case Custom_I = "mm:ss:SSS"
        
        /// 08:00
        case Time = "HH:mm"
        
        /// E
        case Week = "ee"
        
        /// 年
        case Year = "yyyy"
    }
    
    convenience init(cFormatter:CustomFormatter, timeZone:TimeZone = TimeZone.current)  {
        
        self.init()
        
        self.timeZone = timeZone
        self.dateFormat = cFormatter.rawValue
    }
    
}
