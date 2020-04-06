//
//  PracticeProcessTimeConsumingItem_Audio.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/1.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 耗时单元 - 音频单元
class PracticeProcessTimeConsumingItem_Audio : XYObject, StructModelProtocol_Create, PracticeProcessTimeConsumingItemProtocol {
    
    private let audioUrl : String
    
    var flagText: String {
        
        return self.audioUrl.MD5String()
    }
    
    let itemType: PracticeProcessTimeConsumingItemType = PracticeProcessTimeConsumingItemType.Audio
    
    var itemSearchId: String { return "" }
    
    var audioTxtOrNil : String?
    
    var repeatCount : UInt = 0
    var beforeTimeOrNil : TimeInterval?
    var intervalOrNil : TimeInterval?
    var afterTimeOrNil : TimeInterval?
    
    var fileRootPathOrNil : String?
    
    init(audioUrl: String) {
        
        self.audioUrl = audioUrl
        
        super.init()
    }
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any? = nil) -> PracticeProcessTimeConsumingItem_Audio? {
        
        guard let dataDic = dataDicOrNil,
            0 < dataDic.count else { return nil }
        
        //        (dataDic as Dictionary).xyLogAllProperty(name: "PracticeProcessTimeConsumingItem_Audio")
        
        /*
         {
         "audioTxt" : " W: Jack, could you feed the dog?\nM: Sure, Mum. I’ll do it right away.\nQ: What will Jack do?\n",
         "interval" : 0,
         "count" : 1,
         "beforeWaitTime" : 5,
         "audioURL" : "E2D954D8A1964D72AB8BF88758CFC32F.mp3",
         "afterWaitTime" : 5
         }
         */
        
        guard let audioURL = dataDic.object(forKey: "audioURL") as? String,
            audioURL.isNotEmpty else { return nil }
        
        let audioItem = PracticeProcessTimeConsumingItem_Audio(audioUrl: audioURL)
        
        if let audioTxt = dataDic.object(forKey: "audioTxt") as? String,
            audioTxt.isNotEmpty {
            
            audioItem.audioTxtOrNil = audioTxt
        }
        
        if let count = UInt(dataDic.objectFromRequestData(forKey: "count")),
            0 < count {
            
            audioItem.repeatCount = count
        }
        
        if let bTime = TimeInterval(dataDic.objectFromRequestData(forKey: "beforeWaitTime")),
            0.0 < bTime {
            
            audioItem.beforeTimeOrNil = bTime
        }
        
        if let interval = TimeInterval(dataDic.objectFromRequestData(forKey: "interval")),
            0.0 < interval {
            
            audioItem.intervalOrNil = interval
        }
        
        if let aTime = TimeInterval(dataDic.objectFromRequestData(forKey: "afterWaitTime")),
            0.0 < aTime {
            
            audioItem.afterTimeOrNil = aTime
        }
        
        return audioItem
    }
    
    /**
     *    @description 有效的文件地址
     *
     */
    var realAudioPath : String {
        
        guard let rootPath = self.fileRootPathOrNil,
            rootPath.isNotEmpty else {
                
                return self.audioUrl
        }
        
        return "\(rootPath)\(self.audioUrl)"
    }
}

extension PracticeProcessTimeConsumingItem_Audio {
    
    convenience init(audioItem: XYRIAudio) {
        
        self.init(audioUrl: audioItem.resourceAddress.address)
        
        self.audioTxtOrNil = audioItem.audioTextOrNil
    }
}

