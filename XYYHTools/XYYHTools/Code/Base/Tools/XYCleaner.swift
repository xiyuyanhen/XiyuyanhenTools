//
//  XYCleaner.swift
//  FangKeBang
//
//  Created by DragonPass on 2018/6/13.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class XYCleaner : NSObject {
    
    //单例
    //    static let `default` = XYCleaner();
    //
    //    class func Share() -> XYCleaner{
    //
    //        let cleaner:XYCleaner = self.default
    //
    //        return cleaner;
    //    }
    //
    //    override private init() {
    //
    //        super.init();
    //    }
    
    /**
     *  计算文件大小
     */
    static func FileSize(filePath: String) -> UInt64 {
        
        guard XYFileManager.FileExists(filePath: filePath),
            let attibutes = try? XYFileManager.fileManager.attributesOfItem(atPath: filePath),
            let sizeInt64 = attibutes[FileAttributeKey.size] as? UInt64 else { return 0 }
        
        return sizeInt64
    }
    
    /**
     *  计算整个目录大小
     *
     *  返回单位:M
     */
    static func FolderSizeAtPath(folderPath pathOrNil:String?) -> Float {
        
        
        guard let path = pathOrNil,
            XYFileManager.FileExists(filePath: path) else  {
                
                return 0
        }
        
        guard let subPaths = XYFileManager.fileManager.subpaths(atPath: path) else { return 0 }
        
        var folderSize: UInt64 = 0
        
        for fileName in subPaths {
            
            let filePath = "\(path)/\(fileName)"
            let fileSize = self.FileSize(filePath: filePath)
            
            
            
            folderSize += fileSize
        }
        
        return Float(folderSize)/Float(1024 * 1024)
    }
    
    typealias CleanCacheBlock = () -> Void
    /**
     *  清理缓存
     */
    static func CleanCache(clearPaths:[ClearPath] ,_ completionBlockOrNil: CleanCacheBlock?) {
        
        //异步运行
        let unZipQueue = DispatchQueue(label: "EStudy.XYCleaner.cleanCache")
        unZipQueue.async{
            
            let manager = FileManager.default
            
            for clearPath in clearPaths {
                
                //文件路径
                let removePath = clearPath.path
                
                if clearPath.isDirectory,
                    let subPaths = try? manager.contentsOfDirectory(atPath: removePath) {
                    
                    for subPath in subPaths {
                        
                        let filePath = "\(removePath)/\(subPath)"
                        
                        try? manager.removeItem(atPath: filePath)
                    }
                    
                }else{
                    
                    let filePath = URL(fileURLWithPath: removePath).absoluteString
                    try? manager.removeItem(atPath: filePath)
                }
                
            }
            
            guard let completionBlock = completionBlockOrNil else { return }
            
            //返回主线程
            DispatchQueue.main.async(execute: {
                
                completionBlock()
            })
        }
        
    }
    
    struct ClearPath {
        
        var path:String
        var isDirectory:Bool
        
        init(path:String, isDirectory:Bool = false) {
            
            self.path = path
            self.isDirectory = isDirectory
        }
    }
}

extension XYCleaner {
    
    static let CachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    
    static var CacheSizeFloat : Float {
        
        return XYCleaner.FolderSizeAtPath(folderPath: XYCleaner.CachePath)
    }
    
    static var CacheSizeString : String {
        
        return String(format: "%.2f M", self.CacheSizeFloat)
    }
    
    static func NeedClearPath() -> [ClearPath] {
        
        var clearPaths = [ClearPath]()
        
        if let cPath = XYCleaner.CachePath {
            
            clearPaths.append(ClearPath(path: cPath, isDirectory: true))
        }
        
        return clearPaths
    }
    
    static func ClearCache(block bOrNil : CleanCacheBlock? = nil) {
        
        XYCleaner.CleanCache(clearPaths: XYCleaner.NeedClearPath(), bOrNil)
    }
}
