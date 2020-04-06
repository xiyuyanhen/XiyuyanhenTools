//
//  XYPrivacyManager.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/6/7.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

struct XYPrivacyManager {
    
    enum AuthorizationStatus {
        case 未询问
        case 拒绝
        case 授权
    }
    
    /**
     *    @description 用户是否授予录音权限
     *
     */
    static func CurrentPrivacyAudioRecordStatus() -> XYPrivacyManager.AuthorizationStatus {
        
//        return .授权
        
        // MARK: - 检查麦克风权限
        if #available(iOS 11.0, *) {
            
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .notDetermined: //没有询问是否开启麦克风
                
                return .未询问
                
            case .restricted, //未授权，家长限制
            .denied: //用户拒绝授权
                
                return .拒绝
                
            case .authorized: //用户已经授权
                
                return .授权
                
            @unknown default: fatalError()
            }
            
        }else {
            
            switch AVAudioSession.sharedInstance().recordPermission {
                
            case .undetermined: return .未询问
            case .denied: return .拒绝
            case .granted: return .授权
            @unknown default: fatalError()
            }
        }
    }
    
    /**
     *    @description 用户是否授予录音权限
     *
     */
    static func RequestPrivacyAudioRecordBySystem(completionHandler handler: @escaping (Bool) -> Void) {
        
        if #available(iOS 11.0, *) {
            
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: handler)
        }else {
            
            AVAudioSession.sharedInstance().requestRecordPermission(handler)
        }
    }
    
    /**
     *    @description 用户是否授予录音权限
     *
     */
    static func RequestPrivacyAudioRecordAlert() {
        
        ShowSingleBtnAlertView(title: "未授予必需的权限", message: "语音评测需要录音，请在iPhone的\"设置-隐私-麦克风\"选项中，允许\(APP_CurrentTarget.appName)访问你的手机麦克风。", comfirmTitle: "好", comfirmBtnBlock: { (comfirmAction) in
            
//            XYApplicationUrl.应用设置.openByShareApplication(completionHandler: { (isSuccess) in
//
//                guard isSuccess == false else { return }
//
//                XYApplicationUrl.应用设置.cannotOpenAlert()
//            })
        })
    }
    
    /**
     *    @description 检查是否已经赋予录音权限
     *
     *    若没有，触发权限请求或提醒
     *
     *    @return   Bool
     */
    static func CheckPrivacyAudioRecord() -> Bool {
        
        let status = self.CurrentPrivacyAudioRecordStatus()
        
        guard status == .授权 else {
            
            if status == .未询问 {
                
                //检查当前设备录音权限
                XYPrivacyManager.RequestPrivacyAudioRecordBySystem { (isAllow) in
                    
                    guard isAllow == false else {
                        
                        XYLog.LogNoteBlock { () -> String? in
            
                            return "用户已授权录音权限"
                        }
                        
                        return
                    }
                    
                    XYLog.Log(msg: "用户拒绝授权录音权限", type: .Error)
                }
                
            }else {
                
                XYPrivacyManager.RequestPrivacyAudioRecordAlert()
            }
            
            return false
        }
        
        return true
    }
}

/*  私有API，无法通过审核
enum XYApplicationUrl : String, XYEnumTypeAllCaseProtocol {
    
    case 应用设置 = "AppSetting"
    case 通用设置 = "General"
    case Wifi设置 = "WIFI"
    
    var urlString : String {
        
        guard self != .应用设置 else { return UIApplication.openSettingsURLString }
        
        if #available(iOS 10, *) {
            
            return "App-Prefs=\(self.rawValue)"
        }else {
            
            return "prefs:root=\(self.rawValue)"
        }
    }
    
    var urlOrNil : URL? {
        
        guard let url = URL(string: self.urlString) else { return nil }
        
        return url
    }
    
    func openByShareApplication(completionHandler completion: @escaping ((Bool) -> Void)) {
        
        guard let url = self.urlOrNil else {
            
            completion(false)
            return
        }
        
        if #available(iOS 10, *) {
            
            AppDelegate.ShareApplication.open(url, options: [:]) { (isSuccess) in
                
                completion(isSuccess)
            }
            
            return
            
        }else {
            
            if AppDelegate.ShareApplication.openURL(url) {
                
                completion(true)
                return
            }
        }
        
        completion(false)
    }
    
    func cannotOpenAlert() {
        
        ShowSingleBtnAlertView(title: "跳转失败", message: "由于未知原因，无法直接跳转至\"\(self.name)\"，请自行前往该页面")
    }
}
*/
