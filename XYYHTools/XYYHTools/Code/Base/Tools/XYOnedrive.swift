//
//  XYOnedrive.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2021/1/24.
//  Copyright © 2021 io.xiyuyanhen. All rights reserved.
//

import Foundation

/*
 
 https://docs.microsoft.com/zh-cn/onedrive/developer/rest-api/?view=odsp-graph-online
 
 */

struct XYOnedrive {
    
    static func Setups() {
        
        let appId = "b973bda6-daa8-42d1-a90b-f8b33260e9bd"
        let scopes = ["onedrive.readwrite"]
        
        let logger = ODLogger(logLevel: .verbose)
        
        ODClient.setLogger(logger)
        
        ODClient.setMicrosoftAccountAppId(appId, scopes: scopes)
        
        ODAccountStore.default().logger = logger
        
        let config = ODAppConfiguration()
        config.microsoftAccountAppId = appId
        config.microsoftAccountScopes = scopes
        config.activeDirectoryRedirectURL = "msauth.xiyuyanhen.XYYHTools://auth"
        config.httpProvider = ODURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        config.serviceInfoProvider = ODServiceInfoProvider()
        config.logger = logger
        config.accountStore = ODAccountStore.default()
        
        ODClient.authenticatedClient(withAppConfig: config) { (clientOrNil, errorOrNil) in
            
            if let e = errorOrNil {
                
                let error = XYError(error: e)
                
                XYLog.LogNote(msg: "authenticatedClient.error: \(error.detailMsg)")
                
                return
            }
            
            guard let client = clientOrNil else { return }
            
            XYLog.LogNote(msg: "authenticatedClient.client: \(client)")
            
        }
    
    }
    
    
    
}
