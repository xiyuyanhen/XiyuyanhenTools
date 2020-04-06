//
//  XYLabelBriefConfig.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/6/19.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

struct XYLabelBriefConfig {
    
    var font : XYFont
    var color : XYColor
    var paragraphStyleOrNil : NSParagraphStyle? = nil
    
//    var numberOfLine : 
    
    init(font: XYFont, color: XYColor, alignment: NSTextAlignment = NSTextAlignment.left) {
        
        self.font = font
        self.color = color
        
        self.setParagraphStyle(lineSpacing: UIW(8), alignment: alignment)
    }
    
    mutating func setParagraphStyle(lineSpacing: CGFloat, alignment: NSTextAlignment) {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpacing
        paraStyle.alignment = alignment
        
        self.paragraphStyleOrNil = paraStyle
    }
    
    func addAttText(attText : NSMutableAttributedString) {
        
        let range = attText.string.allNSRange
        
        attText.addAttribute(NSAttributedString.Key.font, value: self.font.uiFont, range: range)
        attText.addAttribute(NSAttributedString.Key.foregroundColor, value: self.color.uicolor, range: range)
        
        if let paragraphStyle = self.paragraphStyleOrNil {
            
            attText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        }
    }
}
