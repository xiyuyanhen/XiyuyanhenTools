//
//  Protocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/22.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYCryptorTextProtocol {
    
    var rawValue: String { get }
}

extension XYCryptorTextProtocol {
    
    var hexData: Data { return Data(hex: self.rawValue) }
    
    func decryptText(defaultText: String = "") -> String {
        
        switch XYCryptorTools.DecryptToString(self.hexData) {
            
        case .Complete(let text): return text
            
        case .Failure(_):
            
            return defaultText
        }
    }
}
