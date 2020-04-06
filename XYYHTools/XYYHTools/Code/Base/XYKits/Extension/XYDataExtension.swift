//
//  XYDataListExtension+Protocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/16.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYDataListExtension {
    
    var count: Int { get }
    
    var description: String { get }
    
    associatedtype SelfType
    
}

extension XYDataListExtension {
    
    //非空判断
    public var isNotEmpty: Bool {
        
        return (0 < self.count)
    }
    
    func toData(options : JSONSerialization.WritingOptions = []) -> Data? {
        
        /*  JSONSerialization.WritingOptions
         *
         *  prettyPrinted : 获取的json数据有良好的格式化，方便阅读
         *  如：
         *  {
         *      "name" : "xiaoxin",
         *      "address" : [
         *      "province: test",
         *      "city: test"
         *      ]
         *  }
         *  {"name":"xiaoxin","address":["province: test","city: test"]}
         *
         *  sortedKeys : 该选项只有iOS11才提供，按照文档描述，使用该选项会对字典中的keys进行排序
         *
         *
         *
         */
        guard let dicData = try? JSONSerialization.data(withJSONObject: self, options: options) else {
            
            return nil
        }
        
        return dicData
    }
    
    /**
     *    @description 转成Json字符串
     *
     *    @return   Json字符串
     */
    func toJsonString(options : JSONSerialization.WritingOptions = []) -> String? {
        
        guard self.isNotEmpty,
            let data = self.toData(options : options),
            let jsonStr = String(data: data, encoding: String.Encoding.utf8) else { return nil }
        
        return jsonStr.replacingOccurrences(of: "\\/", with: "/")
    }
}

//Create
extension XYDataListExtension {
    
    /**
     *    @description 解析data(Json格式数据)为指定的数据
     *
     *    @param    <#参数#>    <#参数说明#>
     *
     *    @return   <#返回说明#>
     */
    static func CreateWith(jsondata dataOrNil : Data?) -> Self? {
        
        /*  JSONSerialization.ReadingOptions
         *
         *  mutableContainer : 允许将数据解析成json对象后，修改其中的数据
         *
         *  mutableLeaves : 使解析出来的json对象的叶子节点的属性变为NSMutableString
         *
         *  allowFragments : 这个参数平常用的比较多，他允许被解析的json数据不是array或者dic包裹，可以是单个string值
         *
         */
        
        guard let data = dataOrNil,
            let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments),
            let typeObj = object as? Self else { return nil }
        
        return typeObj
    }
    
    //根据json格式的String对象返回对象
    static func CreateWith(jsonString:String) -> Self? {
        
        guard let jsonData = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false),
            let jsonObj = self.CreateWith(jsondata: jsonData) else {
                
                return nil
        }
        
        return jsonObj
    }
}

extension XYDataListExtension {
    
    /**
     *    @description 保存数据到指定Json文件
     *
     */
    @discardableResult func saveJsonTo(filePath: String) -> Bool {
        
        guard let data = self.toData(options: [.prettyPrinted]) else { return false }
        
        return XYFileManager.CreateFile(atPath: filePath, contents: data, attributes: nil)
    }
}

extension XYDataListExtension {
    
    /**
     *    @description 日志输出
     *
     */
    func jsonDescription() -> String {
        
        guard let jsonStr = self.toJsonString(options: [.prettyPrinted]) else {
            
            var des = self.description
            if des.count < 10 {
                
                des = "\(self)"
            }
            
            return des
        }
        
        return jsonStr
    }
    
    /**
     *    @description Json格式打印
     *
     */
    func logJsonDescription() {
        
        XYLog.LogNoteBlock { () -> String? in
            
            return self.jsonDescription()
        }
    }
}
