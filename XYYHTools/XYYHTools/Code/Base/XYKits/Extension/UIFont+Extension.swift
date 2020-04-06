//
//  UIFont+Extension.swift
//  XY_EStudy
//
//  Created by Xiyuyanhen on 2018/5/16.
//  Copyright © 2018年 Xiyuyanhen. All rights reserved.
//

// iOS 系统自带字体库 http://www.iosfonts.com/

import Foundation

extension UIFont {
    
    /**
     *    @description 根据屏幕宽度比生成新字体
     *
     */
    func xyNewFontBy(needFitByPad: Bool = false) -> UIFont? {
        
        /// 旧字体大小
        let oldSize: CGFloat = self.pointSize
        
        /// 新字体大小
        var newSize: CGFloat = oldSize
        
        if needFitByPad,
            XYDevice.Model() == .iPad {
            
            // 如果需要针对Pad调整
            newSize = XYUIAdjustment.ScalePadByiPhone * newSize
        }
        
        newSize = FontSize(newSize).size
        
        guard newSize != oldSize else { return nil }
            
        return self.withSize(newSize)
    }
    
    
}

/// 字体大小值
struct FontSize {
    
    /// 初始值
    var iSize: CGFloat
    
    /// 是否自动调整大小(根据设备屏幕)
    var autoFit: Bool
    
    init(_ iSize:CGFloat, autoFit: Bool = true) {
        
        self.iSize = iSize
        self.autoFit = autoFit
    }
    
    /// 使用值
    var size : CGFloat {
        
        guard self.autoFit else {
            
            return self.iSize
        }
        
        return XYUIAdjustment.ScaleFontSize(size: self.iSize)
    }
}

struct XYFont {
    
    var name : String
    var size : FontSize
    
    init(name : String, size : FontSize) {
        
        self.name = name
        self.size = size
    }
    
    init(uiFont: UIFont) {
        
        self.name = uiFont.fontName
        self.size = FontSize(uiFont.pointSize, autoFit: false)
    }
    
    var uiFont : UIFont {
        
        guard let font = UIFont.init(name: self.name , size: self.size.size) else {
            
            return XYCustomFont.System.Regular.uiFont(fSize: self.size)
        }
        
        return font
    }
}



extension XYFont {
    
    //        guard fontType != .黑体加粗斜体,
    //            fontType != .黑体斜体 else {
    //
    //                //设置倾斜角度
    //                let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(12 * Float.pi / 180)), d: 1, tx: 0, ty: 0)
    //
    //                let fontName : String
    //                if fontType == XYFN.黑体斜体 {
    //
    //                    fontName = XYFN.黑体.fontName
    //                }else {
    //                    // 黑体加粗斜体
    //
    //                    fontName = XYFN.黑体加粗.fontName
    //                }
    //
    //                ///字体描述
    //                let desc:UIFontDescriptor = UIFontDescriptor(name: fontName,matrix: matrix)
    //
    //                return UIFont(descriptor: desc, size: FontSize(size))
    //        }
    
    /**
     *    @description 获取指定字体大小的系统字体
     *
     *    @param    size    字体大小
     *
     *    @param    autoFit    是否自动调整
     *
     */
    static func Font(size:CGFloat, autoFit: Bool = true) -> UIFont {
        
        return XYCustomFont.System.Regular.uiFont(fSize: FontSize(size, autoFit: autoFit))
    }
    
    /**
     *    @description 获取指定字体大小的系统字体
     *
     *    @param    size    字体大小
     *
     *    @param    autoFit    是否自动调整
     *
     */
    static func BoldFont(size:CGFloat, autoFit: Bool = true) -> UIFont {
        
        return XYCustomFont.System.Bold.uiFont(fSize: FontSize(size, autoFit: autoFit))
    }
    
    /**
     *    @description 获取指定字体大小的系统字体
     *
     *    @param    size    字体大小
     *
     *    @param    autoFit    是否自动调整
     *
     */
    static func ItalicFont(size:CGFloat, autoFit: Bool = true) -> UIFont {
        
        return XYCustomFont.System.Italic.uiFont(fSize: FontSize(size, autoFit: autoFit))
    }
    
}

// MARK: - 自定义字体
protocol XYFontProtocol : XYEnumTypeAllCaseProtocol {
    
    /// 字体名称前缀
    var hName : String { get }
    
    var rawValue : String { get }
}

extension XYFontProtocol {
    
    /// 具体的字体名称
    var fontName : String {
        
        return "\(self.hName)\(self.rawValue)"
    }
    
    func uiFont(fSize: FontSize) -> UIFont {
        
        guard let font = UIFont.init(name: self.fontName , size: fSize.size) else {
            
            return XYCustomFont.System.Regular.uiFont(fSize: fSize)
        }
        
        return font
    }
    
    static func FontBy(_ name: String) -> Self? {
        
        for cFont in self.AllCaseArr {
            
            guard cFont.fontName == name else { continue }
            
            return cFont
        }
        
        return nil
    }
    
    func logName() {
        
        let font = self.uiFont(fSize: FontSize(12))
        
        XYLog.LogNoteBlock { () -> String? in
            return "familyName: \(font.familyName) fontName: \(font.fontName)"
        }
    }
}

enum XYCustomFont {
    
    /// 系统默认
//    enum System : String, XYFontProtocol {
//
//        /// 普通
//        case Regular = ""
//        /// 粗体
//        case Bold    = "-Semibold"
//        /// 斜体
//        case Italic  = "-RegularItalic"
//
//        var hName : String { return "SanFranciscoText" }
//
//        func uiFont(fSize: FontSize) -> UIFont {
//            switch self {
//            case .Regular: return UIFont.systemFont(ofSize: fSize.size)
//            case .Bold: return UIFont.boldSystemFont(ofSize: fSize.size)
//            case .Italic: return UIFont.italicSystemFont(ofSize: fSize.size)
//            }
//        }
//    }
    
    ///
    enum System : String, XYFontProtocol {
        
        /// 普通
        case Regular            = "MT"
        /// 粗体
        case Bold                = "-BoldMT"
        /// 斜体
        case Italic                = "-ItalicMT" // 中文无效
        /// 粗体斜体
        case BoldItalic             = "-BoldItalicMT" // 中文无效
        
        var hName : String { return "Arial" }
    }
    
    /// 黑体
    enum HeiTi : String, XYFontProtocol {
        
        /// 普通
        case Regular            = "MT"
        /// 粗体
        case Bold               = "-BoldMT"
        /// 斜体
        case Italic             = "-ItalicMT" // 中文无效
        /// 粗体斜体
        case BoldItalic         = "-BoldItalicMT" // 中文无效
        
        var hName : String { return "Arial" }
    }
    
    enum Palatino : String, XYFontProtocol {
        
        /// 粗体
        case Bold           = "-Bold"
        /// 斜体
        case Italic         = "-Italic"
        /// 粗体斜体
        case BoldItalic     = "-BoldItalic"
        
        var hName : String { return "Palatino" }
    }
}


