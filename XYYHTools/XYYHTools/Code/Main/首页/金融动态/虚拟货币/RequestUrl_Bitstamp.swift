//
//  RequestUrl_Bitstamp.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

enum RequestUrl_Bitstamp: String, RequestUrlProtocol {
    
    var schemeOrNil: String? {
        
        return "https://www.bitstamp.net/api"
    }
    
    /**
     *    @description Returns data for the BTC/USD currency pair.
     *
     */
    case Ticker = "ticker"
    
    /**
     *    @description
     *
     *    https://www.bitstamp.net/api/v2/ticker/{currency_pair}/
     *
     *    Supported values for currency_pair: btcusd, btceur, eurusd, xrpusd, xrpeur, xrpbtc, ltcusd, ltceur, ltcbtc, ethusd, etheur, ethbtc, bchusd, bcheur, bchbtc
     *
     *    @param    password    MD5加密后32位字符创
     *
     */
    case TickerV2 = "v2/ticker"
    
    
    
}



