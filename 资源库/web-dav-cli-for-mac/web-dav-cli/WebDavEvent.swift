//
//  WebDavEvent.swift
//  web-dav-cli
//
//  Created by 葉冠暉 on 2021/2/15.
//  Copyright © 2021 葉冠暉. All rights reserved.
//

import Foundation
import FilesProvider

class WebDavEvent:FileProviderDelegate{
    private var webdav:WebDAVFileProvider
    private var rootPath:String=""
    
    func fileproviderFailed(_ fileProvider: FileProviderOperations, operation: FileOperationType, error: Error) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("copy of \(source) failed.")
        case .remove:
            print("file can't be deleted.")
        default:
            print("\(operation.actionDescription) from \(operation.source) to \(operation.destination) failed")
        }
        
    }
    
    func fileproviderSucceed(_ fileProvider: FileProviderOperations, operation: FileOperationType) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("\(source) copied to \(dest).")
        case .remove(path: let path):
            print("\(path) has been deleted.")
        default:
            print("\(operation.actionDescription) from \(operation.source) to \(operation.destination) succeed")
        }
    }
    
    func fileproviderProgress(_ fileProvider: FileProviderOperations, operation: FileOperationType, progress: Float) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("Copy\(source) to \(dest): \(progress * 100) completed.")
        default:
            break
        }
    }
    
    init(url:String,rootPath:String="/",user:String="",password:String=""){
        self.rootPath=rootPath
        do{
            let credential = URLCredential(user: user, password: password, persistence: .permanent)
            webdav = WebDAVFileProvider(baseURL: URL(string: url)!, credential: credential)!
            webdav.delegate=self as FileProviderDelegate
        }catch{
            
        }
        
        
    }
    
    func ls(path:String="/"){
        webdav.contentsOfDirectory(path: rootPath+path, completionHandler: {
            contents, error in
            for file in contents {
                print("Name: \(file.name)")
                print("Size: \(file.size)")
                print("Creation Date: \(file.creationDate)")
                print("Modification Date: \(file.modifiedDate)")
            }
        })
    }
    
    func createFolder(path:String="/") {
        webdav.create(folder: "new folder", at: rootPath+path, completionHandler: nil)
    }
    
    func getData(path:String) {
        webdav.contents(path: rootPath+path, completionHandler: {
            contents, error in
            if let contents = contents {
                print(String(data: contents, encoding: .utf8))
            }
        })
    }
    
    func remove(path:String) {
        webdav.removeItem(path: rootPath+path, completionHandler: nil)
    }
    
    func copy(path:String,to:String){
        webdav.copyItem(path: rootPath+path, to: rootPath+to, overwrite: true, completionHandler: nil)
    }
    
    func move(path:String,to:String){
        webdav.moveItem(path: rootPath+path, to: rootPath+to, overwrite: true, completionHandler: nil)
    }
    
    func download(path:String,localPath:String) {
        let localURL = URL(fileURLWithPath:localPath)
        let remotePath = rootPath+path
        
        let progress = webdav.copyItem(path: remotePath, toLocalURL: localURL, completionHandler: nil)
//        downloadProgressView.observedProgress = progress
    }
    
    func upload(path:String,localPath:String) {
        let localURL = URL(fileURLWithPath:localPath)
        let remotePath = rootPath+path
        
        let progress = webdav.copyItem(localFile: localURL, to: remotePath,overwrite: true, completionHandler: nil)
//        uploadProgressView.observedProgress = progress
    }
    
    
}
