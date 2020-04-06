//
//  XYBundle.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/9/6.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

struct XYBundle {
    
    static var Main : Bundle { return Bundle.main }
}

extension XYBundle {
    
    typealias FilePath = String
    
    static func FilePathByMain(name: String?, fileType: String?) -> FilePath? {
        
        guard let path = self.Main.path(forResource: name, ofType: fileType) else { return nil }
        
        return path
    }
    
    typealias FileUrl = URL
    
    static func FileUrlByMain(name: String?, fileType: String?) -> FileUrl? {
        
        guard let url = self.Main.url(forResource: name, withExtension: fileType) else { return nil }
    
        return url
    }
}

extension XYBundle {
    
    static func FilePathOfMP3ByMain(name: String?, fileType: String = "mp3") -> FilePath? {
        
        guard let path = self.FilePathByMain(name: name, fileType: fileType) else { return nil }
        
        return path
    }
    
    static func ReavelItem_Audio(name: String?, fileType: String = "mp3") -> XYRIAudio? {
        
        guard let path = XYBundle.FilePathOfMP3ByMain(name: name, fileType: fileType),
            let item = XYRIAudio(path: path) else { return nil }
        
        return item
    }
    
    static func FileURLOfGifByMain(name: String?, fileType: String = "gif") -> FileUrl? {
        
        guard let url = self.FileUrlByMain(name: name, fileType: fileType) else { return nil }
        
        return url
    }
}

extension XYBundle {
    
    static func JsonDataByMain(name: String?, fileType: String = "json") -> Data? {
        
        guard let path = self.FilePathByMain(name: name, fileType: fileType),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        
        return data
    }
    
    static func JsonDataByURL(fileUrl fileUrlOrNil: URL?) -> Data? {
        
        guard let fileUrl = fileUrlOrNil,
            let data = try? Data(contentsOf: fileUrl) else { return nil }
        
        return data
    }
    
    static func ElementOfJsonByMain<E: XYDataListExtension>(name: String?, elementType: E.Type, fileType: String = "json") -> E? {
        
        guard let data = self.JsonDataByMain(name: name, fileType: fileType),
            let element = elementType.CreateWith(jsondata: data) else { return nil }
        
        return element
    }
    
}

extension XYBundle {
    
    static func NibFilePath(name: String) -> String {
        
        return "\(Bundle.main.bundlePath)/\(name).nib"
    }
    
    static func NibFileIsExist(name: String) -> Bool {
    
        return XYFileManager.FileExists(filePath: self.NibFilePath(name: name))
    }
}

extension XYBundle {
    
    static func StoryboardFilePath(name: String) -> String {
        
        return "\(Bundle.main.bundlePath)/\(name).storyboardc"
    }
    
    static func StoryboardFileIsExist(name: String) -> Bool {
    
        return XYFileManager.FileExists(filePath: self.StoryboardFilePath(name: name))
    }
}
