//
//  RequestData_Bitstamp.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

struct RequestData_Bitstamp {
    
    static func Ticker(completion:@escaping CompletionElementBlockHandler<VirtualCurrencyModel>) {
        
        RequestConfig(url: RequestUrl_Bitstamp.Ticker, parametersOrNil: nil).get { (requestState) in
            
            switch requestState {
            case .Complete(let completeState):
                
                switch completeState {
                case .Dic(let dic):
                    
                    completion(VirtualCurrencyModel.CreateModel(dataDic: dic as NSDictionary, extraData: "BTC"))
                    
                    return
                    
                case .Data(_):
                    
                    break
                }
                
                completion(nil)

                return
                
            case .Error(_):
                
                completion(nil)
                
                return
                
            default: break
            }
            
            
        }
    }
}
