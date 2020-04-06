//
//  XYFileFormat.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/12/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// 文件格式
struct XYFileFormat {
    
    /// 图片格式
    enum ImageFormat: XYEnumTypeAllCaseProtocol {
        case Unknow
        case JPEG
        case PNG
        case GIF
        case TIFF
        case WebP
        case HEIC
        case HEIF
        
        init(_ data: Data) {
            
            var buffer = [UInt8](repeating: 0, count: 1)
            data.copyBytes(to: &buffer, count: 1)
            
            switch buffer {
            case [0xFF]:
                self = .JPEG
                return
                
            case [0x89]:
                self = .PNG
                return
                
            case [0x47]:
                self = .GIF
                return
                
            case [0x49],[0x4D]:
                self = .TIFF
                return
                
            case [0x52] where data.count >= 12:
                
                if let str = String(data: data[0...11], encoding: .ascii), str.hasPrefix("RIFF"), str.hasSuffix("WEBP") {
                    
                    self = .WebP
                    return
                }
                
            case [0x00] where data.count >= 12:
                
                if let str = String(data: data[8...11], encoding: .ascii) {
                    
                    let HEICBitMaps = Set(["heic", "heis", "heix", "hevc", "hevx"])
                    if HEICBitMaps.contains(str) {
                        
                        self = .HEIC
                        return
                    }
                    
                    let HEIFBitMaps = Set(["mif1", "msf1"])
                    if HEIFBitMaps.contains(str) {
                        
                        self = .HEIF
                        return
                    }
                }
                
            default: break;
            }
            
            self = .Unknow
        }
    }
    
}

extension Data {
    
    /// 图片文件格式
    var imageFormat: XYFileFormat.ImageFormat  {
        
        return XYFileFormat.ImageFormat(self)
    }
}
