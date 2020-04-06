//
//  PracticeProcessTimeConsumingItem_Video.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/9/29.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

/// 耗时单元 - 视频单元
class PracticeProcessTimeConsumingItem_Video : XYObject, PracticeProcessTimeConsumingItemProtocol {
    
    private let videoUrl : String
    
    let itemType: PracticeProcessTimeConsumingItemType = PracticeProcessTimeConsumingItemType.Video
    
    var audioTxtOrNil : String?
    
    var repeatCount : UInt = 0
    
    var fileRootPathOrNil : String?
    
    init(videoUrl: String) {
        
        self.videoUrl = videoUrl
        
        super.init()
    }
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any? = nil) -> PracticeProcessTimeConsumingItem_Video? {
        
        guard let dataDic = dataDicOrNil,
            0 < dataDic.count else { return nil }
        
        //        (dataDic as Dictionary).xyLogAllProperty(name: "PracticeProcessTimeConsumingItem_Video")
        
        guard let audioURL = dataDic.object(forKey: "audioURL") as? String,
            audioURL.isNotEmpty else { return nil }
        
        let audioItem = PracticeProcessTimeConsumingItem_Video(videoUrl: audioURL)
        
        return audioItem
    }
    
    /**
     *    @description 有效的文件地址
     *
     */
    var realVideoPath : String {
        
        guard let rootPath = self.fileRootPathOrNil,
            rootPath.isNotEmpty else {
                
                return self.videoUrl
        }
        
        return "\(rootPath)\(self.videoUrl)"
    }
    
    lazy var disposeBag: DisposeBag = {
        
        return DisposeBag()
    }()
}

extension PracticeProcessTimeConsumingItem_Video: StructModelProtocol_Create {
    
    var flagText: String {
        
        return self.videoUrl.MD5String()
    }
    
    var itemSearchId: String { return self.videoUrl }
}
