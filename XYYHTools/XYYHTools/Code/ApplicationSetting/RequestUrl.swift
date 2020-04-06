//
//  RequestUrl.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/5/26.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

//上传头像测试 http://test.queryall.cn:10024/web/uploadPage
//短信测试：http://test.queryall.cn:10024/user/test?phone=135XXXXXXXX

enum RequestSubUrl : String, RequestUrlProtocol {
    
    /// 超时测试接口
    case TimeOut_Test = "www.google.com"
    
    /// 单词前缀匹配查询 (20200117)
    case Word_GetPrefixWordList = "word/getPrefixWordList"
    
}



