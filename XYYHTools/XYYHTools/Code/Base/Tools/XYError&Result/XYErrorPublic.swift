//
//  XYErrorCustomType.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/14.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

enum XYErrorCustomType : String, XYErrorCustomTypeProtocol, XYEnumTypeAllCaseProtocol {
    
    /// 未知
    case Unknow = "0#*#未知"
    
    case DataToJson = "1#*#数据转成Json格式失败"
    
    case JpegData = "201#*#Image文件转Data失败"
    
    /// 无法生成视图 (code: 10001)
    case NotCreateView = "10001#*#条件不足，不生成此View"
    
    /// 跟读 (code: 20001)
    case 跟读_生成需要的提交作答结果 = "20001#*#生成需要的提交作答结果失败"

    /// 音标 (code: 30001)
    case 音标_生成提交作答数据 = "30001#*#生成提交作答数据失败,无法上传"
    case 音标_作答未完成 = "30002#*#作答未完成"
    
    
    
    
    
}
