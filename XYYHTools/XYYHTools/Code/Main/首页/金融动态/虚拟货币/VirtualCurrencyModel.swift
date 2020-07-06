//
//  VirtualCurrencyModel.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/5/13.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

class VirtualCurrencyModel : XYObject, StructModelProtocol_Create {
    
    /*
     ------------------------------------------
     请求Url:https://www.bitstamp.net/api/ticker
     请求耗时:760ms
     请求参数:{
       "osVersion" : "13.5.1",
       "brand" : "iPhone11,8",
       "appVersion" : "1.0",
       "device" : "iPhone"
     }
     请求结果状态: 200
     请求结果数据(在线):{
       "ask" : "9203.83",
       "last" : "9201.55",
       "volume" : "3842.07250133",
       "open" : 9077.1800000000003,
       "high" : "9238.21000000",
       "vwap" : "9088.84",
       "low" : "8905.00000000",
       "bid" : "9202.74",
       "timestamp" : "1594029635"
     }
     ------------------------------------------
     */
    
    let modelId : String
    
    var lastOrNil : Float?
    var lowOrNil : Float?
    var volumeOrNil : Float?
    var timestampOrNil : Int?
    var highOrNil : Float?
    var askOrNil : Float?
    var vwapOrNil : Float?
    var bidOrNil : Float?
    var openOrNil : Float?
    
    init(modelId: String) {
        
        self.modelId = modelId
    }
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any?) -> VirtualCurrencyModel? {
        
        guard let dataDic = dataDicOrNil,
            0 < dataDic.count else { return nil }
        
        //(dataDic as Dictionary).xyLogAllProperty(name: "VirtualCurrencyModel")
        
        guard let modelId: String = eDataOrNil as? String else { return nil }
        
        let newValue = VirtualCurrencyModel(modelId: modelId)
        
        if let last:Float = dataDic.xyFloat("last") {

            newValue.lastOrNil = last
        }

        if let low:Float = dataDic.xyFloat("low") {

            newValue.lowOrNil = low
        }

        if let volume:Float = dataDic.xyFloat("volume") {

            newValue.volumeOrNil = volume
        }

        if let timestamp:Int = dataDic.xyInt("timestamp") {

            newValue.timestampOrNil = timestamp
        }

        if let high:Float = dataDic.xyFloat("high") {

            newValue.highOrNil = high
        }

        if let ask:Float = dataDic.xyFloat("ask") {

            newValue.askOrNil = ask
        }

        if let vwap:Float = dataDic.xyFloat("vwap") {

            newValue.vwapOrNil = vwap
        }

        if let bid:Float = dataDic.xyFloat("bid") {

            newValue.bidOrNil = bid
        }

        if let open:Float = dataDic.xyFloat("open") {

            newValue.openOrNil = open
        }
        
        return newValue
    }
}
