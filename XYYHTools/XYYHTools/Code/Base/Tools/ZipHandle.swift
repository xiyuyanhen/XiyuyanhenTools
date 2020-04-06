//
//  ZipHandle.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/6/12.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
/*
typealias ZipArchiveProcessBlock = (_ processPercentage:UInt) -> Void
typealias ZipArchiveCompletionBlock = (_ filePath:String, _ error:Error?) -> Void


func UnZipFile(zipPath:String, destinationPath:String, completion:@escaping ZipArchiveCompletionBlock, process:ZipArchiveProcessBlock?) {
        
    //异步运行
    let unZipQueue = DispatchQueue(label: "EStudy.ZipHandle.UnZipFile")
    unZipQueue.async {
        
        SSZipArchive.unzipFile(atPath: zipPath, toDestination: destinationPath, progressHandler: { (entry:String, fileInfo:unz_file_info, entryNumber:Int, total:Int) in
            
            let completedCount = Double(entryNumber)
            let totalCount = Double(total)
            let completeRate = completedCount/totalCount
            let completePercentage = UInt(completeRate*100)

            
            process == nil ? nil : process!(completePercentage)

            
        }, completionHandler: { (path:String, succeeded:Bool, error:Error?) in
            


            
//            let destinationUrl:URL? = succeeded ? URL(fileURLWithPath: destinationPath) : nil
            completion(destinationPath, error)
            
        })
        
    }
}

func CreateZipFile(contentsOfDirectoryPath:String, destinationPath:String,
                   completion: @escaping CompletionElementBlockHandler<String>,
                   processBlockOrNil: CompletionElementBlockHandler<Float>? = nil) {
    
    //异步运行
    let unZipQueue = DispatchQueue(label: "EStudy.ZipHandle.CreateZipFile")
    unZipQueue.async {
        
        //该方法只能压缩文件夹
        //keepParentDirectory表示是否将最外层的文件夹也导入进去
        SSZipArchive.createZipFile(atPath: destinationPath, withContentsOfDirectory: contentsOfDirectoryPath, keepParentDirectory: true, compressionLevel: 1, password: nil, aes: false, progressHandler: { (entryNumber:UInt, total:UInt) in
            
            let completeRate: Float = Float(entryNumber)/Float(total)

            processBlockOrNil?(completeRate)
            
            guard 1.0 <= completeRate else { return }
        
            completion(destinationPath)
        })
        
    }
}
*/
