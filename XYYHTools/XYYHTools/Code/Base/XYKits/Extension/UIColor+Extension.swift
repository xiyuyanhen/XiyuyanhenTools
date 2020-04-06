//
//  UIColor+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/8/29.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - XYColor

public typealias XYColorRGB  = UInt
public typealias XYColorARGB = UInt32

func ColorAnalysisARGB(_ argb: XYColorARGB) -> (a: XYColorRGB, r: XYColorRGB, g: XYColorRGB, b: XYColorRGB) {
    
    let alpha : XYColorRGB = XYColorRGB((argb&0xff000000) >> 24)
    let red : XYColorRGB   = XYColorRGB((argb&0xff0000) >> 16)
    let green : XYColorRGB = XYColorRGB((argb&0xff00) >> 8)
    let blue : XYColorRGB  = XYColorRGB(argb&0xff)
    
    return (a: alpha, r: red, g: green, b: blue)
}

func XYColorARGBBy(rgb: XYColorRGB, alpha: CGFloat = 1.0) -> XYColorARGB{
    
    let colorInt32 : XYColorARGB = XYColorARGB(rgb)
    let alphaInt32 : XYColorARGB = XYColorARGB(XYColorRGB(alpha*255.0) << 24)
    
    return alphaInt32 + colorInt32
}

func XYColorARGBBy(argbText textOrNil: String?) -> XYColorARGB? {
    
    var argb : XYColorARGB = 0
    
    guard let argbText = textOrNil,
        Scanner(string: argbText).scanHexInt32(&argb) else { return nil }
    
    return argb
}

struct XYColor {
    
    /// RGB值
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    
    /// 透明度
    var alpha : CGFloat
    
    init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
    }
    
    init(rgb: XYColorRGB, alpha: CGFloat = 1.0) {
        
        let red: CGFloat   = CGFloat((rgb&0xff0000) >> 16)/255.0
        let green: CGFloat = CGFloat((rgb&0x00ff00) >> 8)/255
        let blue: CGFloat  = CGFloat(rgb&0x0000ff)/255
        
        self.init(r: red, g: green, b: blue, a: alpha)
    }
    
    init(argb: XYColorARGB) {
        
        let alpha: CGFloat = CGFloat((argb&0xff000000) >> 24)/255.0
        
        let rgb: XYColorRGB = XYColorRGB(argb&0xffffff)
        
        self.init(rgb: rgb, alpha: alpha)
    }
    
    init(custom: CustomColor, alpha: CGFloat = 1.0) {
        
        self.init(argb: custom.argb(alpha: alpha))
    }
    
    init?(ARGBText textOrNil: String?) {
        
        var argb : XYColorARGB = 0
        
        guard let argbText = textOrNil,
            Scanner(string: argbText).scanHexInt32(&argb) else { return nil }
        
        self.init(argb: argb)
    }
    
    init?(RGBText textOrNil: String?, alpha: CGFloat = 1.0) {
        
        var rgb : XYColorARGB = 0
        
        guard let rgbText = textOrNil,
            Scanner(string: rgbText).scanHexInt32(&rgb) else { return nil }
        
        self.init(rgb: XYColorRGB(rgb), alpha: alpha)
    }
    
    /// 生成ARGB值
    var argb: XYColorARGB {
        
        let alpha: XYColorARGB = XYColorARGB(self.alpha*0xff) << 24
        let red:   XYColorARGB = XYColorARGB(self.red*0xff) << 16
        let green: XYColorARGB = XYColorARGB(self.green*0xff) << 8
        let blue:  XYColorARGB = XYColorARGB(self.blue*0xff)
        
        let argb = alpha + red + green + blue

        return argb
    }
    
    static func ARGBStr(colorNum: XYColorARGB, include0x: Bool = false) -> String {

        var hexStr = String( colorNum, radix: 16)

        if include0x {

            hexStr = "0x" + hexStr
        }

        return hexStr
    }

    func argbText(include0x: Bool = false) -> String {

        let hexStr = XYColor.ARGBStr(colorNum: self.argb, include0x: include0x)

        return hexStr
    }

    var uicolor : UIColor {
    
        return UIColor(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha)
    }
    
    var cgcolor : CGColor {
        
        return self.uicolor.cgColor
    }
}

// MARK: - CustomColor
extension XYColor {
    
    /// CustomColor
    enum CustomColor : XYColorARGB {
        
        case clear = 0x00000000
        case main  = 0x2000000
        
        case white = 0xffffffff
        case black = 0xff000000
        
        case x040F17 = 0xff040F17
        case x2d354c = 0xff2d354c
        case xe7e7e7 = 0xffe7e7e7
        case xf1f1f1 = 0xfff1f1f1
        case xf6f6f6 = 0xfff6f6f6
        case xf7f7f7 = 0xfff7f7f7
        case xf5f5f5 = 0xfff5f5f5
        case xcccccc = 0xffcccccc
        case xdddddd = 0xffdddddd
        case xe5e5e5 = 0xffe5e5e5
        case xeeeeee = 0xffeeeeee
        case x333333 = 0xff333333
        case x030303 = 0xff030303
        case x666666 = 0xff666666
        case x979797 = 0xff979797
        case x999999 = 0xff999999
        case xC8C8C8 = 0xffC8C8C8
        case xc9c9c9 = 0xffc9c9c9
        case xFF3C30 = 0xffFF3C30
        
        /// 评分 - 红
        case xff556f = 0xffFF556F
        /// 评分 - 黄
        case xfed942 = 0xfffed942
        /// 评分 - 绿
        case x71da59 = 0xff71da59
        
        var argb : XYColorARGB {
            
            switch self {
                
            case .main:
                
                switch APP_CurrentTarget {
                    
                case .ShiTingShuo: return 0xffFF7C53
                    
                case .Xiyou: return 0xff309af2
                }
                
            default: return self.rawValue
            }
        }
        
        var argbText: String {
            
            return String(format: "%02X", self.argb)
        }
        
        func argb(alpha: CGFloat) -> XYColorARGB {
            
            var argb = self.argb
            
            guard alpha < 1.0 else {
                
                return argb
            }
            
            var alpha16 = XYColorARGB(alpha * 0xff)
            alpha16 = alpha16 << 24
            
            argb -= 0xff000000
            argb += alpha16
            
            return argb
        }
        
        var uiColor : UIColor {
            
            return XYColor(custom: self).uicolor
        }
    }
    
}



// MARK: - UIColor Extension

/* 接口速度测试记录
 
 let hexMarkDate : Date = Date()
 let _ = UIColor.FromARGB(0x002d354c)
 XYLog.LogNoteBlock { () -> String? in
            
            return "Hex ARGB 耗时:\(Date.TimeIntervalMilliSecond(otherDate: hexMarkDate).xyDecimalLength(5))ms"
        }
 
 let strMarkDate : Date = Date()
 let _ = UIColor.FromARGB("002d354c")
 XYLog.LogNoteBlock { () -> String? in
            
            return "Str ARGB 耗时:\(Date.TimeIntervalMilliSecond(otherDate: strMarkDate).xyDecimalLength(5))ms"
        }
 
 06/18 16:36:05:536 [N] Hex ARGB 耗时:0.66006ms
 06/18 16:36:05:545 [N] Str ARGB 耗时:7.43604ms
 
 */

extension UIColor {
    
    static func FromXYColor(color: XYColor.CustomColor, alpha: CGFloat = 1.0) -> UIColor {
        
        return XYColor(custom: color, alpha: alpha).uicolor
    }
    
    convenience init(ARGB argb: XYColorARGB) {
        
        let alpha : CGFloat = CGFloat((argb&0xff000000) >> 24)/255.0
        let red : CGFloat   = CGFloat((argb&0xff0000) >> 16)/255.0
        let green : CGFloat = CGFloat((argb&0x00ff00) >> 8)/255.0
        let blue : CGFloat  = CGFloat(argb&0x0000ff)/255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(RGB rgb: XYColorRGB, alpha: CGFloat = 1.0) {
        
        let red : CGFloat   = CGFloat((rgb&0xff0000) >> 16)/255.0
        let green : CGFloat = CGFloat((rgb&0x00ff00) >> 8)/255
        let blue : CGFloat  = CGFloat(rgb&0x0000ff)/255
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //根据十六进制数返回UIColor对象
    static func FromRGB(_ rgb: XYColorRGB, _ alpha: CGFloat = 1.0) -> UIColor{
        
        let red : CGFloat   = CGFloat((rgb&0xff0000) >> 16)/255.0
        let green : CGFloat = CGFloat((rgb&0x00ff00) >> 8)/255
        let blue : CGFloat  = CGFloat(rgb&0x0000ff)/255
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /**
     *    @description 将ARGB字符转为UIColor对像
     *
     *    @param    argbStr    <#参数说明#>
     *
     *    @return   <#返回说明#>
     */
    static func FromARGB(_ argbStr: String) -> UIColor? {
        
        guard let alphaStr : String = argbStr.slice(nsrange: NSRange(location: 0, length: 2)),
            var alpha : CGFloat = alphaStr.toCGFloatOrNil,
            let redStr : String = argbStr.slice(nsrange: NSRange(location: 2, length: 2)),
            var red : CGFloat = redStr.toCGFloatOrNil,
            let greenStr : String = argbStr.slice(nsrange: NSRange(location: 4, length: 2)),
            var green : CGFloat = greenStr.toCGFloatOrNil,
            let blueStr : String = argbStr.slice(nsrange: NSRange(location: 6, length: 2)),
            var blue : CGFloat = blueStr.toCGFloatOrNil else { return nil }
        
        alpha = alpha/255.0
        red = red/255.0
        green = green/255.0
        blue = blue/255.0
        
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func FromRGBString(rgbString:String, alpha:CGFloat = 1.0) -> UIColor? {
        
        let newRGB = rgbString.replacingOccurrences(of: "0x", with: "")
        
        guard newRGB.count == 6 else {
            
            return nil
        }
        
        var rgbInt32 : CUnsignedInt = 0
        Scanner(string: newRGB).scanHexInt32(&rgbInt32)
        
        let rgb : XYColorRGB = XYColorRGB(rgbInt32)
        
        let color = self.FromRGB(rgb, alpha)
        
        return color
    }
    
    var toXYColor : XYColor {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return XYColor(r: r, g: g, b: b, a: a)
    }
}

// MARK: - XYColor
extension UIColor {
    
    static func WarmColor(blueFilterPercent: Int) -> UIColor {
        
        var realFilter = blueFilterPercent
        
        if blueFilterPercent < 10 {
            
            realFilter = 10
        }else if 80 < blueFilterPercent {
            
            realFilter = 80
        }
        
        let rf : CGFloat = CGFloat(realFilter)/80.0
        
        let a : CGFloat = rf * 180.0
        let r : CGFloat = 200.0 - rf * 190.0
        let g : CGFloat = 180.0 - rf * 170.0
        let b : CGFloat = 60.0 - rf * 60.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
