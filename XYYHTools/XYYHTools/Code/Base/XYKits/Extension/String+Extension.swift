//
//  String+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/8/29.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension String {
    
    /**
     *    @description 字符串长度不为空
     *
     */
    var isNotEmpty: Bool {
        
        return (self.isEmpty == false)
    }
    
    var allRange : Range<String.Index> {
        
        return self.index(self.startIndex, offsetBy: 0) ..< self.endIndex
    }
    
    var allNSRange : NSRange {
        
        return NSRange(self.allRange, in: self)
    }
    
    func rangeIndex(fromlocation location: Int) -> Range<String.Index> {
        
        let startIndex = self.index(self.startIndex, offsetBy: location)
        let endIndex = self.endIndex
        
        let range = startIndex ..< endIndex
        
        return range
    }
    
    func rangeIndex(location: Int, length: Int) -> Range<String.Index> {
        
        let startIndex = self.index(self.startIndex, offsetBy: location)
        let endIndex = self.index(self.startIndex, offsetBy: location + length)
        
        return (startIndex ..< endIndex)
    }
    
    func xyRangeIndex(range rangeOrNil: NSRange?) -> Range<String.Index>? {
        
        guard let range = rangeOrNil else { return nil }
        
        return Range(range, in: self)
    }
    
    /// range转换为NSRange
    func xyNSRange(from range: Range<String.Index>) -> NSRange {

        return NSRange(range, in: self)
    }
    
    func xyNSRange(rangeOrNil: Range<String.Index>?) -> NSRange? {
        
        guard let range = rangeOrNil else { return nil }
        
        return NSRange(range, in: self)
    }
    
    /**
     *    @description 获取当前字符串以startIndex开始的空Substring
     *
     *
     *    @return   Substring
     */
    private func emptySubstring() -> Substring {
        
        let startIndex = self.startIndex
        let endIndex = self.index(startIndex, offsetBy: 0)
        
        let substring = self[startIndex ..< endIndex]
        
        return substring
    }
    
    // MARK: - 前后去空格
    /**
     *    @description 前后去空格
     */
    func trimmingWhiteSpace() -> String {
        
        let newString = self.trimmingCharacters(in: CharacterSet.whitespaces)
        
        return newString
    }
    
    /**
     *    @description 前后去空格与换行符
     *
     */
    func trimmingWhiteSpaceAndNewLines() -> String {
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // MARK: - 首和末尾去换行
    /**
     *    @description 首和末尾去换行
     */
    func trimmingWrap() -> String {
        
        var newString = self
        
        while newString.headerIsWrap() {
            
            newString = newString.slice(type: .IndexAfter, num: 0)
        }
        
        while newString.footerIsWrap() {
            
            newString = newString.slice(type: .Header, num: newString.count-1)
        }
        
        return newString
    }
    
    // MARK: - 末尾去换行
    /**
     *    @description 末尾去换行
     */
    func trimmingFooterWrap() -> String {
        
        var newString = self
        
        while newString.footerIsWrap() {
            
            newString = newString.slice(type: .Header, num: newString.count-1)
        }
        
        return newString
    }
    
    // MARK: - 首字符是否为换行符
    /**
     *    @description 首字符是否为换行符
     */
    func headerIsWrap() -> Bool {
        
        let headerStr : String = self.slice(type: .Header, num: 1)
        
        let result : Bool = (headerStr == "\n")
        

        
        return result
    }
    
    // MARK: - 末尾字符是否为换行符
    /**
     *    @description 末尾字符是否为换行符
     */
    func footerIsWrap() -> Bool {
        
        let lastStr : String = self.slice(type: .Footer, num: 1)
        
        let result : Bool = (lastStr == "\n")
        

        
        return result
    }
    
    // MARK: - 是否包含字符串数组中任一字符串
    /**
     *    @description 是否包含字符串数组中任一字符串
     *
     *    @param    strArr    字符串数组
     *
     *    @return   是否包含字符串数组中任一字符串
     */
    func contains(strArr: [String]) -> Bool {
        
        guard 0 < strArr.count else {
            
            return false
        }
        
        for subStr in strArr {
            
            guard 0 < subStr.count else { continue }
            
            guard self.contains(subStr) else { continue }
            
            return true
        }
        
        return false
    }
    
    // MARK: - 替换多个字符串
    /**
     *    @description 替换多个字符串
     *
     *    @param    replacingDic    字符串对
     *
     *    @return   替换多个字符串
     */
    func replacingMultiple(replacingDic: [String: String]) -> String {
    
        guard self.isNotEmpty else { return "" }
        
        var resultStr : String = self
        
        for subReplacingStrKey in replacingDic.keys {
            
            guard subReplacingStrKey.isNotEmpty else { continue }
            
            guard let subReplacingStrValue : String = replacingDic[subReplacingStrKey] else { continue }
            
            resultStr = resultStr.replacingOccurrences(of: subReplacingStrKey, with: subReplacingStrValue)
        }
        
        return resultStr
    }
    
    func removeMultiple(textArr : [String]) -> String {
        
        guard textArr.isNotEmpty else { return self }
        
        var replacingDic = [String: String]()
       
        for subText in textArr {
            
            guard subText.isNotEmpty else { continue }
            
            replacingDic[subText] = ""
        }
       
        return self.replacingMultiple(replacingDic: replacingDic)
    }
    
    // MARK: - 根据正则表达式检索相应的Substring数组
    /**
     *    @description 根据正则表达式检索相应的Substring数组
     *
     *    @param    pattern    正则表达式
     *
     *    @return   Substring数组
     */
    func matches(pattern: String) -> [Substring]? {
        
        guard 0 < self.count else { return nil }
        
        //实现方法一:
        /*
        let searchStartIndex : String.Index = self.startIndex
        let searchEndIndex : String.Index = self.endIndex
        
        var searchRange : Range<String.Index> = searchStartIndex..<searchEndIndex
        
        var searchResultArr : [Substring] = [Substring]()
        while searchRange.lowerBound != searchRange.upperBound {
            
            if let subResultRange : Range<String.Index> = self.range(of: pattern, options: .regularExpression, range: searchRange, locale: nil) {
                
                let subResultSubstring : Substring = self[subResultRange]
//                let subResultString : String = String(subResultSubstring)

                
                searchResultArr.append(subResultSubstring)
                
                searchRange = subResultRange.upperBound..<searchEndIndex
                
            }else{
                
                searchRange = searchRange.upperBound..<searchEndIndex
            }
        }
         */
        
        //实现方法二:
        guard let regex = try? NSRegularExpression(pattern: pattern, options:[]) else { return nil }
            
        let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex...,in: self))
        
        guard 0 < matches.count else { return nil }
        
        var searchResultArr : [Substring] = [Substring]()
        
        //解析出子串
        for  match in matches {
            
            let matchRange : NSRange = match.range
            
            guard let substring : Substring = self.slice(nsrange: matchRange) else { continue }

//            let matchStr : String = String(substring)

            
            searchResultArr.append(substring)
        }
        
        guard 0 < searchResultArr.count else { return nil }
        
        return searchResultArr
    }
    
}

extension String {
    
    static func Float(num: Float, decimalLength: UInt = 0) -> String {
        
        let str : String = String(format: "%.\(decimalLength)f", num)
        
        return str
    }
    
    //若小数部分为0，则去掉小数部分和.
    static func FloatShortestDecimal(num: Float, decimalLength: UInt = 0) -> String {
        
        var str : String = String.Float(num: num, decimalLength: decimalLength)
        
        str = str.trimmingEndZeroAndDot()
        
        return str
    }
    
    /// 解析分割小数字符串的整数与小数部份
    func separateToIntegerAndDecimal(defaultDecimal: String = "0") -> (integer: String, decimal: String) {
        
        let separateArr = self.components(separatedBy: ".")
        guard 2 <= separateArr.count else {
            
            return (integer: self, decimal: defaultDecimal)
        }
        
        return (integer: separateArr[0], decimal: separateArr[1])
    }
    
    /// 解析分割特定选项字符串的序号与内容 (例: A. apple. -> (index: A, content: apple.))
    func separateIndexByChoiceText(separatedBy: String = ".") -> (index: String, content: String)? {
        
        guard let range: Range<String.Index> = self.xySearchTextRange(searchText: separatedBy,searchRange: nil) else { return nil }
        
        let index = String(self[self.startIndex ..< range.lowerBound])
        
        let content = String(self[range.upperBound ..< self.endIndex])
        
        return (index: index, content: content)
    }
    
}

// MARK: - 字符切割
extension String {
    
    /**
     *    @description 获取当前字符串以startIndex开始, endIndex结束的Substring
     *
     *
     *    @return   Substring
     */
    private func allSubstring() -> Substring {
        
        let substring : Substring = self[self.startIndex ..< self.endIndex]
        
        return substring
    }
    
    //切割方式
    enum SliceType {
        case IndexBefore //指定位置之前
        case Index       //指定位置
        case IndexAfter  //指定位置之后
        case Header      //头
        case Footer      //尾
    }
    
    /**
     *    @description 根据切割方式及长度/位置切割Substring
     *
     *    @param    type    切割方式
     *
     *    @param    num    长度/位置
     *
     *    @return   切割结果Substring
     */
    private func sliceSubstring(type: SliceType, num:Int) -> Substring {
        
        guard (0 <= num) else { return self.emptySubstring() }
        
        let start : String.Index
        let end : String.Index
        let substring : Substring
        
        switch type {
        case .IndexBefore:
            
            guard num < self.count else { return self.allSubstring() }
            
            start = self.startIndex
            end = self.index(self.startIndex, offsetBy: num)
            substring = self[start ..< end]
            
            break
            
        case .Index:
            
            guard num < self.count else { return self.allSubstring() }
            
            start = self.index(self.startIndex, offsetBy: num)
            end = self.index(self.startIndex, offsetBy: num)
            substring = self[start ... end]
            
            break
            
        case .IndexAfter:
            
            guard num < self.count else { return self.allSubstring() }
            
            start = self.index(self.startIndex, offsetBy: num+1)
            end = self.endIndex
            substring = self[start ..< end]
            
            break
            
        case .Header:
            
            guard num <= self.count else { return self.allSubstring() }
            
            start = self.startIndex
            end = self.index(self.startIndex, offsetBy: num)
            substring = self[start ..< end]
            
            break
            
        case .Footer:
            
            guard num <= self.count else { return self.allSubstring() }
            
            start = self.index(self.endIndex, offsetBy: -num)
            end = self.endIndex
            substring = self[start ..< end]
            
            break
        }
        
        /*
         //TestCode
         
         let str = "Hello, playground"
         
         let indexBeforeSubStr00 : String = str.slice(type: .IndexBefore, num: -1)
         let indexBeforeSubStr01 : String = str.slice(type: .IndexBefore, num: 0)
         let indexBeforeSubStr02 : String = str.slice(type: .IndexBefore, num: 5)
         let indexBeforeSubStr03 : String = str.slice(type: .IndexBefore, num: 17)
         let indexBeforeSubStr04 : String = str.slice(type: .IndexBefore, num: 20)
         
         let indexSubStr00 : String = str.slice(type: .Index, num: -1)
         let indexSubStr01 : String = str.slice(type: .Index, num: 0)
         let indexSubStr02 : String = str.slice(type: .Index, num: 5)
         let indexSubStr03 : String = str.slice(type: .Index, num: 17)
         let indexSubStr04 : String = str.slice(type: .Index, num: 20)
         
         let indexAfterSubStr00 : String = str.slice(type: .IndexAfter, num: -1)
         let indexAfterSubStr01 : String = str.slice(type: .IndexAfter, num: 0)
         let indexAfterSubStr02 : String = str.slice(type: .IndexAfter, num: 5)
         let indexAfterSubStr03 : String = str.slice(type: .IndexAfter, num: 17)
         let indexAfterSubStr04 : String = str.slice(type: .IndexAfter, num: 20)
         
         let HeaderSubStr00 : String = str.slice(type: .Header, num: -1)
         let HeaderSubStr01 : String = str.slice(type: .Header, num: 0)
         let HeaderSubStr02 : String = str.slice(type: .Header, num: 5)
         let HeaderSubStr03 : String = str.slice(type: .Header, num: 17)
         let HeaderSubStr04 : String = str.slice(type: .Header, num: 20)
         
         let FooterSubStr00 : String = str.slice(type: .Footer, num: -1)
         let FooterSubStr01 : String = str.slice(type: .Footer, num: 0)
         let FooterSubStr02 : String = str.slice(type: .Footer, num: 5)
         let FooterSubStr03 : String = str.slice(type: .Footer, num: 17)
         let FooterSubStr04 : String = str.slice(type: .Footer, num: 20)
         */
        return substring
    }
    
    /**
     *    @description 根据切割方式及长度/位置切割字符串
     *
     *    @param    type    切割方式
     *
     *    @param    num    长度/位置
     *
     *    @return   切割的字符串
     */
    func slice(type: SliceType, num:Int) -> String {
        
        let sliceSubstring : Substring = self.sliceSubstring(type: type, num: num)
        
        let sliceStr : String = String(sliceSubstring)
        
        return sliceStr
    }
    
    /**
     *    @description 截取指定范围
     *
     *    @param    range    截取范围
     *
     *    @return   Substring?
     */
    func slice(nsrange: NSRange) -> Substring?{
        
        guard let strIndex = Range(nsrange, in: self) else { return nil }
        
        let substr : Substring = self[strIndex]
        
        return substr
    }
    
    /**
     *    @description 截取指定范围的内容
     *
     *    @param    range    截取范围
     *
     *    @return   String?
     */
    func slice(nsrange: NSRange) -> String? {
        
        guard let substring : Substring = self.slice(nsrange: nsrange) else { return nil }
        
        let sliceStr : String = String(substring)
        
        return sliceStr
    }
    
    func slice(range: Range<String.Index>) -> Substring {
        
        let result = self[range]
        
        return result
    }
    
    func slice(range: Range<String.Index>) -> String {
        
        let subStr : Substring = self.slice(range: range)
        
        let result : String = String(subStr)
        
        return result
    }
    
    func trimmingHeader(num : Int = 1) -> String {
        
        let newString : String = self.slice(type: .Footer, num: num)
        
        return newString
    }
    
    func trimmingFooter(num : Int = 1) -> String {
        
        let count = self.count
        
        let newString : String = self.slice(type: .Header, num: count-num)
        
        return newString
    }
    
    //remove
    
    func remove(nsRange: NSRange) -> String {
        
        let headString : String = self.slice(type: .IndexBefore, num: nsRange.location)
        let endString : String = self.slice(type: .IndexAfter, num: nsRange.location+nsRange.length-1)
        
        let newString = "\(headString)\(endString)"
        
        return newString
    }
    
    /**
     *    @description 去掉\r (出现\r\n时，检索相关方法会出现偏差)
     *
     */
    func removeR() -> String {
        
        return self.replacingMultiple(replacingDic: ["\r\n": "\n",
                                                     "\n\r": "\n",
                                                     "\r": "\n"])
    }
    
    func replacing(nsRange: NSRange, countNum : Int, splitter : String = "|") -> String {
        
        let headString : String = self.slice(type: .IndexBefore, num: nsRange.location)
        let endString : String = self.slice(type: .IndexAfter, num: nsRange.location+nsRange.length-1)
        
        var newStr : String = ""
        var count = countNum
        while 0 < count {
            
            newStr += splitter
            count -= 1
        }
    
        let newString = "\(headString)\(newStr)\(endString)"
        
        return newString
    }
    
//    func mixing(mixStr: String) -> String {
//
//        var result : String = self
//        var location : Int = self.count - 1
//
//        while 0 <= location  {
//
//            result = result.inset
//        }
//
//    }
    
    var isAllUppercase : Bool {

        return self.predicateEvaluate(type: .Uppercase)
    }
    
    var isAllLowercase : Bool {
        
        return self.predicateEvaluate(type: .Lowercase)
    }
    
    /**
     *    @description 字符前后填补相同数量的占位字符
     *
     *    @param    placeHolder    占位字符
     *
     *    @param    count    填补占位字符的总数量
     *
     *    @return   填补后的字符串
     */
    func fillPlaceHolderForHeaderAndFooter(placeHolder: String, count: Int) -> String {
        
        guard 0 < count else { return self }
        
        let header : Int = count/2
        let footer : Int = count - header
        
        return self.fillPlaceHolder(placeHolder: placeHolder, header: header, footer: footer)
    }
    
    /**
     *    @description 在前后填补指定数量的占位字符
     *
     *    @param    placeHolder    占位字符
     *
     *    @param    header    头部填补数量
     *
     *    @param    footer    尾部填补数量
     *
     *    @return   填补后的字符串
     */
    func fillPlaceHolder(placeHolder: String, header: Int, footer: Int) -> String {
        
        var result : String = self
        
        if 0 < header {
            
            var count = header
            while 0 < count {
                
                result = "\(placeHolder)\(result)"
                count -= 1
            }
        }
        
        if 0 < footer {
            
            var count = footer
            while 0 < count {
                
                result += placeHolder
                count -= 1
            }
        }
        
        return result
    }
}



extension String {
    
    func trimmingEndZeroAndDot() -> String {
        
        guard self.contains(".") else { return self }
        
        var newString = self
        
        while newString.endStringIs(str: "0") {
            
            newString = newString.trimmingFooter()
            
            guard newString.endStringIs(str: ".") else { continue }
            
            newString = newString.trimmingFooter()
            break
        }
        
        return newString
    }
    
    // MARK: - 末尾字符是否为str
    /**
     *    @description 末尾字符是否为str
     */
    private func endStringIs(str: String, count: Int = 1) -> Bool {
        
        let endStr : String = self.slice(type: .Footer, num: count)
        
        let result : Bool = (endStr == str)
        
        return result
    }
    
    /**
     *    @description 将时间转换为 00:00(分:秒) 格式字符串
     *
     *    @param    time    时间
     *
     *    @return   00:00(分:秒) 格式字符串
     */
    static func TimeIntervalString(time timeInterval: TimeInterval) -> String {
        
        let time = Int32(timeInterval)
        
        var min = String(time/60)
        min = min.count > 1 ? min : "0"+min
        
        var sec = String(time%60)
        sec = sec.count > 1 ? sec : "0"+sec
        
        let timeString = min+":"+sec
        
        return timeString
    }
    
    var timeIntervalOrNil: TimeInterval? {
        
        let times = self.components(separatedBy: ":")
        
        guard let secStr = times.last,
            let sec = secStr.toDoubleOrNil else { return nil }
        
        guard let minStr = times.elementByIndex(times.count - 2),
            let min = minStr.toDoubleOrNil else { return sec }
        
        return min*60.0 + sec
    }
    
    /**
     *    @description 根据时间获取一个精确至微秒的时间戳字符串
     *
     *    @param    date    时间值
     *
     *    @return   时间戳字符串
     */
    static func MicroSecondString(date : Date = Date()) -> String {
        
        /// Since1970的微秒级计数值
        let nowTimeInterval = TimeInterval(date.timeIntervalSince1970 * 1000000.0)
        
        /// 不需要那么多位，故减去一个参考数值
        let nowtime = TimeInterval(nowTimeInterval - 1483200000000000)
        
        /// 取整
        let theTime = Int64(nowtime)
        
        return "\(theTime)"
    }
    
    /// 所有字符之间都穿插一个换行符(类似文字竖行的显示效果)
    var insertInterval_Wrap : String {
        
        return self.insertInterval("\n")
    }
    
    /**
     *    @description 在每个字符之间穿插指定字符
     *
     *    @param    intervalStr    用于穿插的指定字符
     *
     *    @return   穿插后的字符
     */
    func insertInterval(_ intervalStr : String) -> String {
        
        guard 1 < self.count else { return self }
        
        let result = NSMutableString(string: self)
        
        var index = self.count - 1
        while 0 < index {
            
            result.insert("\(intervalStr)", at: index)
            index -= 1
        }
        
        return result as String
    }
}

// MARK: - 汉字处理相关方法
extension String {

    // MARK: - 判断字符串中是否有中文
    /**
     *    @description 判断字符串中是否有中文
     *
     */
    func isIncludeChinese() -> Bool {
        
        for ch in self.unicodeScalars {
            
            if (0x4e00 < ch.value  && ch.value < 0x9fff){
                // 中文字符范围：0x4e00 ~ 0x9fff
                
                return true
            }
        }
        
        return false
    }
    
    // MARK: - 汉字字符串转拼音字符串
    /**
     *    @description 汉字字符串转拼音字符串
     *
     *    @param    cString    汉字字符串
     *
     *    @param    isRemoveSymbol    是否移除声调(default: true)
     *
     *    @return   拼音字符串
     */
    func letterFromChineseString(isRemoveTone: Bool = true) -> String {
        
        guard IsValidateString(string: self) else {
            
            return ""
        }
        
        // 注意,这里一定要转换成可变字符串
        let mutableString = NSMutableString.init(string: self)
        
        // 将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        
        guard isRemoveTone else {
            
            return mutableString as String
        }
        
        // 去掉声调(用此方法大大提高遍历的速度)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        
        return pinyinString
    }
    
    // MARK: - 获取姓名首字母(传入汉字字符串, 返回大写拼音首字母)
    /**
     *    @description 获取姓名首字母(传入汉字字符串, 返回大写拼音首字母)
     *
     *    @param    aString    汉字字符串
     *
     *    @return   大写拼音首字母
     */
    func firstLetterFromChineseString() -> String {
        
        // 将中文转换成不带声调的拼音
        let pinyinString = self.letterFromChineseString()
        
        // 替换多音字拼音
        let polyphoneString = polyphoneStringHandle(nameString: self, pinyinString: pinyinString)
        
        // 截取首字母
        let firstString : String = polyphoneString.slice(type: .Header, num: 1)
        
        // 将拼音首字母换成大写
        let firstUppercasedStr = firstString.uppercased()
        
        // 判断姓名首位是否为大写字母
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        
        if predA.evaluate(with: firstUppercasedStr) {
            
            return firstUppercasedStr
        }
        
        return "#"
    }
    
    /// 多音字处理
    private func polyphoneStringHandle(nameString:String, pinyinString:String) -> String {
        
        if nameString.hasPrefix("长") {return "chang"}
        else if nameString.hasPrefix("沈") {return "shen"}
        else if nameString.hasPrefix("厦") {return "xia"}
        else if nameString.hasPrefix("地") {return "di"}
        else if nameString.hasPrefix("重") {return "chong"}
        
        return pinyinString
    }
}

// MARK: - Search 检索
extension String {
    
    /**
     *    @description 检索字符位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(Range<String.Index>?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置(Range<String.Index>?)
     */
    func xySearchTextRange(searchText: String, searchRange searchRangeOrNil: Range<String.Index>? = nil, options: String.CompareOptions = []) -> Range<String.Index>? {
        
        let resultRange = self.range(of: searchText, options: options, range: searchRangeOrNil, locale: nil)
        
        return resultRange
    }
    
    /**
     *    @description 检索字符位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(NSRange?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置(Range<String.Index>?)
     */
    func xySearchTextRange(searchText: String, searchNSRange searchNSRangeOrNil: NSRange? = nil, options: String.CompareOptions = []) -> Range<String.Index>? {
        
        return self.xySearchTextRange(searchText: searchText, searchRange: self.xyRangeIndex(range: searchNSRangeOrNil), options: options)
    }
    
    /**
     *    @description 检索字符位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(Range<String.Index>?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置(NSRange?)
     */
    func xySearchTextNSRange(searchText: String, searchRange searchRangeOrNil: Range<String.Index>?, options: String.CompareOptions = []) -> NSRange? {
        
        guard let range = self.xySearchTextRange(searchText: searchText, searchRange: searchRangeOrNil, options: options) else { return nil }
        
        return self.xyNSRange(from: range)
    }
    
    /**
     *    @description 检索字符位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(NSRange?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置(NSRange?)
     */
    func xySearchTextNSRange(searchText: String, searchNSRange searchNSRangeOrNil: NSRange?, options: String.CompareOptions = []) -> NSRange? {
        
        return self.xySearchTextNSRange(searchText: searchText, searchRange: self.xyRangeIndex(range: searchNSRangeOrNil), options: options)
    }
    
    /**
     *    @description 检索所有指定字符的位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(Range<String.Index>?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置([Range<String.Index>]?)
     */
    func xySearchTextRangeArr(searchText: String, searchRange searchRangeOrNil: Range<String.Index>? = nil, options: String.CompareOptions = []) -> [Range<String.Index>]? {
        
        var searchingRange : Range<String.Index>
        
        if let searchRange = searchRangeOrNil {
            
            searchingRange = searchRange
        }else {
            
            searchingRange = self.allRange
        }
        
        var resultArr: [Range<String.Index>] = [Range<String.Index>]()
        
        while let searchedRange = self.xySearchTextRange(searchText: searchText, searchRange: searchingRange, options: options) {
            
            resultArr.append(searchedRange)
            
            //调整检索范围
            if options.contains(.backwards) {
                
                // 从末尾检索
                searchingRange = searchingRange.lowerBound ..< searchedRange.lowerBound
                
            }else {
                
                searchingRange = searchedRange.upperBound ..< searchingRange.upperBound
            }
        }
        
        guard resultArr.isNotEmpty else { return nil }
        
        return resultArr
    }
    
    /**
     *    @description 检索字符位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(NSRange?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置(Range<String.Index>?)
     */
    func xySearchTextRangeArr(searchText: String, searchNSRange searchNSRangeOrNil: NSRange? = nil, options: String.CompareOptions = []) -> [Range<String.Index>]? {
        
        return self.xySearchTextRangeArr(searchText: searchText, searchRange: self.xyRangeIndex(range: searchNSRangeOrNil), options: options)
    }
    
    /**
     *    @description 检索所有指定字符的位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(Range<String.Index>?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置([NSRange]?)
     */
    func xySearchTextNSRangeArr(searchText: String, searchRange searchRangeOrNil: Range<String.Index>?, options: String.CompareOptions = []) -> [NSRange]? {
        
        guard let rangeArr = self.xySearchTextRangeArr(searchText: searchText, searchRange: searchRangeOrNil, options: options) else { return nil }
        
        var resultArr: [NSRange] = [NSRange]()
        
        for range in rangeArr {
            
            resultArr.append(self.xyNSRange(from: range))
        }
        
        return resultArr
    }
    
    /**
     *    @description 检索所有指定字符的位置
     *
     *    @param    searchText    检索字符
     *
     *    @param    searchRange    检索范围(NSRange?)
     *
     *    @param    options    检索参数
     *
     *    @return   字符位置([NSRange]?)
     */
    func xySearchTextNSRangeArr(searchText: String, searchNSRange searchNSRangeOrNil: NSRange?, options: String.CompareOptions = []) -> [NSRange]? {
        
        return self.xySearchTextNSRangeArr(searchText: searchText, searchRange: self.xyRangeIndex(range: searchNSRangeOrNil), options: options)
    }

}

// MARK: - 正则表达式校验
extension String {
    
    enum XYPredicateType {
        
        case None //无
        case Number //数字
        case NumAlphabet //数字、字母
        
        /// 密码允许的输入字符
        case Password
        
        /// 用户密码规则
        case UserPassword
        
        case Name //名字
        case Word //单词
        case Uppercase //单词大写
        case Lowercase //单词小写
        
        func predicateRegex(minNum:Int = 0, maxNum:Int = Int.max) -> String?{
            
            var regex:String = ""
            
            let newMaxNum:String
            if maxNum == Int.max {
                
                newMaxNum = ""
            }else {
                
                newMaxNum = "\(maxNum)"
            }
            
            switch self {
                
            case .Number:
                regex = "^[0-9]{\(minNum),\(newMaxNum)}$"
                break
                
            case .NumAlphabet:
                regex = "^[0-9A-Za-z]{\(minNum),\(newMaxNum)}$"
                break
                
            case .Password:
                regex = "^[0-9A-Za-z\\*\\.\\_\\#\\@\\$\\%\\&\\-\\+\\!]{\(minNum),\(newMaxNum)}$"
                break
                
            case .UserPassword: // 数字、字母至少各一位
                regex = "^(?=.*[0-9])(?=.*[a-zA-Z])(.{\(minNum),\(newMaxNum)})$"
                break
                
            case .Name:
                regex = "^[➋➌➍➎➏➐➑➒A-Za-z\\u4e00-\\u9fa5]{\(minNum),\(newMaxNum)}$"
                break
                
            case .Word:
                regex = "^[A-Za-z\\'\\’\\‘\\,\\.\\?\\!\\:]{\(minNum),\(newMaxNum)}$"
                break
                
            case .Uppercase:
                regex = "^[A-Z\\'\\’\\‘]{\(minNum),\(newMaxNum)}$"
                break
                
            case .Lowercase:
                regex = "^[a-z\\'\\’\\‘]{\(minNum),\(newMaxNum)}$"
                break
                
            default: return nil
            }
            
            return regex
        }
    }
    
    // MARK: - 校验验证码(4~6位的数字)
    /**
     *    @description 校验验证码(4~6位的数字)
     *
     */
    func predicateEvaluateVerificationCode() -> Bool {
        
        let result = self.predicateEvaluate(type: .Number, minNum: 4, maxNum: 6)
        
        return result
    }
    
    // MARK: - 校验手机号码(仅为11位数字)
    /**
     *    @description 校验手机号码(仅为11位数字)
     *
     */
    func predicateEvaluatePhone() -> Bool {
        
        let result = self.predicateEvaluate(type: .Number, minNum: 11, maxNum: 11)
        
        return result
    }
    
    
    /**
     *    @description 正则校验
     *
     */
    func predicateEvaluate(type:XYPredicateType, minNum:Int = 0, maxNum:Int = Int.max) -> Bool {
        
        guard let regexString = type.predicateRegex(minNum: minNum, maxNum: maxNum) else{ return false }
        
        return self.predicateEvaluateRegexString(regex: regexString)
    }
    
    
    /**
     *    @description 正则校验汇总
     *
     */
    func predicateEvaluateRegexString(regex:String) -> Bool {
        
        guard IsValidateString(string: regex) else { return false }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        guard predicate.evaluate(with: self) else {
            
            return false
        }
        
        return true
    }
    
    // MARK: - 正则截取
    
    
}

extension String {
    
    /**
     *    @description 拷贝到系统剪贴板
     *
     */
    func copyToPasteboard() {
        
        UIPasteboard.general.string = self
        
    }
}

// MARK: - 文件读取
extension String {
    
    /// 以自身为文件路径，读取Json数据(第一层为字典)
    var loadJsonDicDataOrNil : NSDictionary? {
        
        guard XYFileManager.FileExists(filePath: self),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: self)),
            let dic = NSDictionary.CreateWith(jsondata: jsonData) else { return nil }
        return dic
    }
    
    /// 以自身为文件路径，读取Json数据(第一层为数组)
    var loadJsonArrDataOrNil : NSArray? {
    
        guard XYFileManager.FileExists(filePath: self),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: self)),
            let arr = NSArray.CreateWith(jsondata: jsonData) else { return nil}
        
        return arr
    }
    
}

// MARK: - CGSize
extension String {
    
    /// 解析成Double类型数据
    var toDoubleOrNil : Double? { return Double(self) }
    
    /// 解析成CGFloat数据
    var toCGFloatOrNil : CGFloat? {
        
        guard let double = self.toDoubleOrNil else { return nil }
        
        return CGFloat(double)
    }

    /// 解析成NSNumber对象
    var toNumberOrNil : NSNumber? {
        
        guard let double = self.toDoubleOrNil else { return nil }
        
        let number = NSNumber(value: double)
        
        return number
    }

    /// 解析成Float数据
    var toFloatOrNil : Float? {
        
        guard let number = self.toNumberOrNil else { return nil }
        
        return number.floatValue
    }
    
    /// 解析成Int数据
    var toIntOrNil : Int? {
        
        guard let number = self.toNumberOrNil else { return nil }
        
        return number.intValue
    }
    
    func xyToFloat(scale: Int16 = 2) -> Float? {
           
        guard self.isNotEmpty else { return nil }
 
        let decimaleNumber : NSDecimalNumber = NSDecimalNumber(string: self)
 
        let decimalNumberHandle : NSDecimalNumberHandler =  NSDecimalNumberHandler(roundingMode:  NSDecimalNumber.RoundingMode.plain, scale: scale,  raiseOnExactness: false, raiseOnOverflow: false,  raiseOnUnderflow: false, raiseOnDivideByZero: false)
 
        let resultNumber : NSDecimalNumber =  decimaleNumber.rounding(accordingToBehavior:  decimalNumberHandle)
 
        let resultFloat = resultNumber.floatValue
 
        guard resultFloat.isNaN == false else { return nil }
 
        return resultFloat
 
        /* Check Function
         let numStrArr = ["", "12", "1.2", "2.33", "4.345", "3.392",  "3.395", "3.456447474", "sdsfsdf", "sdfs345", "342dsf"]
 
         var floatArr : [Float?] = [Float?]()
         var floatStrArr : [String?] = [String?]()
         for numStr in numStrArr {
 
         let resultOrNil = numStr.xyToFloat(scale: 3)
 
         floatArr.append(resultOrNil)
 
         if let result = resultOrNil {
 
         floatStrArr.append("\(result)")
         }
         }
 */
    }
    
    /// 将自身解析为CGSize (例:"{375, 812}"、(414.0, 736.0)、414.0, 736.0)
    var toCGSizeOrNil : CGSize? {
        
        let sizeStrArr = self.removeMultiple(textArr: ["{", "}", "(", ")"]).components(separatedBy: ",")
        
        if let widthText = sizeStrArr.elementByIndex(0),
            let width = widthText.trimmingWhiteSpace().toCGFloatOrNil,
            let heightText = sizeStrArr.elementByIndex(1),
            let height = heightText.trimmingWhiteSpace().toCGFloatOrNil {
            
            return CGSize(width: width, height: height)
        }
    
        return nil
    }
}

// MARK: - MD5
extension String {

    /**
     *    @description 根据类名与时间戳生成MD5值
     *
     *    @param    className    类名
     *
     *    @return   MD5值
     */
    static func CreateIdByTime(className classNameOrNil: String? = nil) -> String {
        
        let amplification: Int = 1000000 //精度:纳秒
        let nowDate = Date()
        let nowTimeInterval = TimeInterval(nowDate.timeIntervalSince1970 * Double(amplification))
        let nowtime = TimeInterval(nowTimeInterval - 1483200000000000)
        let theTime = Int64(nowtime)
        
        let microsecond = "\(theTime)"//时间(微秒)
        
        var result: String = ""
        
        if let className = classNameOrNil,
            className.isNotEmpty {
            
            result = "\(className)_\(microsecond)"
        }else {
            
            result = microsecond
        }
        
        return result.MD5String()
    }
    
    static func MD5ByTexts(textArr: String?...) -> String? {
        
        var result: String = ""
        
        for textOrNil in textArr {
            
            guard let text = textOrNil,
                text.isNotEmpty else { continue }
            
            if result.isNotEmpty {
                
                result += "_"
            }
            
            result += text
        }
        
        guard result.isNotEmpty else { return nil }
        
        return result.MD5String()
    }
}

// MARK: - URL
extension String {

    var xyURLOrNil: URL? {
        
        let newValue = self.trimmingWhiteSpaceAndNewLines()
        
        guard newValue.isNotEmpty else { return nil }
        
        return URL(string: newValue)
    }
}
