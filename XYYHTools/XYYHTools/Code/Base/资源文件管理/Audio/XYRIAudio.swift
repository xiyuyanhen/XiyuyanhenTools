//
//  XYRIAudio.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/3.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYRIAudio : XYResourceItem {
    
    static let ResourceType : XYResourceType = XYResourceType.Audio

    enum CreatedType {
        case Silent
        case Copy
        case Original
    }
    
    /// 生成类型
    var createdType : CreatedType = CreatedType.Original
    
    /// 音频对应文本
    var audioTextOrNil : String?
    
    /// 提示信息
    var tipOrNil : String?
    
    /// 播放进度
    var progressOrNil : TimeInterval?
    
    /// 音频资源
    lazy var assetOrNil: AVURLAsset? = {
        
        /// 注意，此url地址需要用 URL(fileURLWithPath:) 才能得到正确的数据
        guard self.resourceAddress.type == XYResourceAddressType.Path,
            let url = self.itemUrlOrNil else { return nil }
        
        return XYAVAssetTools.AVURLAssetBy(url)
    }()
    
    /// 音频时长
    lazy var durationOrNil : TimeInterval? = {
        
        guard let asset = self.assetOrNil else { return nil }
        
        let duration = asset.xyDurationSeconds
        
        guard 0.0 < duration else { return nil }
        
        return TimeInterval(duration)
    }()
    
    override init(resourceAddress: XYResourceAddress, resourceType: XYResourceType = XYResourceType.Audio) {
        
        super.init(resourceAddress: resourceAddress, resourceType: resourceType)
    }
    
    convenience init?(path pathOrNil:String? = nil,
                      audioText audioTextOrNil : String? = nil,
                      tip tipOrNil: String? = nil) {
        
        guard let rAddress = XYResourceAddress(address: pathOrNil, type: XYResourceAddressType.Path) else { return nil }
        
        self.init(resourceAddress: rAddress)
        
        self.audioTextOrNil = audioTextOrNil
        
        self.tipOrNil = tipOrNil
    }
    
    convenience init?(url urlOrNil:String? = nil,
                      audioText audioTextOrNil : String? = nil,
                      tip tipOrNil: String? = nil) {
        
        guard let rAddress = XYResourceAddress(address: urlOrNil, type: XYResourceAddressType.URL) else { return nil }
        
        self.init(resourceAddress: rAddress)
        
        self.audioTextOrNil = audioTextOrNil
        
        self.tipOrNil = tipOrNil
    }
    
}

/// NSCopying
extension XYRIAudio : XYCopyProtocol {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let newObj = XYRIAudio(resourceAddress: self.resourceAddress)
        newObj.queueIdOrNil = self.queueIdOrNil
        
        newObj.audioTextOrNil = self.audioTextOrNil
        newObj.tipOrNil = self.tipOrNil
        newObj.progressOrNil = self.progressOrNil
        
        /// 将此资源生成方式标记为Copy
        newObj.createdType = CreatedType.Copy
        
        return newObj
    }
}

extension XYRIAudio : PracticeProcessTimeConsumingItemProtocol {
    
    var flagText: String {
        
        return self.itemId
    }
    
    var itemType: PracticeProcessTimeConsumingItemType { return PracticeProcessTimeConsumingItemType.Audio }
}

extension XYRIAudio {
    
    static func GetFirstOriginalItem(items itemsOrNil: XYRIAudio.ModelArray?) -> XYRIAudio? {
        
        guard let items = itemsOrNil else { return nil }
        
        for item in items {
            
            guard item.createdType == .Original else { continue }
            
            return item
        }
        
        return nil
    }
}
