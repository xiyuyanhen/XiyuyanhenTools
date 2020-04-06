//
//  XYNetWorkManage.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/5/25.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
import Alamofire

// app接口签名密码：_Sts100#@

class XYNetWorkManage : NSObject {
    
    //单例
    static let `default` = XYNetWorkManage();
    
    class func ShareManage() -> XYNetWorkManage{
        
        let networkManage = self.default;
        
        return networkManage;
    }
    
    static let NetWorkSign = "_Sts100#@"
    
    // MARK: - Request SessionManager
    lazy var sessionManager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        
        let sm = SessionManager(configuration: configuration)
        
        return sm
    }()
    
    // MARK: - Download SessionManager
    
    static let downloadBackgroundIdentifier = "EStudy.XYNetWorkManage.background.downloadFile"
    
    lazy var downloadConfiguration:URLSessionConfiguration = {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: XYNetWorkManage.downloadBackgroundIdentifier)
        
        return configuration
    }()
    
    lazy var downloadManager : SessionManager = {
        
        let configuration = self.downloadConfiguration
        
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let downloadSessionManager = SessionManager(configuration: configuration)
        
        downloadSessionManager.delegate.sessionDidReceiveChallenge = { session, challenge in
            
            return (URLSession.AuthChallengeDisposition.useCredential,
                    URLCredential(trust: challenge.protectionSpace.serverTrust!))
            /*
             //认证服务器证书
             if challenge.protectionSpace.authenticationMethod
             == NSURLAuthenticationMethodServerTrust {
             print("服务端证书认证！")
             let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
             let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
             let remoteCertificateData
             = CFBridgingRetain(SecCertificateCopyData(certificate))!
             let cerPath = Bundle.main.path(forResource: "tomcat", ofType: "cer")!
             let cerUrl = URL(fileURLWithPath:cerPath)
             let localCertificateData = try! Data(contentsOf: cerUrl)
             
             if (remoteCertificateData.isEqual(localCertificateData) == true) {
             
             let credential = URLCredential(trust: serverTrust)
             challenge.sender?.use(credential, for: challenge)
             return (URLSession.AuthChallengeDisposition.useCredential,
             URLCredential(trust: challenge.protectionSpace.serverTrust!))
             
             } else {
             return (.cancelAuthenticationChallenge, nil)
             }
             }
             //认证客户端证书
             else if challenge.protectionSpace.authenticationMethod
             == NSURLAuthenticationMethodClientCertificate {
             print("客户端证书认证！")
             //获取客户端证书相关信息
             let identityAndTrust:IdentityAndTrust = self.extractIdentity();
             
             let urlCredential:URLCredential = URLCredential(
             identity: identityAndTrust.identityRef,
             certificates: identityAndTrust.certArray as? [AnyObject],
             persistence: URLCredential.Persistence.forSession);
             
             return (.useCredential, urlCredential);
             }
             // 其它情况（不接受认证）
             else {
             print("其它情况（不接受认证）")
             return (.cancelAuthenticationChallenge, nil)
             }
             */
        }
        
        return downloadSessionManager
    }()
    
//    lazy var downloadTaskDelegate: DownloadTaskDelegate = {
//
//        let taskDelegate:DownloadTaskDelegate = DownloadTaskDelegate(task: nil)
//
//        return taskDelegate
//    }()
    
    
    // MARK: - Parameters参数相关
    typealias XYParameters = [String:String]
    
    /**
     *    @description 校验参数
     *
     */
    fileprivate static func CheckParaters(url: String, originalParameters: XYParameters) -> XYParameters {
        
        var parameters = XYParameters()
        
        for key in originalParameters.keys {
            
            guard let valueString = originalParameters[key] else {
                
                XYLog.Log(msg: "网络请求(\(url)): 参数值(key = \(key))不为String类型！", type: .Error)
                continue
            }
            
            let newKey = key.trimmingWhiteSpace()
            let newValue = valueString.trimmingWhiteSpace()
            
            guard (newKey.count > 0) else {
                
                XYLog.Log(msg: "网络请求(\(url)): 参数Key长度为0！", type: .Error)
                continue
            }
            
            guard (newKey != " ") && (newValue != " ") else {
                
                XYLog.Log(msg: "网络请求(\(url)): 参数Key或者值为空格！", type: .Error)
                continue
            }
            
            parameters[newKey] = newValue
        }
        
        return parameters
    }
    
    /**
     *    @description Keys排序
     */
    fileprivate static func SortKeys(originalParameters:XYParameters) -> [String] {
        
        var keyArr:[String] = [String]()
        for key in originalParameters.keys {
            
            keyArr.append(key)
        }
        
        let sortedKeyArr = keyArr.sorted { (s0, s1) -> Bool in
            
            let result = ( s0 < s1)
            return result
        }
    
        return sortedKeyArr
    }
    
    // MARK: - 生成签名头
    /**
     *    @description 签名头
     *    "sign":"MD5(MD5(userId=1&groupId=1)+KEY)"
     */
    fileprivate static func SignHeader(originalParameters:XYParameters) -> HTTPHeaders {
        
        let keyArr = self.SortKeys(originalParameters: originalParameters)
    
        var headerInfo = ""
        for key in keyArr {
            
            guard let value = originalParameters[key] else { continue }
            
            let subInfo = "\(key)=\(value)"
            
            if headerInfo.count > 0 {
                
                headerInfo += "&"
            }
            
            headerInfo += subInfo
        }
        
        let headerInfoMd5 = headerInfo.MD5String()
        let headerInfoMd5Sign = headerInfoMd5 + XYNetWorkManage.NetWorkSign
        let headerInfoMd5SignMd5 = headerInfoMd5Sign.MD5String()
        

        
        let signHeader:HTTPHeaders = ["sign":headerInfoMd5SignMd5]
        
        return signHeader
    }
    
    override private init() {
        
        super.init();
    }
    
    fileprivate func requestCacheKey(url: URLConvertible, parameters: Parameters) -> String? {
        
        guard let urlString = (url as? String) else {
            return nil
        }
        
        var cacheKey = urlString+"?"
        
        for key in parameters.keys {
            
            let value = (parameters[key] as? String) ?? ""
            
            let part = "\(key)=\(value)&"
            
            cacheKey = cacheKey.appending(part)
        }
        
        cacheKey = cacheKey.MD5String()
        
        return cacheKey
    }
}

extension XYNetWorkManage {
    
    typealias RequestDicData = Dictionary<String, Any>
        
    typealias RequestCompletionHandler = (_ requestState:XYRequestState) -> Void
    
    /// 数据接口请求状态
    enum XYRequestState: XYEnumTypeProtocol {
        
        /// 就绪
        case Delay
        
        /// 请求中
        case Requsting
        
        /// 请求完成
        case Complete(XYRequestCompleteState)
        
        /// 请求报错
        case Error(XYError)
        
        /// 请求取消
        case Canceled
    }
    
    /// 与后台协定好的接口状态
    enum XYRequestCompleteState: XYEnumTypeProtocol {
        
        /// 未知
        case Data(Data)
        /// 失败 "00"
        case Failure(RequestDicData)
        /// 成功 "11"
        case Success(RequestDicData)
        /// 需要重新登录 "22"
        case NeedLogin(RequestDicData)
        
        static let TypeCode_Data: String = "Data"
        static let TypeCode_Failure: String = "00"
        static let TypeCode_Success: String = "11"
        static let TypeCode_NeedLogin: String = "22"
        
        /// 类型码
        fileprivate var typeCode: String {
            switch self {
            case .Data(_): return XYRequestCompleteState.TypeCode_Data
            case .Failure(_): return XYRequestCompleteState.TypeCode_Failure
            case .Success(_): return XYRequestCompleteState.TypeCode_Success
            case .NeedLogin(_): return XYRequestCompleteState.TypeCode_NeedLogin
            }
        }
        
        fileprivate static func StateByData(_ data: Data) -> XYRequestCompleteState {
            
            guard let dic = RequestDicData.CreateWith(jsondata: data),
                let stateText: String = dic.xyObject("state") else {
                
                return self.Data(data)
            }
            
            switch stateText {
                
            case XYRequestCompleteState.TypeCode_Failure: return self.Failure(dic)
                
            case XYRequestCompleteState.TypeCode_Success: return self.Success(dic)
                
            case XYRequestCompleteState.TypeCode_NeedLogin: return self.NeedLogin(dic)
                
            default: return self.Data(data)
            }
        }
        
        var dataMsg: String {
            
            switch self {
            
            case .Data(let data):
                
                let result : String
                if let dataText = String(data: data, encoding: .utf8),
                    dataText.isNotEmpty {

                    result = dataText

                }else{

                    result = String(describing: data)
                }
                
                return result
                
            case .Failure(let dataDic), .Success(let dataDic), .NeedLogin(let dataDic):
                
                return dataDic.jsonDescription()
            }
        }
    }
    
    // MARK: - GET请求
    /**
     *    @description GET请求
     *
     *    @param     url   请求Url
     *
     *    @param     parameters   请求参数字典
     *
     *    @param     progressHudView   请求时需要添加请求遮罩动画的View
     *
     *    @param     completionHandler   请求完成后的结果处理Block
     *
     */
    static func Get(_ requestConfig: RequestConfig, completionHandler: @escaping RequestCompletionHandler){
        
        self.PublicRequest(requestConfig, method: HTTPMethod.get, analysisCompleteState: true, completionHandler: completionHandler)
    }
    
    static func GetData(_ requestConfig: RequestConfig, completionDataHandle: @escaping RequestCompletionHandler){
        
        self.PublicRequest(requestConfig, method: HTTPMethod.get, analysisCompleteState: false, completionHandler: completionDataHandle)
    }
    
    // MARK: - POST请求
    /**
     *    @description POST请求
     *
     *    @param     url   请求Url
     *
     *    @param     parameters   请求参数字典
     *
     *    @param     progressHudView   请求时需要添加请求遮罩动画的View
     *
     *    @param     completionHandler   请求完成后的结果处理Block
     *
     */
    static func Post(_ requestConfig: RequestConfig, completionHandler: @escaping RequestCompletionHandler){
        
        self.PublicRequest(requestConfig, method: HTTPMethod.post, analysisCompleteState: true, completionHandler: completionHandler)
    }
    
    static func PostData(_ requestConfig: RequestConfig, completionDataHandle: @escaping RequestCompletionHandler){
        
        self.PublicRequest(requestConfig, method: HTTPMethod.post, analysisCompleteState: false, completionHandler: completionDataHandle)
    }
    
    /**
     *    @description POST/GET请求实际执行方法
     *
     *    @param     url   请求Url
     *
     *    @param     method   请求方法
     *
     *    @param     parameters   请求参数字典
     *
     *    @param     isCache   是否需要缓存
     *
     *    @param     progressHudView   请求时需要添加请求遮罩动画的View
     *
     *    @param     completionHandler   请求完成后的结果处理Block
     *
     */
    private static func PublicRequest(_ requestConfig: RequestConfig,
                                     method: HTTPMethod,
                                     analysisCompleteState: Bool,
                                     completionHandler: @escaping RequestCompletionHandler){
        
        self.RequestData(requestConfig, method: method) { (requestState) in
            
            
            switch requestState {
            case .Complete(var completeState):
                
                switch completeState {
                case .Data(let data):
                    
                    if analysisCompleteState {
                        // 需要对数据进一步解析
                        
                        completeState = XYRequestCompleteState.StateByData(data)
                        
                        if requestConfig.autoHandle {
                                    
                            switch completeState {
                            case .NeedLogin(let dataDic):
                                
                                break
                                
                            default: break
                            }
                        }
                    }
                    
                    requestConfig.requestLog.append("\n请求结果数据(在线):\(completeState.dataMsg)")
                    
                    completionHandler(.Complete(completeState))

                    return
                    
                default: break
                }
                
                break
    
            default: break
            }
            
            completionHandler(requestState)
        }
    }
    
    // MARK: - POST/GET请求实际执行方法
    /**
     *    @description POST/GET请求实际执行方法
     *
     *    @param     url   请求Url
     *
     *    @param     method   请求方法
     *
     *    @param     parameters   请求参数字典
     *
     *    @param     isCache   是否需要缓存
     *
     *    @param     progressHudView   请求时需要添加请求遮罩动画的View
     *
     *    @param     completionHandler   请求完成后的结果处理Block
     *
     */
    private static func RequestData(_ requestConfig: RequestConfig,
                                     method: HTTPMethod,
                                     completionDataHandle: @escaping RequestCompletionHandler){
        
//        guard ReachabilityManager.IsCanReachability() else {
//
//            ShowSingleBtnAlertView(title: "网络不可使用", message: "当前网络连接不可使用，请确定当前连接的网络是否正常，或者确定已经允许此App使用\"无线数据\"", showedVC: AlertShowedVC, comfirmBtnBlock: nil)
//
//            return
//        }
        
        var hudIdOrNil:XYProgressHudId? = nil
        if let progressHudView = requestConfig.progressHudViewOrNil {
            
            hudIdOrNil = XYProgressHudManager.AddProgressHud(toView: progressHudView)
        }
        
        var reQuestParameters = XYParameters()
        
        // 添加公共参数
        reQuestParameters["device"] = "iPhone"
        reQuestParameters["osVersion"] = XYDevice.OSVersion()
        reQuestParameters["brand"] = XYDevice.ModelName()
        reQuestParameters["appVersion"] = ProjectSetting.Share().currentAppVersionPair.appVersionForService
        
        //添加用户数据
//        if requestConfig.needUserMsg,
//            let userInfo = UserManage.UserInfoOrNil {
//            
//            reQuestParameters["teacherId"] = userInfo.userId
//            reQuestParameters["sessionId"] = userInfo.sessionId
//        }
        
        //添加原参
        if let para = requestConfig.parametersOrNil {
            
            for key in para.keys {
                
                let value = para[key]
                let newValue = value
                
                reQuestParameters[key] = newValue
            }
        }
        
        let checkedParaters = self.CheckParaters(url: requestConfig.requestUrl, originalParameters: reQuestParameters)
        
        let headers: HTTPHeaders = self.SignHeader(originalParameters: checkedParaters)
        
//        var cacheKeyOrNil:String? = nil
//        if requestConfig.needCache {
//
//            cacheKeyOrNil = self.default.requestCacheKey(url: requestConfig.requestUrl, parameters: checkedParaters)
//        }
        
        let dataRequest:DataRequest =  self.default.sessionManager.request(requestConfig.requestUrl, method: method, parameters: checkedParaters, encoding: URLEncoding.default, headers: headers)
        
        completionDataHandle(.Delay)
        
        /// 请求开始时间
        let requestStartDate : Date = Date()
        
        completionDataHandle(.Requsting)
        
        dataRequest.responseData(queue: nil) { (dataResponse) in
            
            defer {
                
                if let hudId = hudIdOrNil {
                    
                    XYProgressHudManager.RemoveProgressHUD(removeingHudId: hudId)
                }
            }
            
            requestConfig.requestLog = """
            ------------------------------------------
            请求Url:\(requestConfig.requestUrl)
            请求耗时:\(Date.TimeIntervalMilliSecond(otherDate: requestStartDate).xyDecimalLength(0))ms
            请求参数:\(checkedParaters.jsonDescription())
            """
            
            /// 数据返回状态码
            var statusCode: Int = NSURLErrorUnknown
            
            if let response = dataResponse.response {
                
                statusCode = response.statusCode
                requestConfig.requestLog.append("\n请求结果状态: \(response.statusCode)")
            }
            
            switch dataResponse.result {
            case .success(let data):
                
                switch statusCode {
                case 400, 401, 403, 404, 500, 502, 503:
                    
                    self.HandleErrorForRequested(error: XYError(code: statusCode, detailMsg: XYRequestCompleteState.Data(data).dataMsg), requestConfig: requestConfig, completionDataHandle: completionDataHandle)
                    
                    break
                    
                default:
                    completionDataHandle(.Complete(.Data(data)))
                    break
                }
                
                break
                
            case .failure(let error):
                
                self.HandleErrorForRequested(error: XYError(error: error), requestConfig: requestConfig, completionDataHandle: completionDataHandle)
                
                break
            }
            
            requestConfig.requestLog.append("\n------------------------------------------")
            
            XYLog.LogRequest(msg: requestConfig.requestLog, mark: "\(requestConfig.requestUrl)")
        }
    }
    
    /**
     *    @description 处理错误的结果请求结果
     *
     *    @param    error    错误
     *
     *    @param    requestConfig    请求参数
     *
     *    @param    completionDataHandle    完成处理Block
     *
     */
    fileprivate static func HandleErrorForRequested(error: XYError, requestConfig: RequestConfig, completionDataHandle: RequestCompletionHandler) {
        
        completionDataHandle(.Error(error))
        
        if error.code == NSURLErrorTimedOut {
            
            requestConfig.requestLog.append("\n请求结果状态: 请求超时")
        }else {
            
            requestConfig.requestLog.append("\n请求结果状态: Error(\(error.detailMsg)\n\(error.code))")
        }
        
        if requestConfig.autoHandle {
            
            ShowSingleBtnAlertView(title: "请求失败", message: "\(error.detailMsg)(\(error.code))", comfirmTitle: "好的", showedVC: AlertShowedVC, comfirmBtnBlock: nil)
        }
    }
    
    /**
     *    @description 处理错误的上传/下载请求结果
     *
     *    @param    error    错误
     *
     *    @param    requestConfig    请求参数
     *
     *    @param    completionHandle    完成处理Block
     *
     */
    fileprivate static func HandleErrorForUploadDownload(error: XYError, requestConfig: RequestConfig, completionHandle: UploadDownloadCompletionHandler) {
        
        completionHandle(.Error(error))
        
        if error.code == NSURLErrorTimedOut {
            
            requestConfig.requestLog.append("\n请求结果状态: 请求超时")
        }else {
            
            requestConfig.requestLog.append("\n请求结果状态: Error(\(error.detailMsg)\n\(error.code))")
        }
        
        if requestConfig.autoHandle {
            
            ShowSingleBtnAlertView(title: "操作失败", message: "\(error.detailMsg)(\(error.code))", comfirmTitle: "好的", showedVC: AlertShowedVC, comfirmBtnBlock: nil)
        }
    }
    
    
}

extension XYNetWorkManage {
    
    /// 数据接口请求状态
    enum XYUploadDownloadState: XYEnumTypeProtocol {
        
        /// 就绪
        case Delay
        
        /// 传输中
        case Progress(XYUploadDownloadProgress)
        
        /// 完成
        case Complete(XYRequestCompleteState)
        
        /// 报错
        case Error(XYError)
        
        /// 暂停
        case Suspend
        
        /// 取消
        case Canceled
    }
    
    struct XYUploadDownloadProgress {
        
        let completedCount: Double
        let totalCount: Double
        
        init(completed: Double, total: Double) {
            
            self.completedCount = completed
            self.totalCount = total
        }
        
        var completeRateDouble: Double {
            
            return self.completedCount/self.totalCount
        }
        
        var completeRateUInt: UInt {
            
            return UInt(self.completeRateDouble*100)
        }
    }
    
    typealias UploadDownloadCompletionHandler = (_ state:XYUploadDownloadState) -> Void
    
    // MARK: - 上传文件
    /**
     *    @description 上传文件
     *
     *    @param     uploadImg   需要上传的Image对象
     *
     *    @param     completionHandler   请求完成后的结果处理Block
     *
     */
    class func UploadImage(_ requestConfig: RequestConfig, img: UIImage, completionHandler: @escaping UploadDownloadCompletionHandler) {
        
        guard let imgData = img.jpegData(compressionQuality: 0.8) else {
            
            completionHandler(.Error(XYError(type: XYErrorCustomType.JpegData)))
            return
        }
        
        var hudIdOrNil:XYProgressHudId? = nil
        if let progressHudView = requestConfig.progressHudViewOrNil {
            
            hudIdOrNil = XYProgressHudManager.AddProgressHud(toView: progressHudView)
        }
        
        var reQuestParameters = XYParameters()
        
        // 添加公共参数
        if let belong: String = APP_CurrentTarget.belongOrNil {
            
            reQuestParameters["belong"] = belong
        }
        reQuestParameters["device"] = "iPhone"
        reQuestParameters["osVersion"] = XYDevice.OSVersion()
        reQuestParameters["brand"] = XYDevice.ModelName()
        reQuestParameters["appVersion"] = ProjectSetting.Share().currentAppVersionPair.appVersionForService
        
        //添加用户数据
//        if requestConfig.needUserMsg,
//            let userInfo = UserManage.UserInfoOrNil {
//
//            reQuestParameters["teacherId"] = userInfo.userId
//            reQuestParameters["sessionId"] = userInfo.sessionId
//        }
        
        //添加原参
        if let para = requestConfig.parametersOrNil {
            
            for key in para.keys {
                
                let value = para[key]
                let newValue = value
                
                reQuestParameters[key] = newValue
            }
        }
        
        let checkedParaters = self.CheckParaters(url: requestConfig.requestUrl, originalParameters: reQuestParameters)
        
        let headers: HTTPHeaders = self.SignHeader(originalParameters: checkedParaters)
        
        completionHandler(.Delay)
        
        /// 请求开始时间
        let requestStartDate : Date = Date()
        
        self.default.sessionManager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(imgData, withName: "imgFile", fileName: "imgFile.png", mimeType: "image/jpeg")

            //拼接参数
            for (key, value) in checkedParaters {
                
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: requestConfig.requestUrl, method: .post, headers: headers) { (encodingResult) in
            
            switch encodingResult {
            case .success(let uploadFile, _, _):
                
                //上传进度回调
                uploadFile.uploadProgress(closure: { (progress) in
                    
                    XYLog.LogNoteBlock { () -> String? in
                        
                        return "上传进度\(progress)"
                    }

                    completionHandler(.Progress(XYUploadDownloadProgress(completed: Double(progress.completedUnitCount), total: Double(progress.totalUnitCount))))
                })
                
                uploadFile.responseData(queue: nil) { (dataResponse) in
                    
                    defer {
                        
                        if let hudId = hudIdOrNil {
                            
                            XYProgressHudManager.RemoveProgressHUD(removeingHudId: hudId)
                        }
                    }
                    
                    requestConfig.requestLog = """
                    ------------------------------------------
                    请求Url:\(requestConfig.requestUrl)
                    请求耗时:\(Date.TimeIntervalMilliSecond(otherDate: requestStartDate).xyDecimalLength(0))ms
                    请求参数:\(checkedParaters.jsonDescription())
                    """
                    
                    /// 数据返回状态码
                    var statusCode: Int = NSURLErrorUnknown
                    
                    if let response = dataResponse.response {
                        
                        statusCode = response.statusCode
                        requestConfig.requestLog.append("\n请求结果状态: \(response.statusCode)")
                    }
                    
                    switch dataResponse.result {
                    case .success(let data):
                        
                        switch statusCode {
                        case 400, 401, 403, 404, 500, 502, 503:
                            
                            self.HandleErrorForUploadDownload(error: XYError(code: statusCode, detailMsg: XYRequestCompleteState.Data(data).dataMsg), requestConfig: requestConfig, completionHandle: completionHandler)
                            
                            break
                            
                        default:
                            
                            let completeState = XYRequestCompleteState.StateByData(data)
                            
                            completionHandler(.Complete(completeState))
                            
                            requestConfig.requestLog.append("\n请求结果数据(在线):\(completeState.dataMsg)")
                            
                            break
                        }
                        
                        break
                        
                    case .failure(let error):
                        
                        self.HandleErrorForUploadDownload(error: XYError(error: error), requestConfig: requestConfig, completionHandle: completionHandler)
                        
                        break
                    }
                    
                    requestConfig.requestLog.append("\n------------------------------------------")
                    
                    XYLog.LogRequest(msg: requestConfig.requestLog, mark: "\(requestConfig.requestUrl)")
                }
                break
                
            case .failure( let error):
                
                requestConfig.requestLog = """
                ------------------------------------------
                请求Url:\(requestConfig.requestUrl)
                请求耗时:\(Date.TimeIntervalMilliSecond(otherDate: requestStartDate).xyDecimalLength(0))ms
                请求参数:\(checkedParaters.jsonDescription())
                """
                
                self.HandleErrorForUploadDownload(error: XYError(error: error), requestConfig: requestConfig, completionHandle: completionHandler)
                
                requestConfig.requestLog.append("\n------------------------------------------")
                
                XYLog.LogRequest(msg: requestConfig.requestLog, mark: "\(requestConfig.requestUrl)")
                
                break
            }
        }
        
        
    }
    /*
    class func UploadLogFile(uploadFilePath: String, url:String = RequestUrl(.App_UploadLog), completionHandler: @escaping RequestCompletionHandler) {
        
        let fileUrl = URL(fileURLWithPath: uploadFilePath)
        
        guard let fileData = try? Data(contentsOf: fileUrl) else {
            
            completionHandler(.failure, nil, nil)
            return
        }
        
        self.UploadLogFileData(uploadFileData: fileData, url: url, completionHandler: completionHandler)
    }
    
    class func UploadLogFileData(uploadFileData fileData: Data, url:String = RequestUrl(.App_UploadLog), completionHandler: @escaping RequestCompletionHandler){
        
        var reQuestParameters: XYParameters = [:];
        
        //添加用户数据
        if let userInfo = UserManage.UserInfoOrNil {
            
            reQuestParameters["teacherId"] = userInfo.userId
            reQuestParameters["sessionId"] = userInfo.sessionId
        }
        
        let checkedParaters = self.CheckParaters(url: "\(url)", originalParameters: reQuestParameters)
        
        let headers: HTTPHeaders = self.SignHeader(originalParameters: checkedParaters)
        
        self.default.sessionManager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(fileData, withName: "logFile", fileName: "logFile.sts", mimeType: "")
            
            //拼接参数
            for (key, value) in checkedParaters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (encodingResult) in
            
            switch encodingResult{
            case .success(let uploadFile, _, _):
                
                //上传进度回调
                uploadFile.uploadProgress(closure: { (progress) in
                    
                    XYLog.LogNoteBlock { () -> String? in
                        
                        return "上传进度\(progress)"
                    }
                })
                
                //上传结果回调
                uploadFile.responseJSON(completionHandler: { (response) in
                    
                    var msg = "------------------------------------------\n"
                    msg += "请求Url:\(url)\n"
                    msg += "请求Headers:\(headers)\n"
                    msg += "请求参数:\(checkedParaters)\n"
                    msg += "上传完成\(response)\n"
                    msg += "------------------------------------------"
                    
                    XYLog.LogRequest(msg: msg, mark: url)
                    
                    guard let jsonValue = response.result.value else {
                        
                        completionHandler(.failure, nil, nil)
                        return
                    }
                    
                    let json = jsonValue as! NSDictionary
                    
                    /*
                     "请求成功"
                     error_code = 0
                     reason = ""
                     result =
                     */
                    
                    let rs = json["state"]
                    guard let resultState = rs else {
                        
                        completionHandler(.failure, json, nil)
                        return
                    }
                    
                    let state = resultState as! String
                    
                    guard state == XYRequestState.success.rawValue else{
                        
                        completionHandler(.failure, json, nil)
                        return
                    }
                    
                    completionHandler(.success, json, nil)
                    
                })
                
                break
            case .failure( let error):
                
                var msg = "------------------------------------------\n"
                msg += "请求Url:\(url)\n"
                msg += "请求Headers:\(headers)\n"
                msg += "请求参数:\(checkedParaters)\n"
                msg += "上传出错\(error)\n"
                msg += "------------------------------------------"
                
                XYLog.LogRequest(msg: msg, mark: url)
                
                completionHandler(.error, nil, error)
                
                break
            }
        }
    }
    
    
    
    // MimeType: https://tool.oschina.net/commons/
    static func UploadMP3FileData(uploadFilePath: String, fileName: String, fileType: String, mimeType: String = "audio/mp3", url:String = RequestUrl(.App_UploadLog), completionHandler: @escaping RequestCompletionHandler){
        
        let fileUrl = URL(fileURLWithPath: uploadFilePath)
        
        guard let fileData = try? Data(contentsOf: fileUrl) else {
            
            completionHandler(.failure, nil, nil)
            return
        }
        
        var reQuestParameters: XYParameters = [:];
        
        //添加用户数据
        if let userInfo = UserManage.UserInfoOrNil {
            
            reQuestParameters["teacherId"] = userInfo.userId
            reQuestParameters["sessionId"] = userInfo.sessionId
        }
        
        let checkedParaters = self.CheckParaters(url: "\(url)", originalParameters: reQuestParameters)
        
        let headers: HTTPHeaders = self.SignHeader(originalParameters: checkedParaters)
        
        self.default.sessionManager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(fileData, withName: fileName, fileName: "\(fileName).\(fileType)", mimeType: mimeType)
            
            //拼接参数
            for (key, value) in checkedParaters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (encodingResult) in
            
            switch encodingResult{
            case .success(let uploadFile, _, _):
                
                //上传进度回调
                uploadFile.uploadProgress(closure: { (progress) in
                    
                    XYLog.LogNoteBlock { () -> String? in
                        
                        return "上传进度\(progress)"
                    }
                })
                
                //上传结果回调
                uploadFile.responseJSON(completionHandler: { (response) in
                    
                    var msg = "------------------------------------------\n"
                    msg += "请求Url:\(url)\n"
                    msg += "请求Headers:\(headers)\n"
                    msg += "请求参数:\(checkedParaters)\n"
                    msg += "上传完成\(response)\n"
                    msg += "------------------------------------------"
                    
                    XYLog.LogRequest(msg: msg, mark: url)
                    
                    guard let jsonValue = response.result.value else {
                        
                        completionHandler(.failure, nil, nil)
                        return
                    }
                    
                    let json = jsonValue as! NSDictionary
                    
                    /*
                     "请求成功"
                     error_code = 0
                     reason = ""
                     result =
                     */
                    
                    let rs = json["state"]
                    guard let resultState = rs else {
                        
                        completionHandler(.failure, json, nil)
                        return
                    }
                    
                    let state = resultState as! String
                    
                    guard state == XYRequestState.success.rawValue else{
                        
                        completionHandler(.failure, json, nil)
                        return
                    }
                    
                    completionHandler(.success, json, nil)
                    
                })
                
                break
            case .failure( let error):
                
                var msg = "------------------------------------------\n"
                msg += "请求Url:\(url)\n"
                msg += "请求Headers:\(headers)\n"
                msg += "请求参数:\(checkedParaters)\n"
                msg += "上传出错\(error)\n"
                msg += "------------------------------------------"
                
                XYLog.LogRequest(msg: msg, mark: url)
                
                completionHandler(.error, nil, error)
                
                break
            }
        }
    }
    
    static func UploadFile(uploadFilePath: String, fileName: String, fileType: String, mimeType: String, url:String = RequestUrl(.App_UploadLog), completionHandler: @escaping RequestCompletionHandler){
        
        let fileUrl = URL(fileURLWithPath: uploadFilePath)
        
        var reQuestParameters: XYParameters = [:];
        
        //添加用户数据
        if let userInfo = UserManage.UserInfoOrNil {
            
            reQuestParameters["teacherId"] = userInfo.userId
            reQuestParameters["sessionId"] = userInfo.sessionId
        }
        
        let checkedParaters = self.CheckParaters(url: "\(url)", originalParameters: reQuestParameters)
        
        let headers: HTTPHeaders = self.SignHeader(originalParameters: checkedParaters)
        
        self.default.sessionManager.upload(multipartFormData: { (multipartFormData) in
            
//            multipartFormData.append(fileData, withName: fileName, fileName: "\(fileName).\(fileType)", mimeType: mimeType)
//            multipartFormData.append(fileUrl, withName: "\(fileName).\(fileType)")
            multipartFormData.append(fileUrl, withName: fileName, fileName: "\(fileName).\(fileType)", mimeType: mimeType)
            
            //拼接参数
            for (key, value) in checkedParaters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (encodingResult) in
            
            switch encodingResult{
            case .success(let uploadFile, _, _):
                
                //上传进度回调
                uploadFile.uploadProgress(closure: { (progress) in
                    
                    XYLog.LogNoteBlock { () -> String? in
                        
                        return "上传进度\(progress)"
                    }
                })
                
                //上传结果回调
                uploadFile.responseJSON(completionHandler: { (response) in
                    
                    var msg = "------------------------------------------\n"
                    msg += "请求Url:\(url)\n"
                    msg += "请求Headers:\(headers)\n"
                    msg += "请求参数:\(checkedParaters)\n"
                    msg += "上传完成\(response)\n"
                    msg += "------------------------------------------"
                    
                    XYLog.LogRequest(msg: msg, mark: url)
                    
                    guard let jsonValue = response.result.value else {
                        
                        completionHandler(.failure, nil, nil)
                        return
                    }
                    
                    let json = jsonValue as! NSDictionary
                    
                    /*
                     "请求成功"
                     error_code = 0
                     reason = ""
                     result =
                     */
                    
                    let rs = json["state"]
                    guard let resultState = rs else {
                        
                        completionHandler(.failure, json, nil)
                        return
                    }
                    
                    let state = resultState as! String
                    
                    guard state == XYRequestState.success.rawValue else{
                        
                        completionHandler(.failure, json, nil)
                        return
                    }
                    
                    completionHandler(.success, json, nil)
                    
                })
                
                break
            case .failure( let error):
                
                var msg = "------------------------------------------\n"
                msg += "请求Url:\(url)\n"
                msg += "请求Headers:\(headers)\n"
                msg += "请求参数:\(checkedParaters)\n"
                msg += "上传出错\(error)\n"
                msg += "------------------------------------------"
                
                XYLog.LogRequest(msg: msg, mark: url)
                
                completionHandler(.error, nil, error)
                
                break
            }
        }
    }
    */
    /*
     let destinationPath = DocumentPath()+"Xiyuyanhen_en_US_data.zip"
     XYNetWorkManage.DownloadFile(fileUrl: "https://partner.Xiyuyanhen.com.cn/offlinePackage-zip/en/Xiyuyanhen_en_US_data.zip?date=20171205161220", destinationPath: destinationPath, downloadPercentageHandle: { (percentage:Int64) in
     
     
     }) { (state:XYNetWorkManage.XYRequestState, fileUrl:URL?) in
     
     if state == XYNetWorkManage.XYRequestState.success {
     
     
     }else{
     
     
     }
     }
     */
    
    // MARK: - 下载文件
    
    
    /*
    /**
     *    @description 下载文件
     *
     *    @param     uploadImg   需要下载的文件地址
     *
     *    @param     completionHandler   请求完成后的结果处理Block
     *
     */
    @discardableResult class func DownloadFile(fileUrl:URLConvertible, destinationPath:String, method: HTTPMethod = .get, downloadPercentageHandle:@escaping DownloadProcessHandler, completionHandler: @escaping DownloadCompletionHandler) -> DownloadRequest{
        
        var reQuestParameters: [String:String] = [:];
        
        //        param["teacherId"] = "1"
        //添加用户数据
        //        if let userInfo = UserManage.UserInfoOrNil {
        //
        //            reQuestParameters["teacherId"] = userInfo.userId
        //            reQuestParameters["sessionId"] = userInfo.sessionId
        //        }
        //
        //        let headers: HTTPHeaders = self.RequestHeaders()
        
        let downloadRequest = self.default.downloadManager.download(fileUrl, method: method, parameters: reQuestParameters, encoding: URLEncoding.default, headers: nil) { (temporaryURL:URL, response:HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            
            let destinationUrl = URL(fileURLWithPath: destinationPath)
            
            return (destinationUrl, options: DownloadRequest.DownloadOptions.removePreviousFile)
        }
        
        self.default.downloadHandle(downloadRequest: downloadRequest, downloadPercentageHandle: downloadPercentageHandle, completionHandler: completionHandler)
        
        return downloadRequest
    }
    
    class func DownloadResuming(resumingData: Data, toDestination: DownloadRequest.DownloadFileDestination?, downloadPercentageHandle:@escaping DownloadProcessHandler, completionHandler: @escaping DownloadCompletionHandler){
        
        let downloadRequest = self.default.downloadManager.download(resumingWith: resumingData, to: toDestination)
        
        self.default.downloadHandle(downloadRequest: downloadRequest, downloadPercentageHandle: downloadPercentageHandle, completionHandler: completionHandler)
    }
    
    func downloadHandle(downloadRequest:DownloadRequest, downloadPercentageHandle:@escaping DownloadProcessHandler, completionHandler: @escaping DownloadCompletionHandler){
        
        downloadRequest.downloadProgress(queue: DispatchQueue.main) { (progress:Progress) in
            
            let completedCount = Double(progress.completedUnitCount)
            let totalCount = Double(progress.totalUnitCount)
            let completeRate = completedCount/totalCount
            let completePercentage = UInt(completeRate*100)
    
            downloadPercentageHandle(completePercentage)
        }

        downloadRequest.responseData(queue: nil) { (downloadResponse) in
            
            let reuslt = downloadResponse.result
            
//            let temporaryURL = downloadRequest
            let destinationURL = downloadResponse.destinationURL
            
            switch reuslt{
                
            case .success(let data):
                
                if let downloadedUrl = destinationURL  {
                    
                    completionHandler(.success , downloadedUrl, nil)
                }else{
                    
                    completionHandler(.failure , nil, nil)
                }
                
                break
                
            case .failure(let error):
                
                let resumeData = downloadResponse.resumeData //意外终止的话，把已下载的数据储存起来
                
                if let nsError = error as? NSError {
                    
                    if nsError.code == -999 {
                        // cancel
                        
                        completionHandler(.Cancel , nil, resumeData)
                        return
                    }else {
                        
                        XYLog.LogError(msg: "下载文件失败！error:\(nsError)")
                    }
                }
            
                completionHandler(.failure , nil, resumeData)
            
                break
            }
        }
    }
    */
    // MARK: - 公共方法
    class func RequestHeaders() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [

            "device": "iPhone", //设备类型
            "osVersion": XYDevice.OSVersion(), //系统版本
            "brand" : XYDevice.ModelName(), //设备品牌
            "appVersion": ProjectSetting.Share().currentAppVersionPair.appVersionForService //应用版本
        ]
        
        if let belong: String = APP_CurrentTarget.belongOrNil {
            
            headers["belong"] = belong
        }
        
        return headers;
    }
    
}
