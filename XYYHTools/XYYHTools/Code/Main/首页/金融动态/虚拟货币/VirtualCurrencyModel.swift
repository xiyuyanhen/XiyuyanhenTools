//
//  VirtualCurrencyModel.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/5/13.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

class VirtualCurrencyModel : XYObject, StructModelProtocol_Create {
    
    let modelId : String
    var lastOrNil : String?
    var lowOrNil : String?
    var volumeOrNil : String?
    var timestampOrNil : String?
    var highOrNil : String?
    var askOrNil : String?
    var vwapOrNil : String?
    var bidOrNil : String?
    var openOrNil : NSNumber?
    
    init(modelId: String) {
        
        self.modelId = modelId
    }
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any?) -> VirtualCurrencyModel? {
        
        guard let dataDic = dataDicOrNil,
            0 < dataDic.count else { return nil }
        
        //(dataDic as Dictionary).xyLogAllProperty(name: "VirtualCurrencyModel")
        
        guard let modelId: String = eDataOrNil as? String else { return nil }
        
        let newValue = VirtualCurrencyModel(modelId: modelId)
        
        if let last:String = dataDic.xyObject("last") {

            newValue.lastOrNil = last
        }

        if let low:String = dataDic.xyObject("low") {

            newValue.lowOrNil = low
        }

        if let volume:String = dataDic.xyObject("volume") {

            newValue.volumeOrNil = volume
        }

        if let timestamp:String = dataDic.xyObject("timestamp") {

            newValue.timestampOrNil = timestamp
        }

        if let high:String = dataDic.xyObject("high") {

            newValue.highOrNil = high
        }

        if let ask:String = dataDic.xyObject("ask") {

            newValue.askOrNil = ask
        }

        if let vwap:String = dataDic.xyObject("vwap") {

            newValue.vwapOrNil = vwap
        }

        if let bid:String = dataDic.xyObject("bid") {

            newValue.bidOrNil = bid
        }

        if let open:NSNumber = dataDic.xyObject("open") {

            newValue.openOrNil = open
        }
        
        return newValue
    }
}
