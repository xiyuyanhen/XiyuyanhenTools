//
//  XYUIAdjustment.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/5/29.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

func ScreenWidth() -> CGFloat{
    
    return XYUIAdjustment.Share().screenWidth
}

func ScreenHeight() -> CGFloat{
    
    return XYUIAdjustment.Share().screenHeight
}

func UIH(_ size:CGFloat) -> CGFloat{
    
    return XYUIAdjustment.ScaleHeight(size: size)
}

func UIW(_ size:CGFloat) -> CGFloat{
    
    return XYUIAdjustment.ScaleWidth(size: size)
}

func StatusBarHeight() -> CGFloat{
    
    return XYUIAdjustment.Share().statusBarHeight
}

func SafeAreaBottomHeight( _ scale : CGFloat = 1.0) -> CGFloat{
    
    return XYUIAdjustment.SafeAreaBottomHeight() * scale
}

func TabbarHeight() -> CGFloat {
    
    return XYUIAdjustment.Share().tabbarHeight
}

func SafeAreaBottomAndTabbarHeight() -> CGFloat {
    
    return SafeAreaBottomHeight() + TabbarHeight()
}


class XYUIAdjustment : NSObject {
    
    //单例
    private static let `default` = XYUIAdjustment();
    
    class func Share() -> XYUIAdjustment{
        
        let adjustment:XYUIAdjustment = XYUIAdjustment.default;
        
        return adjustment;
    }
    
    override private init() {
        
        var width = UIScreen.main.bounds.size.width
        var height = UIScreen.main.bounds.size.height
        
        if height <= width {
            //当设备水平放置时，宽高会换过来
            let temp = width
            
            width = height
            height = temp
        }
        
        self.screenWidth = width
        self.screenHeight = height
        
        super.init()
    }
    
    let screenHeight : CGFloat
    let screenWidth : CGFloat
    let statusBarHeight : CGFloat =  UIApplication.shared.statusBarFrame.height
    
    let navigationBarHeight:CGFloat = {
        
//        BaseNavigationController().navigationBar.bounds.size.height
        return 44
    }()
    
    let tabbarHeight:CGFloat = 49.0
    let safeAreaInsets:UIEdgeInsets = {
        
        let saInsets:UIEdgeInsets
        if #available(iOS 11.0, *) {
            
            if let safeAI = UIApplication.shared.delegate?.window??.safeAreaInsets {
                
                saInsets = safeAI
                
            }else{
                
                saInsets = UIEdgeInsets.zero
            }
            
        } else {
            
            saInsets = UIEdgeInsets.zero
        }
        
        return saInsets
    }()
    
    func safeAreaBottomHeight() -> CGFloat {
        
        return self.safeAreaInsets.bottom
    }
    
    /// 是否为流海屏机型
    lazy var isDriftingScreen : Bool = {
        
        /* 判定规则
            1.获取状态栏的高度，全面屏手机的状态栏高度为44pt，非全面屏手机的状态栏高度为20pt
            2.获取底部的底部的安全距离，全面屏手机为34，非全面屏手机为0
        */
        
        if 10.0 < self.safeAreaBottomHeight() {
            
            return true
        }
        
        return false
    }()
    
    class func SafeAreaBottomHeight() -> CGFloat {
        
        return self.default.safeAreaBottomHeight()
    }

    func scaleFontSize(size:CGFloat) -> CGFloat {
        
        return size * self.scaleFontRatio
    }
    
    class func ScaleFontSize(size:CGFloat) -> CGFloat {
        
        return self.default.scaleFontSize(size: size)
    }
    
    func scaleHeight(size:CGFloat) -> CGFloat {
        
        return size * self.scaleHeightRatio
    }
    
    class func ScaleHeight(size:CGFloat) -> CGFloat {
        
        return self.default.scaleHeight(size: size)
    }
    
    func scaleWidth(size:CGFloat) -> CGFloat {
        
        return size * self.scaleWidthRatio
    }
    
    class func ScaleWidth(size:CGFloat) -> CGFloat {
        
        return self.default.scaleWidth(size: size)
    }
    
    static var ScalePadByiPhone : CGFloat {
    
        return ScreenWidth()/375
    }
    
    var scaleWidthRatio : CGFloat {

        var ratio:CGFloat = 1.0

        if XYDevice.Model() == .iPad {
            
            ratio = self.screenWidth/768.0
        }else{
            
            ratio = self.screenWidth/375.0
        }
        
        return ratio
    }
    
    var scaleHeightRatio : CGFloat {
        
        var ratio:CGFloat = 1.0
        
        if XYDevice.Model() == .iPad {
            
            ratio = self.screenHeight/1024.0
        }else{
            
            ratio = self.screenHeight/667.0
        }
        
        return ratio
    }
    
    var scaleFontRatio : CGFloat {
        
        var ratio:CGFloat = 1.0
        
        if XYDevice.Model() == .iPad {
            
            ratio = self.screenWidth/768.0
        }else{
            
            ratio = self.screenWidth/375.0
        }
        
        return ratio
    }
}

extension XYUIAdjustment {
    
    class func SafeSpace_Top() -> CGFloat {
        
        var space : CGFloat = 0
        
        if #available(iOS 11.0, *) {
            
            
            
        }else {
            
            space = self.default.statusBarHeight
        }
        
        return space
    }
}

extension XYUIAdjustment {

    /**
     *    @description 根据设备类型筛选结果
     *
     */
    static func Filter<T>(Pad: T, Phone: T) -> T {
        
        if XYDevice.Model() == .iPad {
            
            return Pad
        }
        
        return Phone
    }
    
    static func FilterConstant(Pad: CGFloat, Phone: CGFloat) -> CGFloat {
        
        return self.Filter(Pad: Pad, Phone: Phone)
    }
}
