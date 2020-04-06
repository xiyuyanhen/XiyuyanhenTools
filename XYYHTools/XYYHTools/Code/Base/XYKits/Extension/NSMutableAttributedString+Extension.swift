//
//  NSMutableAttributedString+Extension.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/7/1.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
//    class func XYAttributedString(htmlText: String) -> Self? {
//
//        guard 0 < htmlText.count else { return nil }
//
//        guard let htmlStringData : Data = htmlText.data(using: String.Encoding.unicode),
//            let htmlArrStr = try? self.init(data: htmlStringData, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
//
//        return htmlArrStr
//    }
    
    /**
     *    @description 拼接富文本
     *
     */
    class func XYAttributedString(models:AttributesModel...) -> NSMutableAttributedString {
        
        return XYAttributedString(models: models)
    }
    
    /**
     *    @description 拼接富文本
     *
     */
    class func XYAttributedString(models: [AttributesModel]) -> NSMutableAttributedString {
        
        let mulAttString = NSMutableAttributedString(string: "")
        
        for attModel in models {
            
            guard attModel.text.count > 0 else { continue }
            
            let partAttString = attModel.attributedString()
            
            mulAttString.append(partAttString)
        }
    
        return mulAttString
    }
    
    /**
     *    @description 修改富文本
     *
     */
    class func XYAttributedStringPart(mainModel:AttributesModel, partModels:AttributesModel...) -> NSAttributedString {
        
        let mainAttString = mainModel.attributedString()
        
        let mainMulAttString = NSMutableAttributedString(attributedString: mainAttString)
        
        for attModel in partModels {
            
            guard attModel.text.count > 0 else { continue }
            
            guard mainModel.text.contains(attModel.text) else { continue }
            
            let attRange = NSRange(location: 0, length: attModel.text.count)
            
            mainMulAttString.addAttributes(attModel.attributes, range: attRange)
            
        }
        
        return mainMulAttString
    }
    
    struct AttributesModel : ModelProtocol_Array {
        
        var attributes = [NSAttributedString.Key : Any]()
        let text:String
        
        var colorARGBOrNil : XYColorARGB?
        
        init(text:String, fontSize: CGFloat? = 14, textColor: XYColor.CustomColor? = .x333333) {
            
            self.text = text
            
            //default Attributed Text
            if let fsize = fontSize {
                
                self.attributes[NSAttributedString.Key.font] = XYFont.Font(size: fsize)
            }
            
            if let tColor = textColor {
                
                self.colorARGBOrNil = tColor.argb
                
                self.attributes[NSAttributedString.Key.foregroundColor] = tColor.uiColor
            }
        }
        
        mutating func addAttribute(attributedStringKey:NSAttributedString.Key, value:Any) {
            
            self.attributes[attributedStringKey] = value
        }
        
        mutating func addAttFont(font:UIFont = XYFont.Font(size: 14)) {
            
            self.addAttribute(attributedStringKey: NSAttributedString.Key.font, value: font)
        }
        
        mutating func addAttColor(color:UIColor = XYColor.CustomColor.x2d354c.uiColor) {
            
            self.addAttribute(attributedStringKey: NSAttributedString.Key.foregroundColor, value: color)
        }
        
        /**
         *    @description 添加倾斜效果
         *
         */
        mutating func addAttObliqueness(rate: Float = 1.0) {
            
            self.addAttribute(attributedStringKey: NSAttributedString.Key.obliqueness, value: NSNumber(value: rate))
        }
        
        /**
         *    @description 添加加粗效果
         *
         */
        mutating func addAttExpansion(rate: Float = 1.0) {
            
            self.addAttribute(attributedStringKey: NSAttributedString.Key.expansion, value: NSNumber(value: rate))
        }
        
        /**
         *    @description 添加删除线
         *
         *    若出现失效情况请注意
         *    在iOS 8 需要额外给其他字符串设置@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleNone)}，才能正常显示
         *    在iOS 10 需要额外给其他字符串设置@{NSBaselineOffsetAttributeName : @0}，才能正常显示
         *    注：@(NSUnderlineStyleNone) 和 @0均是默认值
         *
         */
        mutating func addAttLine(underlineStype: NSUnderlineStyle = NSUnderlineStyle.single) {
            
            self.addAttribute(attributedStringKey: NSAttributedString.Key.strikethroughStyle, value: underlineStype.rawValue)
//            self.addAttribute(attributedStringKey: NSAttributedString.Key.baselineOffset, value: -15)
        }
        
        /**
         *    @description 添加下划线
         *
         *    在iOS 8 需要额外给其他字符串设置@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}，才能正常显示
         *    注：@(NSUnderlineStyleNone)是默认值
         *
         */
        mutating func addAttUnderline(underlineStype:NSUnderlineStyle = NSUnderlineStyle.single) {
            
            self.addAttribute(attributedStringKey: NSAttributedString.Key.underlineStyle, value: underlineStype.rawValue)
//            self.addAttribute(attributedStringKey: NSAttributedString.Key.baselineOffset, value: NSNumber(value: 3.0))
        }
        
        mutating func addAttParagraphStyle(alignment:NSTextAlignment = NSTextAlignment.left, lineSpacing: CGFloat = UIW(8), firstLineIndent firstLineIndentOrNil: CGFloat? = nil) {
            
            //justified : 左右对齐
            
            let mutablePS = NSMutableParagraphStyle()
            mutablePS.lineSpacing = lineSpacing
            mutablePS.alignment = alignment
            
            if let firstLineIndent = firstLineIndentOrNil {
                
                mutablePS.firstLineHeadIndent = firstLineIndent
            }
            
            self.addAttribute(attributedStringKey: NSAttributedString.Key.paragraphStyle, value: mutablePS)
        }
        
//        mutating func addAttParagraphStyleIndent(fontSize:CGFloat) {
//
//            let mutablePS = NSMutableParagraphStyle()
//
//            mutablePS.firstLineHeadIndent = FontSize(fontSize) * 2
//
//            mutablePS.lineSpacing = UIH(8)
//
//            self.addAttribute(attributedStringKey: NSAttributedString.Key.paragraphStyle, value: mutablePS)
//        }
        
        var mutableAttributedString: NSMutableAttributedString {
            
            let attStr = NSMutableAttributedString(string: self.text)
            
            let range = attStr.yy_rangeOfAll()
            
            for attibuteKey in self.attributes.keys {
                
                if let value = self.attributes[attibuteKey] {
                    
                    attStr.addAttribute( attibuteKey, value: value, range: range)
                }
            }
            
            return attStr
        }
        
        func attributedString() -> NSAttributedString{
            
            return NSAttributedString(attributedString: self.mutableAttributedString)
        }
        
        func attributedTextByCustomHtml(asStyle : XYLabelBriefConfig) -> NSAttributedString {
            
            return self.attributedString()
        }
    }
    
}

extension NSMutableAttributedString {
    
/*
    //传入字符串、字体、颜色
    func appendColorStrWithString() {
        
        var model1 = AttributesModel(text: "Sign Up")
        model1.addAttribute(attributedStringKey: .font, value: XYFont.Font(size: 16))
        
        let model1_attString = model1.attributedString()
        
        var model2 = AttributesModel(text: "Sign Up")
        model2.addAttribute(attributedStringKey: .font, value: XYFont.Font(size: 16))
        
        let model2_attString = model2.attributedString()
        
        let attString = NSMutableAttributedString(attributedString: model1_attString)
        attString.append(model2_attString)
    }
*/
    
    /**
     *    @description 添加更多富文本
     *
     *    @param    attModels    AttributesModel...
     *
     */
    func xyAppend( attModels: AttributesModel...) {
        
        for attModel in attModels {
            
            guard attModel.text.isNotEmpty else { continue }
            
            self.append(attModel.attributedString())
        }
    }
}

extension NSAttributedString {
    
    /**
     *    @description 以字符串构建遮罩效果(空格不被遮罩)
     *
     *    @param    <#参数#>    <#参数说明#>
     *
     *    @return   <#返回说明#>
     */
    static func MaskText(text: String) -> NSMutableAttributedString? {
        
        let attText = NSMutableAttributedString(string: text)
        
        guard let regex = try? NSRegularExpression(pattern: "[^ ]+", options:[]) else { return nil }
        
        let matches = regex.matches(in: text, options: [], range: NSRange(text.startIndex...,in: text))
        
        guard matches.isNotEmpty else { return nil }
        
        //解析出子串
        for  match in matches {
            
            let matchRange : NSRange = match.range
            
            attText.addAttribute(NSAttributedString.Key.backgroundColor, value: XYColor(custom: .main).uicolor, range: matchRange)
            
//            guard let subString : String = text.slice(nsrange: matchRange) else { continue }
            

        }
        
        return attText
    }
    
    func maskText() -> NSMutableAttributedString? {
        
        let text = self.string
        
        let attText = NSMutableAttributedString(attributedString: self)
        
        /// 以空格、换行分割
        guard let regex = try? NSRegularExpression(pattern: "[^ \\n]+", options:[]) else { return nil }
        
        let matches = regex.matches(in: text, options: [], range: NSRange(text.startIndex...,in: text))
        
        guard matches.isNotEmpty else { return nil }
        
        //解析出子串
        for  match in matches {
            
            let matchRange : NSRange = match.range
            
            attText.addAttribute(NSAttributedString.Key.foregroundColor, value: XYColor(custom: .clear).uicolor, range: matchRange)
            attText.addAttribute(NSAttributedString.Key.backgroundColor, value: XYColor(rgb: 0xC0E0FB).uicolor, range: matchRange)
            
//            guard let subString : String = text.slice(nsrange: matchRange) else { continue }
            

        }
        
//        attText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: text.allNSRange)
//        attText.addAttribute(NSAttributedString.Key.underlineColor, value: XYColor(custom: .white).uicolor, range: text.allNSRange)
        
        return attText
    }
}
