//
//  XYError.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/8/13.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class XYError : XYObject, Error {
    
    /// 错误代号
    let code : Int
    
    /// 错误信息
    let detailMsg : String
    
    /// 错误理由
    var reasonOrNil: String?
    
    /// 错误携带信息
    var userInfoOrNil: [String : Any]?
    
    init(code: Int, detailMsg: String) {
        
        self.code = code
        self.detailMsg = detailMsg
        
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        
        guard let otherError = object as? XYError,
            otherError.detailMsg == self.detailMsg,
            otherError.code == self.code else { return false }
        
        return true
    }
    
}

extension XYError {
    
    convenience init(type: XYErrorCustomType) {
        
        self.init(code: type.code, detailMsg: type.msg)
    }
    
    convenience init(error: Error) {
        
        let nsError = error as NSError
        
        let detailMsg: String
        
        if let description: String = nsError.userInfo.xyObject(NSLocalizedDescriptionKey) {
            
            detailMsg = description
        }else {
            
            detailMsg = nsError.domain
        }
        
        self.init(code: nsError.code, detailMsg: detailMsg)
        
        self.userInfoOrNil = nsError.userInfo
    }
}
