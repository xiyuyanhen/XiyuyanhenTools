//
//  UITextField+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/24.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

//extension UITextField : XYViewNewAutoLayoutProtocol {
//
//    func systemInitProperty() {
//
//    }
//
//    func systemLayoutAddViews() {
//
//    }
//
//    func systemLayoutAllViews() {
//
//    }
//
//}

extension UITextField {
    
    //关闭首字母大写
    func setAutocapitalization(type: UITextAutocapitalizationType = .none) {
        
        self.autocapitalizationType = type
    }
    
    //关闭自动联想
    func setAutocorrectionType(type: UITextAutocorrectionType = .no) {
        
        self.autocorrectionType = type
    }
}

extension UITextField {
    
    /// 前后去空格
    var textByTrimmingWhiteSpace : String? {
        
        guard let text = self.text else { return nil }
        
        return text.trimmingWhiteSpace()
    }

    /// 前后去空格与换行
    var textByTrimmingWhiteSpaceAndWrap : String? {
        
        guard let text = self.text else { return nil }
        
        return text.trimmingWhiteSpace().trimmingWrap()
    }
}
