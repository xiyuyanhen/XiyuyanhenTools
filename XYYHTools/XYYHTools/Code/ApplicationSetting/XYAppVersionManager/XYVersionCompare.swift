//
//  XYVersionCompare.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/13.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

extension String {
    
    //    func xyVersionCompareTest() {
    //
    //        //快速验证方法
    //
    //        let otherVersions = ["2.0.1.51", "2.0.2.0", "1.0", "5", "2.0.2.0.1"]
    //
    //        for oVersion in otherVersions {
    //
    //            let result = self.xyVersionCompare(with: oVersion)
    //
    //            var resultStr = "unknow"
    //            if result == .orderedAscending {
    //
    //                resultStr = "<"
    //            }else if result == .orderedSame {
    //
    //                resultStr = "="
    //            }else if result == .orderedDescending {
    //
    //                resultStr = ">"
    //            }
    //
    
    //        }
    //    }
    
    func xyVersionCompare(with otherVersion: String) -> ComparisonResult {
        
        var version = self
        var compareVersion = otherVersion
        
        let versionSubArr = version.components(separatedBy: ".")
        let compareVersionSubArr = compareVersion.components(separatedBy: ".")
        
        //绝对值
        var absCount : Int = abs(versionSubArr.count - compareVersionSubArr.count)
        
        if 0 < absCount {
            /* 若位数不一致，需在末尾添加.0至位数一致再比较
             *   否则会出现如此错误结果：2.0.2 < 2.0.2.0
             *
             */
            
            let maxCount : Int = (versionSubArr.count < compareVersionSubArr.count) ? compareVersionSubArr.count : versionSubArr.count
            
            if versionSubArr.count < maxCount {
                
                while 0 < absCount {
                    
                    version = "\(version).0"
                    
                    absCount -= 1
                }
            }else {
                
                while 0 < absCount {
                    
                    compareVersion = "\(compareVersion).0"
                    
                    absCount -= 1
                }
            }
        }
        
        return version.compare(compareVersion, options: .numeric, range: nil, locale: nil)
    }
    
    func xyVersionIsNewer(than aVersionString: String) -> Bool {
        
        return self.xyVersionCompare(with: aVersionString) == .orderedDescending
    }
    
    func xyVersionIsOlder(than aVersionString: String) -> Bool {
        
        return self.xyVersionCompare(with: aVersionString) == .orderedAscending
    }
    
    func xyVersionIsSame(to aVersionString: String) -> Bool {
        
        return self.xyVersionCompare(with: aVersionString) == .orderedSame
    }
}
