//
//  RequestData_Bitstamp.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

struct RequestData_Bitstamp {
    
    static func Ticker() {
        
        RequestConfig(url: RequestUrl_Bitstamp.Ticker, parametersOrNil: nil).get { (requestState) in
            
            switch requestState {
            case .Complete(let completeState):
                
                switch completeState {
                case .Success(let dataDic):
                    
                    
                    
                    return
                    
                case .Failure(let dataDic):
                    
                    if let note: String = dataDic.xyObject("note"),
                        note.isNotEmpty {
                        
                        ShowSingleBtnAlertView(title: "", message: note)
                    }
                    
                    break
                default:
                    break
                }
                break
            default: break
            }
        }
    }
}
