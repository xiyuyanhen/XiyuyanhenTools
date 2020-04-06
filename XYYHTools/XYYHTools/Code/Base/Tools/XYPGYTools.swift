//
//  XYPGYTools.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/19.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import Alamofire

/// 蒲公英更新工具
struct XYPGYTools {
    
    /// PGY 接口请求 API_Key
    fileprivate static var Key: String { return "5d356a69176fe72a1d857e3b63717071" }
    
    fileprivate enum API {
        
        /// 安装
        case AnZ
        /// 获取App信息
        case GetBS
        
        var path: String {
            switch self {
            case .AnZ: return EncodeText.API_AnZ.decryptText()
            case .GetBS: return EncodeText.API_GBS.decryptText()
            }
        }
        
        var scheme: String {
            
            return "\(EncodeText.API_S.decryptText())\(self.path)"
        }
    }
    
    /// 短链接
    fileprivate static var ShortLinkOrNil: String? {
        
        switch APP_CurrentTarget {
        case .ShiTingShuo: return "a8ou"
        case .Xiyou: return "wmvQ"
        }
    }
    
    /// 安装密码
    fileprivate static var BuildPasswordOrNil: String? {
        
        switch APP_CurrentTarget {
        case .ShiTingShuo: return "sts2018"
        case .Xiyou: return "xiyou2019"
        }
    }
}

extension XYPGYTools {
    
    /// 安装链接
     static var AnZLinkOrNil: String? {
        
        guard let shortLink = XYPGYTools.ShortLinkOrNil,
            let password = XYPGYTools.BuildPasswordOrNil else { return nil }
        
        let link: String = "\(XYPGYTools.API.AnZ.scheme)?\(EncodeText.API_P_AK.decryptText())=\(XYPGYTools.Key)\(EncodeText.API_P_APPK.decryptText())\(shortLink)\(EncodeText.API_P_BP.decryptText())\(password)"
        
        return link
    }
    
}

extension XYPGYTools {
    
    /**
     *    @description 获取应用在蒲公英上的信息
     *
     */
    static func CheckVersion() {
        
        guard let shortLink = XYPGYTools.ShortLinkOrNil else {
            
            ShowSingleBtnAlertView(title: "当前App未配置相关参数!")
            return
        }
        
        var parameters = Parameters()
        parameters[EncodeText.API_P_AK.decryptText()] = XYPGYTools.Key
        parameters[EncodeText.API_P_BSU.decryptText()] = shortLink
        
        let dataRequest:DataRequest = SessionManager.default.request(XYPGYTools.API.GetBS.scheme, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
        
        let hudId = XYProgressHudManager.AddProgressHud(toView: ProgressHudView)
        
        dataRequest.responseData(queue: nil) { (dataResponse) in
            
            defer {
                
                XYProgressHudManager.RemoveProgressHUD(removeingHudId: hudId)
            }
            
            guard let data = dataResponse.value,
                let resultDic = NSDictionary.CreateWith(jsondata: data),
                let dataDic: NSDictionary = resultDic.xyObject("data"),
                let buildVersion: String = dataDic.xyObject(EncodeText.API_P_BV.decryptText()),
                let buildVersionNo: String = dataDic.xyObject(EncodeText.API_P_BVN.decryptText()) else {
                    
                    ShowSingleBtnAlertView(title: "数据解析失败!")
                    return
                }
            
            /*
             {
               "buildIsLastest" : "1",
               "buildFileSize" : "53836028",
               "buildUpdated" : "2019-11-19 12:49:05",
               "buildName" : "西柚英语",
               "buildShortcutUrl" : "wmvQ",
               "buildVersion" : "1.4.0",
               "buildFileName" : "KL100.ipa",
               "buildBuildVersion" : "4",
               "buildUpdateDescription" : "1.4.0.0 正式环境\n商城购买测试包",
               "buildScreenshots" : "858e7cc4fc738fe1002ca3d09a0603e5,a9072636d66af143eaa4a1d18e708a7f,91578e689c9a9577e23f68a3ca20bdaf",
               "buildType" : "1",
               "buildKey" : "a28e281739b5a724a824286c4031fb6a",
               "buildIsFirst" : "0",
               "buildVersionNo" : "1",
               "buildCreated" : "2019-11-19 12:49:05",
               "buildIdentifier" : "com.zhongkexinsheng.xiyouyingyu"
             }
             */
            
            XYLog.LogRequest(msg: dataDic.jsonDescription(), mark: "PGY更新")
            
            /// 当前PGY最新版本
            let pgyVersion = "\(buildVersion).\(buildVersionNo)"
            
            /// 当前App版本
            let currentVersion = "\(APPInfo.AppMajorVersion()).\(APPInfo.AppMinorVersion())"
            
            guard currentVersion.xyVersionIsOlder(than: pgyVersion) else {
                
                ShowSingleBtnAlertView(title: "当前为最新\(XYPGYTools.EncodeText.Name.decryptText())测试版本!")
                return
            }
            
            guard let link = XYPGYTools.AnZLinkOrNil else {
                
                ShowSingleBtnAlertView(title: "", message: "无法生成链接，请手动更新", comfirmTitle: "好的")
                return
            }
            
            var updateMsg: String = "-----"
            if let buildUpdateDescription: String = dataDic.xyObject(EncodeText.API_P_BUD.decryptText()) {
                
                updateMsg = buildUpdateDescription
            }
        
            ShowNormalAlertView(title: "", message: updateMsg, comfirmTitle: "更新", cancelTitle: "取消", comfirmBtnBlock: { (comfirmAction) in

                if AppDelegate.OpenUrl(url: link) {

                    BuglyManager.ExitAppForUpdate()
                }else {
                    
                    ShowSingleBtnAlertView(title: "跳转失败")
                }

            }, cancelBtnBlock: { (cancelAction) in

            })
        }
    }
}

extension XYPGYTools {
    
    enum EncodeText: String, XYEnumTypeAllCaseProtocol, XYCryptorTextProtocol {
        
        /// https://www.pgyer.com/
        case API_S = "0301e0601bca986228756f9d5f7a96727d63308f90b7d2e55a63590c02fb7e14f86aa88b6e071d1c37a9ce3d07d8ee2fb4e7111111292795f927acb93fce1ef2025c5efc3e77349270bc16082ea475e64d1a97d92ba526d54dfa3d35703741f430a7"
        
        /// apiv2/app/install
        case API_AnZ = "0301016b2ecad11873a823c65f538caa12c2f55ad32ac911536aa53fd5205d7c4a0d920b695a6d389532aa925abbb684325258cadc8e70c30163b15a923167dca5b5b0c1178f073cc2cd7d15d517c058e275a4fbfa45d3b3623eb748b43a5f8ac4da"
        
        /// apiv2/app/getByShortcut
        case API_GBS = "0301a5253a49f2fdfd8eae6ea7408df47011f986850724cf320902ba2558201ac1f15afa7e690be7a0c6b2f309d3a5fcd495cf80fb2d1ffbe52b9694f45be0da58268525cad332271ed896cbc81e1c5413bbbbbf97b880fb140358044c27b0f444bf"
            
        /// _api_key
        case API_P_AK = "03019d1de09c1f271db85942440aec3cdfa61eea49e30043ef3b82be2e3f60aa63296e7038d167dc44cac8df7958456a209e4027dc41f8f146616e2c1bb9b4b6baedfc9cc7c6509bcb983209358810c10d56"
            
        /// &appKey=
        case API_P_APPK = "0301f718604a4ab7a78479cff77ccec137649a93a2e3ee4dbad31c7f8ca6e5de1bcf609be2c6d7ac1b63e7d77576adfad6f3cb9051b7b6a90b38a1d9d86429b951f4fd3b354e91c04f29d2364c6a52601744"
            
        /// &buildPassword=
        case API_P_BP = "0301de0ff6c072289204dfc949f13ac57ea372b37a98e1dda3186005154135cd1a866b400188e041ca89b96f666463f4f2cd6d5953749795d40cdda92f6e299690caa4368e88796b96b593aed80ff551a630"
        
        /// buildShortcutUrl
        case API_P_BSU = "03012eb11823c907f28f62169ea1beab020f89ae1d66e3983903345ae7b3d901995e3185375796dd1d4c51542f165a298508824066189b3a9ba7ab72591b6825affcf4791876426f6fd5c08a7ce3e40c33cd20e9321c7478abca1b9a244a540d8a1c"
        
        /// buildVersion
        case API_P_BV = "0301831d94e65bbe1d9c490a0798099ccf9ba5447274a906f3382bf137d5f027316e9042fe4a035081b57387bd8e525f0d9935f2dd7f5f9c26238c5f9e302fe009979095cb0a3c75e4c2eb95c09503efadf3"
        
        /// buildVersionNo
        case API_P_BVN = "030104dff05c0db63bac1aa8ac46447fd72fa6de1d049c81ab0059f61f8f113661ea0f815fb044945134eb38beec644f233454c0e9de09787b326cb27d6452d8e782fc7b1186cd0fd368ba27ba0a310ee152"
        
        /// buildUpdateDescription
        case API_P_BUD = "03010afd634089dfeb2f2266106aea1e9509f495394835349c1cd26734ff3c107977750adf974b9a3915f674e1f9d3a7b146223e4139dee24ba3a6b95305e33dd877ec2e6125fdd19c1d7a3c82bd0fe7b2e0a854da4e9c4dc807d0a2d99070e2a4ed"
        
        /// 蒲公英
        case Name = "03013fa345443862c407447453092fc91fe5ca94fcb0f99b8a42c0c12f556b226f820f4ce8f7aaa06c85acaaeb8f9a8229edbac8c95193e0018256f904830ecb697109c3ce82b9be812ec35230c54f2cdc03"
    }
}


