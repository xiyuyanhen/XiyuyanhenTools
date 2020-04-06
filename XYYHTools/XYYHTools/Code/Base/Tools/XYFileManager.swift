//
//  XYFileManager.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/10/16.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

class XYFileManager: XYObject {
    
    static let fileManager = FileManager.default
    
    override init() {
        
        super.init()
    }
    
    /**
     *    @description 指定路径是否存
     *
     *    @param    filePath    文件路径
     *
     *    @return   文件是否存在
     */
    @discardableResult class func FileExists(fileUrl: URL) -> Bool {
        
        guard self.fileManager.fileExists(atPath: fileUrl.path, isDirectory: nil) else { return false }
        
        return true
    }
    
    /**
     *    @description 指定路径是否存
     *
     *    @param    filePath    文件路径
     *
     *    @return   文件是否存在
     */
    @discardableResult class func FileExists(filePath: String) -> Bool {
        
        guard self.fileManager.fileExists(atPath: filePath, isDirectory: nil) else { return false }
        
        return true
    }
    
    /**
     *    @description 指定路径是否存在且为目录
     *
     *    @param    filePath    文件路径
     *
     *    @return   文件是否存在且为目录
     */
    @discardableResult class func FileExistsAndisDirectory(filePath: String) -> Bool {
        
        var isDir: ObjCBool = ObjCBool(false)
        
        guard self.fileManager.fileExists(atPath: filePath, isDirectory: &isDir) else { return false }
        
        guard isDir.boolValue == true else { return false }
        
        return true
    }
    
    /**
     *    @description 清理指定路径的文件
     *
     *    @param    filePath    文件路径
     *
     *    @return   文件是否已经成功删除
     */
    @discardableResult class func RemoveItem(filePath: String) -> Bool {
        
        guard self.FileExists(filePath: filePath) else { return true }
        
        do {
            
            try self.fileManager.removeItem(atPath: filePath)
            
        } catch {
            
            return false
        }
        
        return true
    }
    
    /**
     *    @description 移动文件至另一个目录
     *
     *    @param    filePath    将要移动文件
     *
     *    @param    toPath    移动至路径
     *
     *    @return   是否成功移动文件
     */
    @discardableResult class func MoveItem(filePath: String, toPath: String) -> Bool {
        
        self.RemoveItem(filePath: toPath) // 删除可能已经存在的文件
        
        do {
            
            try self.fileManager.moveItem(atPath: filePath, toPath: toPath)
            
        } catch {
            
            return false
        }
        
        return true
    }
    
    /**
     *    @description 复制文件至另一个目录
     *
     *    @param    filePath    将要复制文件
     *
     *    @param    toPath    移动至路径
     *
     *    @return   是否成功复制文件
     */
    @discardableResult class func CopyItem(filePath: String, toPath: String) -> Bool {
        
        self.RemoveItem(filePath: toPath) // 删除可能已经存在的文件
        
        do {
            
            try self.fileManager.copyItem(atPath: filePath, toPath: toPath)
            
        } catch {
            
            return false
        }
        
        return true
    }
    
    
}

// MARK: - Create File

extension XYFileManager {
    
    /**
     *    @description 创建指定路径文件夹
     *
     *    @param    path    文件夹路径
     *
     *    @return   指定路径文件夹是否存在
     */
    @discardableResult class func CreateDirectory(path: String, withIntermediateDirectories createIntermediates: Bool = true) -> Bool {
        
        guard self.FileExists(filePath: path) == false else { return true }
        
        do {
            
            try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: createIntermediates, attributes: nil)
            
        } catch {
            
            return false
        }
        
        return true
    }
    
    @discardableResult class func CreateFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        
        //删除可能已经存在的文件
        self.RemoveItem(filePath: path)
        
        //创建文件
        let result : Bool = self.fileManager.createFile(atPath: path, contents: data, attributes: attr)
        
        return result
    }
    
}
