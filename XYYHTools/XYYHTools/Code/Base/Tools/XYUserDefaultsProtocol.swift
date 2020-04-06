//
//  XYUserDefaultsProtocol.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/12/29.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYUserDefaultsProtocol : StructModelProtocol_Create {
    
    static var CacheBrifKey : String { get }

    var modelDataDic : DataType? { get }

}

extension XYUserDefaultsProtocol {
    
    typealias DataType = Dictionary<String, Any>
    
    private static var DefaultStandard : UserDefaults {
        
        let standard = UserDefaults.standard
        
        return standard
    }
    
    private static var CacheKey : String {
        
        let frontPart = "XYUserDefaults_Key_"
        
        let key = "\(frontPart)\(Self.CacheBrifKey)"
        
        return key
    }
    
    @discardableResult func save() -> Bool {
        
        guard let dataDic = self.modelDataDic,
            let data = dataDic.toData() else { return false }
        
        Self.DefaultStandard.set(data, forKey: Self.CacheKey)
        
        return true
    }
    
    static func Read() -> ModelType? {
    
        guard let dataOrNil = self.DefaultStandard.object(forKey: self.CacheKey),
            let data = dataOrNil as? Data,
            let dic = DataType.CreateWith(jsondata: data),
            let model = self.CreateModel(dataDic: (dic as NSDictionary), extraData: nil) else { return nil }
        
        return model
    }
    
    static func Clear() {
        
        self.DefaultStandard.set(nil, forKey: self.CacheKey)
    }
    
}
