//
//  XYApplication.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/8/2.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/// 自定义UIApplication子类
class XYApplication: UIApplication {
    
    static func Share() -> XYApplication {
        
        return UIApplication.shared as! XYApplication
    }
    
    override init() {
        
        super.init()
        
        // 中断处理
        NotificationCenter.default.addObserver(self, selector: #selector(self.sessionInterruptionNotificationHandle(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sessionInterruptionNotificationHandle(notification:)), name: AVAudioSession.silenceSecondaryAudioHintNotification, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.silenceSecondaryAudioHintNotification, object: nil)
    }
    
//    override func sendEvent(_ event: UIEvent) {
//        super.sendEvent(event)
//
//        XYLog.LogNoteBlock { () -> String? in
//
//            return "sendEvent: \(event)"
//        }
//    }
    
    override var applicationState: UIApplication.State {
        
        /* 此方法应付报错:
         按Home键将应用进入后台运行 报UI API called on a background thread: 错误
         https://github.com/aliyun/alicloud-ios-demo/issues/244
        */
        
        guard Thread.isMainThread else { return UIApplication.State.inactive }
        
        return super.applicationState
    }
    
    /// 应用状态变化信号
    lazy var rxApplicationState: PublishSubject<XYApplicationState> = {
        
        return PublishSubject<XYApplicationState>()
    }()
    
    override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    /// 远程控制响应
    lazy var rxRemoteEventSubtype: PublishSubject<UIEvent.EventSubtype> = {
        
        return PublishSubject<UIEvent.EventSubtype>()
    }()
    
    // MARK: - Remote Controls

    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        guard let event = event, event.type == .remoteControl else { return }
        
        self.rxRemoteEventSubtype.onNext(event.subtype)
    }
    
    /// 共享数据
    lazy var dataShare: XYAppDataShare = {

        return XYAppDataShare()
    }()
}

extension XYApplication {
    
    @objc func sessionInterruptionNotificationHandle(notification: Notification) {
        
        /* 音频中断处理
        其他App或者电话会中断我们的APP音频，我们可以通过监听AVAudioSessionInterruptionNotification和AVAudioSessionSilenceSecondaryAudioHintNotification两个key来获取音频终端电话
        */
        
        if notification.name == AVAudioSession.interruptionNotification {
            
            /*
             AVAudioSessionInterruptionNotification监听电话、闹铃等一般性的中断
             回调回来Userinfo有两个键值
             AVAudioSessionInterruptionTypeKey：
             取值AVAudioSessionInterruptionTypeBegan表示中断开始
             取值AVAudioSessionInterruptionTypeEnded表示中断结束
             AVAudioSessionInterruptionOptionKey：
             取值AVAudioSessionInterruptionOptionShouldResume表示可以恢复播放
             */
            
            if let userInfo = notification.userInfo {
                
                var detailMsg: String = ""
                
                if let typeUInt: UInt = userInfo.xyObject(AVAudioSessionInterruptionTypeKey),
                    let type = AVAudioSession.InterruptionType(rawValue: typeUInt) {

                    switch type {
                    case .began: // 中断开始
                        
                        if #available(iOS 10.3, *),
                            let wasSuspended: Bool = userInfo.xyObject(AVAudioSessionInterruptionWasSuspendedKey) {
                            
                            if wasSuspended {
                                
                                XYDispatchQueueType.Main.xyAsync {
                                    self.rxRemoteEventSubtype.onNext(UIEvent.EventSubtype.remoteControlPlay)
                                }
                                
                            }else {
                                
                                XYDispatchQueueType.Main.xyAsync {
                                    self.rxRemoteEventSubtype.onNext(UIEvent.EventSubtype.remoteControlPause)
                                }
                            }
                            
                            detailMsg = "\nInterruptionType: Began\nwasSuspended: \(wasSuspended)"
                            
                        } else {
                            
                            XYDispatchQueueType.Main.xyAsync {
                                self.rxRemoteEventSubtype.onNext(UIEvent.EventSubtype.remoteControlPause)
                            }
                            
                            detailMsg = "\nInterruptionType: Began"
                        }
            
                        /*
                         
                         接收到播放中断通知 AVAudioSession.interruptionNotification (userInfo: {
                           "AVAudioSessionInterruptionTypeKey" : 1,
                           "AVAudioSessionInterruptionWasSuspendedKey" : true
                         })
                         InterruptionType: Began
                         */
                        
                        break
                        
                    case .ended: // 中断结束
                        
                        if let optionsUInt: UInt = userInfo.xyObject(AVAudioSessionInterruptionOptionKey) {
                            let options = AVAudioSession.InterruptionOptions(rawValue: optionsUInt)

                            /*
                             
                             从iOS 10开始，系统会在挂起应用程序进程时停用其音频会话。 当应用再次开始运行时，它将收到系统已停用其音频会话的中断通知。 由于系统只能在应用再次运行后才能传递此通知，因此通知时间一定会延迟。 如果系统由于这个原因暂停了您应用的音频会话，则用户信息字典将包含AVAudioSessionInterruptionWasSuspendedKey密钥，其值为true。

                             如果您将音频会话配置为不可混合（播放，playAndRecord，soloAmbient和multiRoute类别的默认行为），请在进入后台时未主动使用音频的情况下停用音频会话。 这样做可以避免您的音频会话被系统停用（并收到此令人困惑的通知）。
                             */
                            
                            if options.contains(AVAudioSession.InterruptionOptions.shouldResume) {
                                // 应该恢复播放
                                
                                XYDispatchQueueType.Main.xyAsync {
                                    self.rxRemoteEventSubtype.onNext(UIEvent.EventSubtype.remoteControlPlay)
                                }
                                
                                detailMsg = "\nInterruptionType: Ended\nOptions: shouldResume"
                                
                            }else {
                                
                                detailMsg = "\nInterruptionType: Ended"
                            }
                        }
                        
                        break
                    @unknown default:
                        break
                    }
                }
                
                XYLog.LogWarnning(msg: "接收到播放中断通知 AVAudioSession.interruptionNotification (userInfo: \(userInfo.jsonDescription()))\(detailMsg)", mark: "应用中断通知")
                
            }else {
                
                XYLog.LogWarnning(msg: "接收到播放中断通知 AVAudioSession.interruptionNotification", mark: "应用中断通知")
            }
            
        }else if notification.name == AVAudioSession.silenceSecondaryAudioHintNotification {
            
            /* 其他应用开始占据session
             AVAudioSessionSilenceSecondaryAudioHintNotification监听其他APP占据AudioSession，回调回来Userinfo有一个键值
             AVAudioSessionSilenceSecondaryAudioHintTypeKey：
             取值AVAudioSessionSilenceSecondaryAudioHintTypeBegin表示中断开始
             取值AVAudioSessionSilenceSecondaryAudioHintTypeEnd表示中断结束
             中断开始：我们需要做的是保存好播放状态，上下文，更新用户界面等
             中断结束：我们要做的是恢复好状态和上下文，更新用户界面，根据需求准备好之后选择是否激活我们session。
             */
            
            if let userInfo = notification.userInfo {
                
                var detailMsg: String = ""
                
                if let typeUInt: UInt = userInfo.xyObject(AVAudioSessionSilenceSecondaryAudioHintTypeKey),
                    let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: typeUInt) {

                    switch type {
                    case .begin: // 中断开始
                        
                        XYDispatchQueueType.Main.xyAsync {
                            self.rxRemoteEventSubtype.onNext(UIEvent.EventSubtype.remoteControlPause)
                        }
                        
                        detailMsg = "\nHintType: Begin"
                        
                        break
                    case .end: // 中断结束
                        
                        XYDispatchQueueType.Main.xyAsync {
                            self.rxRemoteEventSubtype.onNext(UIEvent.EventSubtype.remoteControlPlay)
                        }
                        
                        detailMsg = "\nHintType: End"
                        
                        break
                    @unknown default:
                        break
                    }
                }
                
                XYLog.LogWarnning(msg: "接收到播放中断通知 AVAudioSession.silenceSecondaryAudioHintNotification (userInfo: \(userInfo.jsonDescription()))\(detailMsg)", mark: "应用中断通知")
                
            }else {
                
                XYLog.LogWarnning(msg: "接收到播放中断通知 AVAudioSession.silenceSecondaryAudioHintNotification", mark: "应用中断通知")
            }
        }
        
    }
    
}

// MARK: - <#注释#>
extension XYApplication {
    
    /// 应用状态
    enum XYApplicationState {
        
        /// 完成加载
        case DidFinishLaunching(application: XYApplication, launchOptionsOrNil: [UIApplication.LaunchOptionsKey: Any]?)
        
        /// 即将退出
        case WillResignActive(application: XYApplication)
        
        /// 已经进入后台
        case DidEnterBackground(application: XYApplication)
        
        /// 即将返回前台
        case WillEnterForeground(application: XYApplication)
        
        /// 已经进入活跃状态
        case DidBecomeActive(application: XYApplication)
        
        /// 即将中止
        case WillTerminate(application: XYApplication)
        
        /// 状态名称
        var name: String {
            switch self {
            case .DidFinishLaunching(_, _): return "DidFinishLaunching"
            case .WillResignActive(_): return "WillResignActive"
            case .DidEnterBackground(_): return "DidEnterBackground"
            case .WillEnterForeground(_): return "WillEnterForeground"
            case .DidBecomeActive(_): return "DidBecomeActive"
            case .WillTerminate(_): return "WillTerminate"
            }
        }
        
        /// 状态标识
        var stateFlag: Int {
            switch self {
            case .DidFinishLaunching(_, _): return 10
            case .WillResignActive(_): return 20
            case .DidEnterBackground(_): return 30
            case .WillEnterForeground(_): return 40
            case .DidBecomeActive(_): return 50
            case .WillTerminate(_): return 60
            }
        }
        
        /// 是否处理活跃状态
        var isActive: Bool {
            
            switch self {
            case .DidFinishLaunching(_, _), .DidBecomeActive(_):
                return true
                
            default: return false
            }
        }
    }
    
    
}
