//
//  XYErrorCustomType.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/2.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

let XYErrorCustomTypeSeparatedText : String = "#*#"

protocol XYErrorCustomTypeProtocol {
    
    var rawValue : String { get }
}

extension XYErrorCustomTypeProtocol {

    var code : Int {
        
        guard let codeText = self.rawValue.components(separatedBy: XYErrorCustomTypeSeparatedText).first,
            let code = Int(codeText) else { return 0 }
        
        return code
    }
    
    var msg : String {
        
        guard let msg = self.rawValue.components(separatedBy: XYErrorCustomTypeSeparatedText).elementByIndex(1) else {
            
            return "未知"
        }
        
        return msg
    }
    
    func error() -> XYError {
        
        let error = XYError(code: self.code, detailMsg: self.msg)
        
        return error
    }
    
    func isEqual( _ error : XYError) -> Bool {
        
        guard error.detailMsg == self.msg,
            error.code == self.code else { return false }
        
        return true
    }
}
