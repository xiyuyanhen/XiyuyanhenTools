//
//  XYCryptorTools.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/22.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

struct XYCryptorTools {
    
    /// 密码
    enum PWD: String {
        case Normal = "d2e^sg@d4f9"
        
        var p: String { return self.rawValue }
    }
}

// MARK: - 加密
extension XYCryptorTools {
    
    /**
     *    @description 将文本加密成二进制数据
     *
     *    @param    text    文本
     *
     *    @param    pwd    密码
     *
     *    @return   Data?
     */
    static func EncryptToData(_ text: String, pwd: String = PWD.Normal.p) -> Data? {
        
        guard let textData = text.data(using: String.Encoding.utf8) else { return nil }
        
        return RNCryptor.encrypt(data: textData, withPassword: pwd)
    }
    
    /**
    *    @description 将文本加密成二进制数据并转成十六进制字符串
    *
    *    @param    text    文本
    *
    *    @param    pwd    密码
    *
    *    @return   String?
    */
    static func EncryptToHexString(_ text: String, pwd: String = PWD.Normal.p) -> String? {
        
        guard let textData = self.EncryptToData(text, pwd: pwd) else { return nil }
        
        return textData.toHexString()
    }
    
}

// MARK: - 解密
extension XYCryptorTools {
    
    static func DecryptToData(_ data: Data, pwd: String = PWD.Normal.p) -> XYNormalResult<Data, XYError> {
        
        do {
            let decryptData = try RNCryptor.decrypt(data: data, withPassword: pwd)
            
            return XYNormalResult.Complete(decryptData)
            
        } catch let error as RNCryptor.Error {
            
            XYLog.LogNote(msg: "\(error)")
            
            return XYNormalResult.Failure(XYError(type: .Unknow))
            
        } catch {
            
            return XYNormalResult.Failure(XYError(type: .Unknow))
        }
    }
    
    static func DecryptToString(_ data: Data, pwd: String = PWD.Normal.p) -> XYNormalResult<String, XYError> {
        
        switch self.DecryptToData(data, pwd: pwd) {
        
        case .Complete(let decryptData):
            
            guard let decryptText = String(data: decryptData, encoding: String.Encoding.utf8) else {
                
                return XYNormalResult.Failure(XYError(type: .Unknow))
            }
            
            return XYNormalResult.Complete(decryptText)
            
        case .Failure(let error):
            
            return XYNormalResult.Failure(error)
        }
    }
    
    static func DecryptHexStringToString(_ hexText: String, pwd: String = PWD.Normal.p) -> XYNormalResult<String, XYError> {

        switch self.DecryptToData(Data(hex: hexText), pwd: pwd) {
        
        case .Complete(let decryptData):
            
            guard let decryptText = String(data: decryptData, encoding: String.Encoding.utf8) else {
                
                return XYNormalResult.Failure(XYError(type: .Unknow))
            }
            
            return XYNormalResult.Complete(decryptText)
            
        case .Failure(let error):
            
            return XYNormalResult.Failure(error)
        }
    }
    
}

// MARK: -
extension XYCryptorTools {
    
    /// 将字符串数组转为加密的十六进制数据
    static func EncryptToHexStringsBy(textArr: [String]) {

        for text in textArr {

            guard let hex = XYCryptorTools.EncryptToHexString(text) else { continue }

            XYLog.Log(msg: "\(text) = \"\(hex)\"", type: .Brief)
        }
    }
    
}
