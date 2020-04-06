//
//  XYDevice.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/29.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

//MARK: - XYDevice
public class XYDevice : NSObject {
    
    public class func ModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod_Touch_1"
        case "iPod2,1":  return "iPod_Touch_2"
        case "iPod3,1":  return "iPod_Touch_3"
        case "iPod4,1":  return "iPod_Touch_4"
        case "iPod5,1":  return "iPod_Touch_(5 Gen)"
        case "iPod7,1":   return "iPod_Touch_6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone_4"
        case "iPhone4,1":  return "iPhone_4s"
        case "iPhone5,1":   return "iPhone_5"
        case  "iPhone5,2":  return "iPhone_5_(GSM+CDMA)"
        case "iPhone5,3":  return "iPhone_5c_(GSM)"
        case "iPhone5,4":  return "iPhone_5c_(GSM+CDMA)"
        case "iPhone6,1":  return "iPhone_5s_(GSM)"
        case "iPhone6,2":  return "iPhone_5s_(GSM+CDMA)"
        case "iPhone7,2":  return "iPhone_6"
        case "iPhone7,1":  return "iPhone_6_Plus"
        case "iPhone8,1":  return "iPhone_6s"
        case "iPhone8,2":  return "iPhone_6s Plus"
        case "iPhone8,4":  return "iPhone_SE"
        case "iPhone9,1":  return "国行、日版、港行iPhone_7"
        case "iPhone9,2":  return "港行、国行iPhone_7_Plus"
        case "iPhone9,3":  return "美版、台版iPhone_7"
        case "iPhone9,4":  return "美版、台版iPhone_7_Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone_8"
        case "iPhone10,2","iPhone10,5":   return "iPhone_8_Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone_X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad_3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad_2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad_Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad_3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad_4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad_Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad_Mini_2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad_Mini_3"
        case "iPad5,1", "iPad5,2":  return "iPad_Mini_4"
        case "iPad5,3", "iPad5,4":   return "iPad_Air_2"
        case "iPad6,3", "iPad6,4":  return "iPad_Pro_9.7"
        case "iPad6,7", "iPad6,8":  return "iPad_Pro_12.9"
        case "AppleTV2,1":  return "Apple_TV_2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple_TV_3"
        case "AppleTV5,3":   return "Apple_TV_4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
    
    /**
     *    @description 获取当前设备信息
     *
     */
    fileprivate class func CurrentDevice() -> UIDevice {
        
        let device = UIDevice.current
        
        return device
    }
    
    /**
     *    @description 获取当前设备iOS版本
     *
     */
    public class func OSVersion() -> String {
        
        let osVersion = self.CurrentDevice().systemVersion
        
        return osVersion
    }
    
    /**
     *    @description 获取当前设备UUID
     *
     */
    public class func IdentifierNumber() -> String {
        
        var uuidString:String = ""
        if let identifierForVendor:UUID = self.CurrentDevice().identifierForVendor {
            
            uuidString = identifierForVendor.uuidString
        }
        
        return uuidString
    }
    
    /**
     *    @description 获取当前设备系统名称
     *
     */
    public class func SystemName() -> String {
        
        let systemName = self.CurrentDevice().systemName
        
        return systemName
    }
    
    /**
     *    @description 获取当前设备设备区域化型号如A1533
     *
     */
    public class func LocalizedModel() -> String {
        
        let localizedModel = self.CurrentDevice().localizedModel
        
        return localizedModel
    }
    
    /**
     *    @description 获取当前设备型号
     *
     */
    public class func ModelString() -> String {
        
        let modelName = self.CurrentDevice().model
        
        return modelName
    }
    
    public enum XYDeviceModel {
        case iPhone
        case iPad
    }
    
    public class func Model() -> XYDeviceModel{
        
        if self.ModelString().lowercased().contains("pad") {
            
            return XYDeviceModel.iPad
        }
        
        return XYDeviceModel.iPhone
    }
    
    /**
     *    @description 是否为模拟器
     *
     */
    public class func IsSimulator() -> Bool {
        
        var isSim = false
        #if (arch(i386) || arch(x86_64))
        isSim = true
        #endif
        return isSim
    }
    
    public static var IsPad: Bool {
        
        return self.Model() == .iPad
    }
}
