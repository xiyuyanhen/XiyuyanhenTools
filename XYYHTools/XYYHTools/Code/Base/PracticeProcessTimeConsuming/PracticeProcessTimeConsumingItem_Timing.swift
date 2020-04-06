//
//  PracticeProcessTimeConsumingItem_Timing.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/1.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

//耗时单元 - 耗时单元
class PracticeProcessTimeConsumingItem_Timing : XYObject, PracticeProcessTimeConsumingItemProtocol {
    
    let itemType: PracticeProcessTimeConsumingItemType = PracticeProcessTimeConsumingItemType.Timing
    
    var itemSearchId: String { return "" }
    
    /// 标识
    let flagText: String
    
    var time : TimeInterval
    var tipOrNil : String?
    
    var queueIdOrNil: String?
    
    init(time: TimeInterval, tip tipOrNil: String? = nil) {
        
        self.flagText = String.MicroSecondString().MD5String()
        
        self.time = time
        self.tipOrNil = tipOrNil
        
        super.init()
    }
    
    lazy var disposeBag: DisposeBag = {
        
        return DisposeBag()
    }()
    
}

extension PracticeProcessTimeConsumingItem_Timing {
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any? = nil) -> PracticeProcessTimeConsumingItem_Timing.ModelArray? {
        
        guard let dataDic = dataDicOrNil,
            0 < dataDic.count else { return nil }

        /*
         {
             "audioTxt": "",
             "interval": 0,
             "count": 0,
             "afterWaitTime": 15,
             "audioURL": "",
             "beforeWaitTime": 0
         }
         */
        
        var timingArr: PracticeProcessTimeConsumingItem_Timing.ModelArray = PracticeProcessTimeConsumingItem_Timing.ModelArray()
        
        if let bTime = TimeInterval(dataDic.objectFromRequestData(forKey: "beforeWaitTime")),
            0.0 < bTime {
            
            timingArr.append(PracticeProcessTimeConsumingItem_Timing(time: bTime, tip: "阅题时间"))
        }
        
        if let interval = TimeInterval(dataDic.objectFromRequestData(forKey: "interval")),
            0.0 < interval {
            
            timingArr.append(PracticeProcessTimeConsumingItem_Timing(time: interval, tip: "等待时间"))
        }
        
        if let aTime = TimeInterval(dataDic.objectFromRequestData(forKey: "afterWaitTime")),
            0.0 < aTime {
        
            timingArr.append(PracticeProcessTimeConsumingItem_Timing(time: aTime, tip: "答题时间"))
        }
        
        guard timingArr.isNotEmpty else { return nil }
        
        return timingArr
    }
}
