//
//  XYBannerModel.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/25.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class XYBannerModel: XYObject {
    
    enum BannerModelType : String {
        case Web = "web"
        case Text = "text"
    }
    
    let modelId : String
    let name : String
    let type : BannerModelType
    let photoUrlStr : String
    let webUrlStr : String
    
    var photoUrl : URL? {

        return URL(string: self.photoUrlStr)
    }
    
    var webUrl : URL? {
        
        return URL(string: self.webUrlStr)
    }
    
    init?(dataDic: NSDictionary) {
        
        /*
 
 {
     createAt = "2018-09-26 14:14:59";
     id = 10011;
     name = "首页轮播图";
     photo = "http://www.baidu.com";
     type = "公告";
     updateAt = "2018-09-26 14:15:03";
     url = "http://www.baidu.com";
 }
 
 */
        
        guard dataDic.count > 0 else { return nil }
        
        let modelId = dataDic.objectFromRequestData(forKey: "id")
        guard IsValidateString(string: modelId) else { return nil }
        
        let typeStr = dataDic.objectFromRequestData(forKey: "type")
        guard let type = BannerModelType(rawValue: typeStr) else { return nil }
        
        let name = dataDic.objectFromRequestData(forKey: "name")
        let photo = dataDic.objectFromRequestData(forKey: "photo")
        let url = dataDic.objectFromRequestData(forKey: "url")
        
        self.modelId = modelId
        self.name = name
        self.photoUrlStr = photo
        self.type = type
        self.webUrlStr = url
    
        super.init()
    }
}
