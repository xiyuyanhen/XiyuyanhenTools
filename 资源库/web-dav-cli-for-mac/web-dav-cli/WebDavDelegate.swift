//
//  WebDavDelegate.swift
//  web-dav-cli
//
//  Created by 葉冠暉 on 2021/2/14.
//  Copyright © 2021 葉冠暉. All rights reserved.
//

import Foundation
import FilesProvider

class WebDavDelegate:FileProviderDelegate{
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
}
