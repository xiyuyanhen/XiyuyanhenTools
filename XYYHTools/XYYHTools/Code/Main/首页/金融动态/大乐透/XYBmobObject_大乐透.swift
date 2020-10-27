//
//  XYBmobObject_大乐透.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/8/20.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation
import WCDBSwift

class XYBmobObject_大乐透: XYBmobObjectProtocol {
    
    var dataObjectId: String
    var expect: String
    var date: String
    var frontAreaNumber1: Int = 0
    var frontAreaNumber2: Int = 0
    var frontAreaNumber3: Int = 0
    var frontAreaNumber4: Int = 0
    var frontAreaNumber5: Int = 0
    var backAreaNumber1: Int = 0
    var backAreaNumber2: Int = 0
    
    init(dataObjectId: String, expect: String, date: String) {
        
        self.dataObjectId = dataObjectId
        self.expect = expect
        self.date = date
    }
    
    var objectDataDicOrNil: Dictionary<String, Any>? {
        
//        return [CodingKeys.dataObjectId.stringValue: self.dataObjectId,
//            CodingKeys.expect.stringValue: self.expect,
//            CodingKeys.date.stringValue: self.date]
        
        return [CodingKeys.dataObjectId.stringValue: self.dataObjectId,
            CodingKeys.expect.stringValue: self.expect,
            CodingKeys.date.stringValue: self.date,
            CodingKeys.frontAreaNumber1.stringValue: self.frontAreaNumber1,
            CodingKeys.frontAreaNumber2.stringValue: self.frontAreaNumber2,
            CodingKeys.frontAreaNumber3.stringValue: self.frontAreaNumber3,
            CodingKeys.frontAreaNumber4.stringValue: self.frontAreaNumber4,
            CodingKeys.frontAreaNumber5.stringValue: self.frontAreaNumber5,
            CodingKeys.backAreaNumber1.stringValue: self.backAreaNumber1,
            CodingKeys.backAreaNumber2.stringValue: self.backAreaNumber2]
    }
    
    static var Table: TableNameProtocol = XYWTableName.TableName_大乐透
    
    enum CodingKeys: String, CodingTableKey {
    
        typealias Root = XYBmobObject_大乐透
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        //List the properties which should be bound to table
        
        case dataObjectId
        case expect
        case date
        case frontAreaNumber1
        case frontAreaNumber2
        case frontAreaNumber3
        case frontAreaNumber4
        case frontAreaNumber5
        case backAreaNumber1
        case backAreaNumber2
        
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .dataObjectId:  ColumnConstraintBinding(isPrimary: true, isAutoIncrement: false),
                .expect:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .date:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber1:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber2:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber3:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber4:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .frontAreaNumber5:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .backAreaNumber1:  ColumnConstraintBinding(isNotNull: true, isUnique: false),
                .backAreaNumber2:  ColumnConstraintBinding(isNotNull: true, isUnique: false)
            ]
        }
    }
}

extension XYBmobObject_大乐透: StructModelProtocol_Create {
    
    static func CreateModel(dataDic dataDicOrNil: NSDictionary?, extraData eDataOrNil: Any?) -> XYBmobObject_大乐透? {
        
        guard let dataDic = dataDicOrNil,
            0 < dataDic.count else { return nil }
        
        //        (dataDic as Dictionary).xyLogAllProperty(name: "PracticeProcessTimeConsumingItem_Audio")
        
        /*
         {
           "drawFlowFundRj" : "",
           "matchList" : [

           ],
           "drawFlowFund" : "0",
           "lotteryGameName" : "超级大乐透",
           "poolBalanceAfterdraw" : "644,732,638.55",
           "verify" : 1,
           "lotteryDrawResult" : "03 12 23 26 30 04 07",
           "lotteryGamePronum" : 0,
           "prizeLevelList" : [
             {
               "stakeCount" : "35",
               "totalPrizeamount" : "194,034,190",
               "stakeAmount" : "5,543,834",
               "sort" : 10,
               "awardType" : 0,
               "prizeLevel" : "一等奖"
             },
             {
               "stakeCount" : "32",
               "totalPrizeamount" : "141,922,144",
               "stakeAmount" : "4,435,067",
               "sort" : 20,
               "awardType" : 0,
               "prizeLevel" : "一等奖(追加)"
             },
             {
               "stakeCount" : "119",
               "totalPrizeamount" : "11,132,807",
               "stakeAmount" : "93,553",
               "sort" : 30,
               "awardType" : 0,
               "prizeLevel" : "二等奖"
             },
             {
               "stakeCount" : "45",
               "totalPrizeamount" : "3,367,890",
               "stakeAmount" : "74,842",
               "sort" : 40,
               "awardType" : 0,
               "prizeLevel" : "二等奖(追加)"
             },
             {
               "stakeCount" : "259",
               "totalPrizeamount" : "2,590,000",
               "stakeAmount" : "10,000",
               "sort" : 50,
               "awardType" : 0,
               "prizeLevel" : "三等奖"
             },
             {
               "stakeCount" : "1,088",
               "totalPrizeamount" : "3,264,000",
               "stakeAmount" : "3,000",
               "sort" : 60,
               "awardType" : 0,
               "prizeLevel" : "四等奖"
             },
             {
               "stakeCount" : "13,677",
               "totalPrizeamount" : "4,103,100",
               "stakeAmount" : "300",
               "sort" : 70,
               "awardType" : 0,
               "prizeLevel" : "五等奖"
             },
             {
               "stakeCount" : "29,394",
               "totalPrizeamount" : "5,878,800",
               "stakeAmount" : "200",
               "sort" : 80,
               "awardType" : 0,
               "prizeLevel" : "六等奖"
             },
             {
               "stakeCount" : "30,495",
               "totalPrizeamount" : "3,049,500",
               "stakeAmount" : "100",
               "sort" : 90,
               "awardType" : 0,
               "prizeLevel" : "七等奖"
             },
             {
               "stakeCount" : "728,874",
               "totalPrizeamount" : "10,933,110",
               "stakeAmount" : "15",
               "sort" : 100,
               "awardType" : 0,
               "prizeLevel" : "八等奖"
             },
             {
               "stakeCount" : "7,992,771",
               "totalPrizeamount" : "39,963,855",
               "stakeAmount" : "5",
               "sort" : 110,
               "awardType" : 0,
               "prizeLevel" : "九等奖"
             }
           ],
           "poolBalanceAfterdrawRj" : "",
           "lotteryGameNum" : "85",
           "lotteryDrawStatus" : 20,
           "totalSaleAmountRj" : "",
           "pdfType" : 1,
           "estimateDrawTime" : "",
           "lotteryDrawNum" : "20104",
           "lotterySuspendedFlag" : 0,
           "lotteryDrawTime" : "2020-10-21",
           "lotterySaleBeginTime" : "2020-10-19 20:10:00",
           "lotterySaleEndtime" : "2020-10-21 20:00:00",
           "termList" : [

           ],
           "lotteryPromotionFlag" : 0,
           "lotteryUnsortDrawresult" : "03+26+12+23+30 04+07",
           "isGetKjpdf" : 1,
           "isGetXlpdf" : 2,
           "totalSaleAmount" : "276,928,873",
           "ruleType" : 0,
           "lotteryEquipmentCount" : 1,
           "prizeLevelListRj" : [

           ]
         }
         */
        
        guard let lotteryDrawNum: String = dataDic.xyObject("lotteryDrawNum"),
            lotteryDrawNum.isNotEmpty,
            let lotteryDrawTime: String = dataDic.xyObject("lotteryDrawTime"),
            lotteryDrawTime.isNotEmpty,
            let lotteryDrawResult: String = dataDic.xyObject("lotteryDrawResult"),
            lotteryDrawResult.isNotEmpty else { return nil }
        
        // "03 12 23 26 30 04 07"
        
        let numArr = lotteryDrawResult.components(separatedBy: " ")
        
        guard let frontAreaNumber1 = numArr.elementByIndex(0)?.toIntOrNil,
            let frontAreaNumber2 = numArr.elementByIndex(1)?.toIntOrNil,
            let frontAreaNumber3 = numArr.elementByIndex(2)?.toIntOrNil,
            let frontAreaNumber4 = numArr.elementByIndex(3)?.toIntOrNil,
            let frontAreaNumber5 = numArr.elementByIndex(4)?.toIntOrNil,
            let backAreaNumber1 = numArr.elementByIndex(5)?.toIntOrNil,
            let backAreaNumber2 = numArr.elementByIndex(6)?.toIntOrNil else { return nil }
        
        let newValue = XYBmobObject_大乐透(dataObjectId: lotteryDrawNum, expect: lotteryDrawNum, date: lotteryDrawTime)
        
        newValue.frontAreaNumber1 = frontAreaNumber1
        newValue.frontAreaNumber2 = frontAreaNumber2
        newValue.frontAreaNumber3 = frontAreaNumber3
        newValue.frontAreaNumber4 = frontAreaNumber4
        newValue.frontAreaNumber5 = frontAreaNumber5
        newValue.backAreaNumber1 = backAreaNumber1
        newValue.backAreaNumber2 = backAreaNumber2
        
        return newValue
    }
    
    
    static func Request(completion: @escaping CompletionElementBlockHandler<[XYBmobObject_大乐透]>) {
        
        /*
         https://webapi.sporttery.cn/gateway/lottery/getHistoryPageListV1.qry?gameNo=85&provinceId=0&pageSize=5&isVerify=1&pageNo=1&termLimits=5
         */
        
        let parameters = ["gameNo":"85",
                    "provinceId":"0",
                    "pageSize":"5",
                    "isVerify":"1",
                    "pageNo":"1",
                    "termLimits":"5"]
        
        RequestConfig(scheme: "https://webapi.sporttery.cn", path: "gateway/lottery/getHistoryPageListV1.qry", parametersOrNil: parameters).get { (requestState) in
            
            switch requestState {
            case .Complete(let completeState):
                
                switch completeState {
                case .Dic(let dic):
                    
                    if let value: NSDictionary = dic.xyObject("value"),
                       let list: NSArray = value.xyObject("list"),
                       let models = XYBmobObject_大乐透.CreateArray(listArr: list) {
                        
                        completion(models)
                        
                        return
                    }
                    
                    break
                    
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

/*
 
 {
   "errorMessage" : "处理成功",
   "success" : true,
   "value" : {
     "pages" : 1,
     "list" : [
       {
         "drawFlowFundRj" : "",
         "matchList" : [

         ],
         "drawFlowFund" : "0",
         "lotteryGameName" : "超级大乐透",
         "poolBalanceAfterdraw" : "644,732,638.55",
         "verify" : 1,
         "lotteryDrawResult" : "03 12 23 26 30 04 07",
         "lotteryGamePronum" : 0,
         "prizeLevelList" : [
           {
             "stakeCount" : "35",
             "totalPrizeamount" : "194,034,190",
             "stakeAmount" : "5,543,834",
             "sort" : 10,
             "awardType" : 0,
             "prizeLevel" : "一等奖"
           },
           {
             "stakeCount" : "32",
             "totalPrizeamount" : "141,922,144",
             "stakeAmount" : "4,435,067",
             "sort" : 20,
             "awardType" : 0,
             "prizeLevel" : "一等奖(追加)"
           },
           {
             "stakeCount" : "119",
             "totalPrizeamount" : "11,132,807",
             "stakeAmount" : "93,553",
             "sort" : 30,
             "awardType" : 0,
             "prizeLevel" : "二等奖"
           },
           {
             "stakeCount" : "45",
             "totalPrizeamount" : "3,367,890",
             "stakeAmount" : "74,842",
             "sort" : 40,
             "awardType" : 0,
             "prizeLevel" : "二等奖(追加)"
           },
           {
             "stakeCount" : "259",
             "totalPrizeamount" : "2,590,000",
             "stakeAmount" : "10,000",
             "sort" : 50,
             "awardType" : 0,
             "prizeLevel" : "三等奖"
           },
           {
             "stakeCount" : "1,088",
             "totalPrizeamount" : "3,264,000",
             "stakeAmount" : "3,000",
             "sort" : 60,
             "awardType" : 0,
             "prizeLevel" : "四等奖"
           },
           {
             "stakeCount" : "13,677",
             "totalPrizeamount" : "4,103,100",
             "stakeAmount" : "300",
             "sort" : 70,
             "awardType" : 0,
             "prizeLevel" : "五等奖"
           },
           {
             "stakeCount" : "29,394",
             "totalPrizeamount" : "5,878,800",
             "stakeAmount" : "200",
             "sort" : 80,
             "awardType" : 0,
             "prizeLevel" : "六等奖"
           },
           {
             "stakeCount" : "30,495",
             "totalPrizeamount" : "3,049,500",
             "stakeAmount" : "100",
             "sort" : 90,
             "awardType" : 0,
             "prizeLevel" : "七等奖"
           },
           {
             "stakeCount" : "728,874",
             "totalPrizeamount" : "10,933,110",
             "stakeAmount" : "15",
             "sort" : 100,
             "awardType" : 0,
             "prizeLevel" : "八等奖"
           },
           {
             "stakeCount" : "7,992,771",
             "totalPrizeamount" : "39,963,855",
             "stakeAmount" : "5",
             "sort" : 110,
             "awardType" : 0,
             "prizeLevel" : "九等奖"
           }
         ],
         "poolBalanceAfterdrawRj" : "",
         "lotteryGameNum" : "85",
         "lotteryDrawStatus" : 20,
         "totalSaleAmountRj" : "",
         "pdfType" : 1,
         "estimateDrawTime" : "",
         "lotteryDrawNum" : "20104",
         "lotterySuspendedFlag" : 0,
         "lotteryDrawTime" : "2020-10-21",
         "lotterySaleBeginTime" : "2020-10-19 20:10:00",
         "lotterySaleEndtime" : "2020-10-21 20:00:00",
         "termList" : [

         ],
         "lotteryPromotionFlag" : 0,
         "lotteryUnsortDrawresult" : "03+26+12+23+30 04+07",
         "isGetKjpdf" : 1,
         "isGetXlpdf" : 2,
         "totalSaleAmount" : "276,928,873",
         "ruleType" : 0,
         "lotteryEquipmentCount" : 1,
         "prizeLevelListRj" : [

         ]
       },
       {
         "drawFlowFundRj" : "",
         "matchList" : [

         ],
         "drawFlowFund" : "0",
         "lotteryGameName" : "超级大乐透",
         "poolBalanceAfterdraw" : "929,277,059.37",
         "verify" : 1,
         "lotteryDrawResult" : "07 12 13 19 23 02 08",
         "lotteryGamePronum" : 0,
         "prizeLevelList" : [
           {
             "stakeCount" : "7",
             "totalPrizeamount" : "49,396,816",
             "stakeAmount" : "7,056,688",
             "sort" : 10,
             "awardType" : 0,
             "prizeLevel" : "一等奖"
           },
           {
             "stakeCount" : "3",
             "totalPrizeamount" : "16,936,050",
             "stakeAmount" : "5,645,350",
             "sort" : 20,
             "awardType" : 0,
             "prizeLevel" : "一等奖(追加)"
           },
           {
             "stakeCount" : "182",
             "totalPrizeamount" : "6,593,496",
             "stakeAmount" : "36,228",
             "sort" : 30,
             "awardType" : 0,
             "prizeLevel" : "二等奖"
           },
           {
             "stakeCount" : "66",
             "totalPrizeamount" : "1,912,812",
             "stakeAmount" : "28,982",
             "sort" : 40,
             "awardType" : 0,
             "prizeLevel" : "二等奖(追加)"
           },
           {
             "stakeCount" : "419",
             "totalPrizeamount" : "4,190,000",
             "stakeAmount" : "10,000",
             "sort" : 50,
             "awardType" : 0,
             "prizeLevel" : "三等奖"
           },
           {
             "stakeCount" : "1,628",
             "totalPrizeamount" : "4,884,000",
             "stakeAmount" : "3,000",
             "sort" : 60,
             "awardType" : 0,
             "prizeLevel" : "四等奖"
           },
           {
             "stakeCount" : "33,149",
             "totalPrizeamount" : "9,944,700",
             "stakeAmount" : "300",
             "sort" : 70,
             "awardType" : 0,
             "prizeLevel" : "五等奖"
           },
           {
             "stakeCount" : "40,515",
             "totalPrizeamount" : "8,103,000",
             "stakeAmount" : "200",
             "sort" : 80,
             "awardType" : 0,
             "prizeLevel" : "六等奖"
           },
           {
             "stakeCount" : "52,192",
             "totalPrizeamount" : "5,219,200",
             "stakeAmount" : "100",
             "sort" : 90,
             "awardType" : 0,
             "prizeLevel" : "七等奖"
           },
           {
             "stakeCount" : "1,117,693",
             "totalPrizeamount" : "16,765,395",
             "stakeAmount" : "15",
             "sort" : 100,
             "awardType" : 0,
             "prizeLevel" : "八等奖"
           },
           {
             "stakeCount" : "9,259,326",
             "totalPrizeamount" : "46,296,630",
             "stakeAmount" : "5",
             "sort" : 110,
             "awardType" : 0,
             "prizeLevel" : "九等奖"
           }
         ],
         "poolBalanceAfterdrawRj" : "",
         "lotteryGameNum" : "85",
         "lotteryDrawStatus" : 20,
         "totalSaleAmountRj" : "",
         "pdfType" : 1,
         "estimateDrawTime" : "",
         "lotteryDrawNum" : "20103",
         "lotterySuspendedFlag" : 0,
         "lotteryDrawTime" : "2020-10-19",
         "lotterySaleBeginTime" : "2020-10-17 20:10:00",
         "lotterySaleEndtime" : "2020-10-19 20:00:00",
         "termList" : [

         ],
         "lotteryPromotionFlag" : 0,
         "lotteryUnsortDrawresult" : "23+12+19+07+13 08+02",
         "isGetKjpdf" : 1,
         "isGetXlpdf" : 2,
         "totalSaleAmount" : "273,609,545",
         "ruleType" : 0,
         "lotteryEquipmentCount" : 2,
         "prizeLevelListRj" : [

         ]
       },
       {
         "drawFlowFundRj" : "",
         "matchList" : [

         ],
         "drawFlowFund" : "22995120.7",
         "lotteryGameName" : "超级大乐透",
         "poolBalanceAfterdraw" : "965,450,648.80",
         "verify" : 1,
         "lotteryDrawResult" : "07 11 18 20 29 09 12",
         "lotteryGamePronum" : 0,
         "prizeLevelList" : [
           {
             "stakeCount" : "2",
             "totalPrizeamount" : "20,000,000",
             "stakeAmount" : "10,000,000",
             "sort" : 10,
             "awardType" : 0,
             "prizeLevel" : "一等奖"
           },
           {
             "stakeCount" : "1",
             "totalPrizeamount" : "8,000,000",
             "stakeAmount" : "8,000,000",
             "sort" : 20,
             "awardType" : 0,
             "prizeLevel" : "一等奖(追加)"
           },
           {
             "stakeCount" : "170",
             "totalPrizeamount" : "11,511,890",
             "stakeAmount" : "67,717",
             "sort" : 30,
             "awardType" : 0,
             "prizeLevel" : "二等奖"
           },
           {
             "stakeCount" : "53",
             "totalPrizeamount" : "2,871,169",
             "stakeAmount" : "54,173",
             "sort" : 40,
             "awardType" : 0,
             "prizeLevel" : "二等奖(追加)"
           },
           {
             "stakeCount" : "584",
             "totalPrizeamount" : "5,840,000",
             "stakeAmount" : "10,000",
             "sort" : 50,
             "awardType" : 0,
             "prizeLevel" : "三等奖"
           },
           {
             "stakeCount" : "833",
             "totalPrizeamount" : "2,499,000",
             "stakeAmount" : "3,000",
             "sort" : 60,
             "awardType" : 0,
             "prizeLevel" : "四等奖"
           },
           {
             "stakeCount" : "22,182",
             "totalPrizeamount" : "6,654,600",
             "stakeAmount" : "300",
             "sort" : 70,
             "awardType" : 0,
             "prizeLevel" : "五等奖"
           },
           {
             "stakeCount" : "23,094",
             "totalPrizeamount" : "4,618,800",
             "stakeAmount" : "200",
             "sort" : 80,
             "awardType" : 0,
             "prizeLevel" : "六等奖"
           },
           {
             "stakeCount" : "68,336",
             "totalPrizeamount" : "6,833,600",
             "stakeAmount" : "100",
             "sort" : 90,
             "awardType" : 0,
             "prizeLevel" : "七等奖"
           },
           {
             "stakeCount" : "774,634",
             "totalPrizeamount" : "11,619,510",
             "stakeAmount" : "15",
             "sort" : 100,
             "awardType" : 0,
             "prizeLevel" : "八等奖"
           },
           {
             "stakeCount" : "7,753,243",
             "totalPrizeamount" : "38,766,215",
             "stakeAmount" : "5",
             "sort" : 110,
             "awardType" : 0,
             "prizeLevel" : "九等奖"
           }
         ],
         "poolBalanceAfterdrawRj" : "",
         "lotteryGameNum" : "85",
         "lotteryDrawStatus" : 20,
         "totalSaleAmountRj" : "",
         "pdfType" : 1,
         "estimateDrawTime" : "",
         "lotteryDrawNum" : "20102",
         "lotterySuspendedFlag" : 0,
         "lotteryDrawTime" : "2020-10-17",
         "lotterySaleBeginTime" : "2020-10-14 20:10:00",
         "lotterySaleEndtime" : "2020-10-17 20:00:00",
         "termList" : [

         ],
         "lotteryPromotionFlag" : 0,
         "lotteryUnsortDrawresult" : "11+07+29+18+20 12+09",
         "isGetKjpdf" : 1,
         "isGetXlpdf" : 2,
         "totalSaleAmount" : "290,224,663",
         "ruleType" : 0,
         "lotteryEquipmentCount" : 1,
         "prizeLevelListRj" : [

         ]
       },
       {
         "drawFlowFundRj" : "",
         "matchList" : [

         ],
         "drawFlowFund" : "6214947.3",
         "lotteryGameName" : "超级大乐透",
         "poolBalanceAfterdraw" : "942,455,528.10",
         "verify" : 1,
         "lotteryDrawResult" : "03 04 05 09 34 07 09",
         "lotteryGamePronum" : 0,
         "prizeLevelList" : [
           {
             "stakeCount" : "5",
             "totalPrizeamount" : "50,000,000",
             "stakeAmount" : "10,000,000",
             "sort" : 10,
             "awardType" : 0,
             "prizeLevel" : "一等奖"
           },
           {
             "stakeCount" : "0",
             "totalPrizeamount" : "0",
             "stakeAmount" : "0",
             "sort" : 20,
             "awardType" : 0,
             "prizeLevel" : "一等奖(追加)"
           },
           {
             "stakeCount" : "109",
             "totalPrizeamount" : "12,916,609",
             "stakeAmount" : "118,501",
             "sort" : 30,
             "awardType" : 0,
             "prizeLevel" : "二等奖"
           },
           {
             "stakeCount" : "31",
             "totalPrizeamount" : "2,938,800",
             "stakeAmount" : "94,800",
             "sort" : 40,
             "awardType" : 0,
             "prizeLevel" : "二等奖(追加)"
           },
           {
             "stakeCount" : "164",
             "totalPrizeamount" : "1,640,000",
             "stakeAmount" : "10,000",
             "sort" : 50,
             "awardType" : 0,
             "prizeLevel" : "三等奖"
           },
           {
             "stakeCount" : "746",
             "totalPrizeamount" : "2,238,000",
             "stakeAmount" : "3,000",
             "sort" : 60,
             "awardType" : 0,
             "prizeLevel" : "四等奖"
           },
           {
             "stakeCount" : "15,575",
             "totalPrizeamount" : "4,672,500",
             "stakeAmount" : "300",
             "sort" : 70,
             "awardType" : 0,
             "prizeLevel" : "五等奖"
           },
           {
             "stakeCount" : "21,297",
             "totalPrizeamount" : "4,259,400",
             "stakeAmount" : "200",
             "sort" : 80,
             "awardType" : 0,
             "prizeLevel" : "六等奖"
           },
           {
             "stakeCount" : "34,331",
             "totalPrizeamount" : "3,433,100",
             "stakeAmount" : "100",
             "sort" : 90,
             "awardType" : 0,
             "prizeLevel" : "七等奖"
           },
           {
             "stakeCount" : "671,376",
             "totalPrizeamount" : "10,070,640",
             "stakeAmount" : "15",
             "sort" : 100,
             "awardType" : 0,
             "prizeLevel" : "八等奖"
           },
           {
             "stakeCount" : "6,811,718",
             "totalPrizeamount" : "34,058,590",
             "stakeAmount" : "5",
             "sort" : 110,
             "awardType" : 0,
             "prizeLevel" : "九等奖"
           }
         ],
         "poolBalanceAfterdrawRj" : "",
         "lotteryGameNum" : "85",
         "lotteryDrawStatus" : 20,
         "totalSaleAmountRj" : "",
         "pdfType" : 1,
         "estimateDrawTime" : "",
         "lotteryDrawNum" : "20101",
         "lotterySuspendedFlag" : 0,
         "lotteryDrawTime" : "2020-10-14",
         "lotterySaleBeginTime" : "2020-10-12 20:10:00",
         "lotterySaleEndtime" : "2020-10-14 20:00:00",
         "termList" : [

         ],
         "lotteryPromotionFlag" : 0,
         "lotteryUnsortDrawresult" : "03+09+34+04+05 09+07",
         "isGetKjpdf" : 1,
         "isGetXlpdf" : 2,
         "totalSaleAmount" : "270,291,174",
         "ruleType" : 0,
         "lotteryEquipmentCount" : 3,
         "prizeLevelListRj" : [

         ]
       },
       {
         "drawFlowFundRj" : "",
         "matchList" : [

         ],
         "drawFlowFund" : "22330469.62",
         "lotteryGameName" : "超级大乐透",
         "poolBalanceAfterdraw" : "936,240,580.80",
         "verify" : 1,
         "lotteryDrawResult" : "04 05 08 22 33 07 10",
         "lotteryGamePronum" : 0,
         "prizeLevelList" : [
           {
             "stakeCount" : "4",
             "totalPrizeamount" : "40,000,000",
             "stakeAmount" : "10,000,000",
             "sort" : 10,
             "awardType" : 0,
             "prizeLevel" : "一等奖"
           },
           {
             "stakeCount" : "0",
             "totalPrizeamount" : "0",
             "stakeAmount" : "0",
             "sort" : 20,
             "awardType" : 0,
             "prizeLevel" : "一等奖(追加)"
           },
           {
             "stakeCount" : "69",
             "totalPrizeamount" : "11,128,803",
             "stakeAmount" : "161,287",
             "sort" : 30,
             "awardType" : 0,
             "prizeLevel" : "二等奖"
           },
           {
             "stakeCount" : "50",
             "totalPrizeamount" : "6,451,450",
             "stakeAmount" : "129,029",
             "sort" : 40,
             "awardType" : 0,
             "prizeLevel" : "二等奖(追加)"
           },
           {
             "stakeCount" : "121",
             "totalPrizeamount" : "1,210,000",
             "stakeAmount" : "10,000",
             "sort" : 50,
             "awardType" : 0,
             "prizeLevel" : "三等奖"
           },
           {
             "stakeCount" : "535",
             "totalPrizeamount" : "1,605,000",
             "stakeAmount" : "3,000",
             "sort" : 60,
             "awardType" : 0,
             "prizeLevel" : "四等奖"
           },
           {
             "stakeCount" : "12,778",
             "totalPrizeamount" : "3,833,400",
             "stakeAmount" : "300",
             "sort" : 70,
             "awardType" : 0,
             "prizeLevel" : "五等奖"
           },
           {
             "stakeCount" : "19,546",
             "totalPrizeamount" : "3,909,200",
             "stakeAmount" : "200",
             "sort" : 80,
             "awardType" : 0,
             "prizeLevel" : "六等奖"
           },
           {
             "stakeCount" : "31,100",
             "totalPrizeamount" : "3,110,000",
             "stakeAmount" : "100",
             "sort" : 90,
             "awardType" : 0,
             "prizeLevel" : "七等奖"
           },
           {
             "stakeCount" : "603,158",
             "totalPrizeamount" : "9,047,370",
             "stakeAmount" : "15",
             "sort" : 100,
             "awardType" : 0,
             "prizeLevel" : "八等奖"
           },
           {
             "stakeCount" : "6,419,807",
             "totalPrizeamount" : "32,099,035",
             "stakeAmount" : "5",
             "sort" : 110,
             "awardType" : 0,
             "prizeLevel" : "九等奖"
           }
         ],
         "poolBalanceAfterdrawRj" : "",
         "lotteryGameNum" : "85",
         "lotteryDrawStatus" : 20,
         "totalSaleAmountRj" : "",
         "pdfType" : 1,
         "estimateDrawTime" : "",
         "lotteryDrawNum" : "20100",
         "lotterySuspendedFlag" : 0,
         "lotteryDrawTime" : "2020-10-12",
         "lotterySaleBeginTime" : "2020-10-10 20:10:00",
         "lotterySaleEndtime" : "2020-10-12 20:00:00",
         "termList" : [

         ],
         "lotteryPromotionFlag" : 0,
         "lotteryUnsortDrawresult" : "33+22+05+08+04 10+07",
         "isGetKjpdf" : 1,
         "isGetXlpdf" : 2,
         "totalSaleAmount" : "274,948,701",
         "ruleType" : 0,
         "lotteryEquipmentCount" : 1,
         "prizeLevelListRj" : [

         ]
       }
     ],
     "pageSize" : 5,
     "total" : 5,
     "pageNo" : 1
   },
   "emptyFlag" : false,
   "errorCode" : "0",
   "dataFrom" : ""
 }
 
 */
