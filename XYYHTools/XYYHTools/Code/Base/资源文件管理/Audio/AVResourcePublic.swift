//
//  AVResourcePublic.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/9/23.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

/************ 音视频资源公用方法 ********/

import Foundation

extension AVURLAsset {
    
    /// 时长(单位: 秒)
    var xyDurationSeconds: Double {
        
        return CMTimeGetSeconds(self.duration)
    }
}

struct XYAVAssetTools {
    
    /**
     *    @description 获取音视频资源
     *
     *    @param    url    音视频资源地址
     *
     *    @return   音视频资源
     */
    static func AVURLAssetBy(_ urlOrNil: URL?) -> AVURLAsset? {
        
        guard let url = urlOrNil else { return nil }
        
        // AVURLAsset: AVAsset的具体子类，用于从本地或远程URL初始化asset。
        
        /* AVURLAssetPreferPreciseDurationAndTimingKey
            asset是否应该准备好指示精确的持续时间，并提供按时间进行准确的随机访问。
            这个键的值是一个布尔型的NSNumber。
         */
        
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey: NSNumber(value: true)]
        
        return AVURLAsset(url: url, options: options)
    }
    
    /**
     *    @description 获取音视频资源的时长
     *
     *    @param    path    音视频资源地址
     *
     *    @return   时长
     */
    static func AudioOrAVTimeByPath(_ path: String) -> Double {

        return self.AudioOrAVTimeByUrl(URL(fileURLWithPath: path))
    }
    
    /**
     *    @description 获取音视频资源的时长
     *
     *    @param    url    音视频资源地址
     *
     *    @return   时长
     */
    static func AudioOrAVTimeByUrl(_ url: URL) -> Double {
        
        guard let asset = XYAVAssetTools.AVURLAssetBy(url) else { return 0.0 }
        
        return asset.xyDurationSeconds
    }
    
}

/**
 *    @description 获取音视频资源的时长
 *
 *    @param    filePath    音视频资源地址
 *
 *    @return   时长
 */
func AudioOrAVTime(filePath path: String) -> Double {
    
    guard let asset = XYAVAssetTools.AVURLAssetBy(URL(fileURLWithPath: path)) else { return 0.0 }
    
    return asset.xyDurationSeconds
}

/**
 *    @description 获取音视频资源的时长
 *
 *    @param    fileUrl    音视频资源地址
 *
 *    @return   时长
 */
func AudioOrAVTime(fileUrl:URL) -> Double {
    
    // AVURLAsset: AVAsset的具体子类，用于从本地或远程URL初始化asset。
    
    /* AVURLAssetPreferPreciseDurationAndTimingKey
        asset是否应该准备好指示精确的持续时间，并提供按时间进行准确的随机访问。
        这个键的值是一个布尔型的NSNumber。
     */
    
    guard let asset = XYAVAssetTools.AVURLAssetBy(fileUrl) else { return 0.0 }
    
    return asset.xyDurationSeconds
}

// MARK: - Video Image

/**
 *    @description 获取第一帧图像
 *
 *    @param    path    视频资源文件地址
 *
 *    @return   CGImage?
 */
func XYAVPlaceholderImgRef(path pathOrNil: String?) -> CGImage? {
    
    guard let path = pathOrNil,
        path.isNotEmpty,
        let url = URL(string: path) else { return nil }
    
    return XYAVPlaceholderImgRef(url: url)
}

/**
 *    @description 获取第一帧图像
 *
 *    @param    url    视频资源文件地址
 *
 *    @return   CGImage?
 */
func XYAVPlaceholderImgRef(url urlOrNil: URL?) -> CGImage? {
    
    guard let url = urlOrNil else { return nil }
    
    let asset = AVAsset(url: url)
    
    return XYAVPlaceholderImgRef(asset: asset)
}

/**
 *    @description 获取第一帧图像
 *
 *    @param    asset    AVAsset资源
 *
 *    @return   CGImage?
 */
func XYAVPlaceholderImgRef(asset:AVAsset) -> CGImage? {
    
    let imageGeneration = AVAssetImageGenerator(asset: asset)
    
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
    imageGeneration.appliesPreferredTrackTransform = true
    imageGeneration.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
    
    //let timeValue = avAsset.duration.value;//总帧数
    let timeScale = asset.duration.timescale //帧率 fps
    
    let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: timeScale);
    var actualTime : CMTime = CMTimeMake(value: 0, timescale: 0)
    
    guard let imgRef = try? imageGeneration.copyCGImage(at: time, actualTime: &actualTime) else { return nil }
    
    return imgRef
}
