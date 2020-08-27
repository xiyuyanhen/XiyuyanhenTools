//
//  XYWDBManager.swift
//  XYWCDBDemo
//
//  Created by Xiyuyanhen on 2018/7/23.
//  Copyright © 2018年 Xiyuyanhen. All rights reserved.
//

import Foundation
import WCDBSwift

// MARK: - 数据库
enum XYWDataBase: String, DataBaseProtocol {
    /// 沙盒document路径
    fileprivate static let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    fileprivate static let dbMainDirName = "XY_WCDB_DB"

    case Log = "XY_WCDB_Log.db"
    case Bmob = "XY_WCDB_Bmob.db"
    
    /// 数据库文件路径
    var path: String {
        
        switch self {
        case .Log, .Bmob:
            return "\(XYWDataBase.documentPath)/\(XYWDataBase.dbMainDirName)/\(self.rawValue)"
        }
    }
    
    /// 数据库标签
    var tag: Int {
        switch self {
        case .Log: return 1
        case .Bmob: return 2
        }
    }
    
    /// 真实数据库
    var db: Database {
        
        let db = Database(withPath: self.path)
        db.tag = self.tag
        return db
    }
}

// MARK: - 数据表
enum XYWTableName: String, TableNameProtocol {
    
    case logMsg = "WCDB_XYLogMsg"
    case BmobBaseObjectDemo = "XYBmobBaseObjectDemo"
    case TableName_大乐透 = "Daletou"

    /// 表对应的数据库
    var dataBase: Database {
        switch self {
        case .logMsg: return XYWDataBase.Log.db
        case .BmobBaseObjectDemo, .TableName_大乐透: return XYWDataBase.Bmob.db
        }
    }
    
    /// 查询子，提前做好查询对象创建
    var select: Select? {
        var select: Select?
        switch self {
            
        case .logMsg:
            select = try? dataBase.prepareSelect(of: WCDB_XYLogMsg.self, fromTable: self.name, isDistinct: true)
            break
            
        case .BmobBaseObjectDemo:
            select = try? dataBase.prepareSelect(of: XYBmobBaseObjectDemo.self, fromTable: self.name, isDistinct: true)
            break
            
        case .TableName_大乐透:
            select = try? dataBase.prepareSelect(of: XYBmobObject_大乐透.self, fromTable: self.name, isDistinct: true)
            break
        }
        
        return select
    }

    /// 具体的表名
    var name: String {
        return rawValue
    }
}

class XYWDBManager: NSObject {
    
    static let `default` = XYWDBManager()
    /// 数据库与表的初始化
    /// 文件创建，默认表数据设置
    override init() {
        super.init()
        
        XYWDBManager.CreateDBAndTable()
    }
    
    class func CreateDBAndTable() {
        
        do {
            // create if not exit
        
            
            try XYWDataBase.Log.db.run(transaction: {
                
                try XYWDataBase.Log.db.create(table: XYWTableName.logMsg.name, of: WCDB_XYLogMsg.self)
            })
            
            try XYWDataBase.Bmob.db.run(transaction: {
                
                try XYWDataBase.Bmob.db.create(table: XYWTableName.BmobBaseObjectDemo.name, of: XYBmobBaseObjectDemo.self)
            })
            
            try XYWDataBase.Bmob.db.run(transaction: {
                
                try XYWDataBase.Bmob.db.create(table: XYWTableName.TableName_大乐透.name, of: XYBmobObject_大乐透.self)
            })
            
        } catch {
            
            XYDispatchQueueType.Main.xyAsync {
                
                ShowSingleBtnAlertView(title: "数据库初始化失败!", message: "")
            }
        }
    }
}

extension XYWDBManager: DBManagerProtocol {
    
    typealias ErrorType = (WCDBSwift.Error?)->Void
    typealias SuccessType = ()->Void
    
    class func update<Object>(_ table: TableNameProtocol, object: Object, propertys: [PropertyConvertible], conditioin: Condition? = nil , errorClosure: ErrorType? = nil, successClosure: SuccessType? = nil ) where Object: TableEncodable {
        
        WCDBManager.default.update(table.dataBase, table: table.name, object: object, propertys: propertys, conditioin: conditioin, errorClosure: errorClosure, successClosure: successClosure)
    }
    
    class func insert<Object>(_ table: TableNameProtocol, objects: [Object], errorClosure: ErrorType? = nil, successClosure: SuccessType? = nil) where Object: TableEncodable {
        WCDBManager.default.insert(table.dataBase, table: table.name, objects: objects, errorClosure: errorClosure, successClosure: successClosure)
    }
    
    class func select<Object>(_ table: TableNameProtocol, conditioin: Condition? = nil, errorClosure: ErrorType?) -> [Object]? where Object: TableEncodable {
        return WCDBManager.default.select(table.select, conditioin: conditioin, errorClosure: errorClosure)
    }
    
    class func delete(_ table: TableNameProtocol, conditioin: Condition?, errorClosure: DBManagerProtocol.ErrorType?) {
        WCDBManager.default.delete(table.dataBase, table: table.name, condition: conditioin, errorClosure: errorClosure)
    }
    
    class func insertOrReplace<Object>(_ table: TableNameProtocol, objects: [Object], errorClosure: DBManagerProtocol.ErrorType?, successClosure: DBManagerProtocol.SuccessType?) where Object : TableEncodable {
        WCDBManager.default.insertOrReplace(table.dataBase, table: table.name, objects: objects, errorClosure: errorClosure, successClosure: successClosure)
    }
}
