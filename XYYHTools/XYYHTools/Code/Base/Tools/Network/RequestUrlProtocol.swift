//
//  Public.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/2/10.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

///
protocol RequestUrlProtocol {
    
    var rawValue: String { get }
    
    var schemeOrNil: String? { get }
}

extension RequestUrlProtocol {
    
    var schemeOrNil: String? {
        return nil
    }
    
    var path: String { return self.rawValue }
    
    func urlString(_ scheme: String) -> String {
        
        return "\(scheme)/\(self.path)"
    }
    
    func urlStringByScheme(_ address: APP_RequestRootAddress = ProjectSetting.Share().requestAddress) -> String {
        
        return "\(address.schemePath)/\(self.path)"
    }
}


