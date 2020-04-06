//
//  Public_Function.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/5/26.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

/**
 *    @description 退出App
 *
 *    1.这是默认的程序结束函数,这种方式可能会或可能不会以刷新与关闭打开的文件或删除临时文件,这与你的设计有关。
 *
 */
func XYExitApp(animated: Bool = true) {
    
    guard animated,
        let window = AppDelegate.AppWindow else {
        
        exit(0)
    }
    
    // 一秒黑屏动画
    UIView.animate(withDuration: 1.0, animations: {
        
        window.setAlpha(0.0)
    }) { (finished) in
        
        exit(0)
    }
}

let APPScreen = UIScreen.main

let APPDELEGATE = AppDelegate.Shared()

/**
 *    @description APP沙盒Document路径
 *
 */
func APPDocumentPath() -> String{
    
    let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentPath = documentPaths.first
    
    let path = documentPath!+"/"
    
    return path
}

/**
 *    @description APP沙盒Cache路径
 *
 */
func APPCachePath() -> String{
    
    let documentPaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    let documentPath = documentPaths.first
    
    let path = documentPath!+"/"
    
    return path
}

var APPTmpDirectoryPath : String {

    return NSTemporaryDirectory()
}

/// 获取App实际使用的启动图
var LaunchImageNameOrNil : String? {
    
    guard let viewSize = AppDelegate.AppWindow?.bounds.size,
        let infoDictionary = XYBundle.Main.infoDictionary,
        let imagesDicArr = infoDictionary["UILaunchImages"] as? NSArray else { return nil }
    
    // 竖屏
    let viewOrientation = "Portrait"
    
    for imagesDicOrNil in imagesDicArr {
        
        guard let imagesDic = imagesDicOrNil as? Dictionary<String, Any>,
            let sizeStr = imagesDic["UILaunchImageSize"] as? String,
            let imageSize = sizeStr.toCGSizeOrNil,
            __CGSizeEqualToSize(imageSize, viewSize),
            let imageOrientation = imagesDic["UILaunchImageOrientation"] as? String,
            imageOrientation == viewOrientation,
            let imageName = imagesDic["UILaunchImageName"] as? String else {
                
                continue
        }
        
        return imageName
    }
    
    return nil
}


let APPSTANDARD = UserDefaults.standard

// MARK: - 自定义闭包(Block)
typealias CompletionBlock = () -> Void
typealias ClickBtnBlockHandler = (_ clickBtn:BaseButton) -> Void
typealias CompletionBlockHandler = (_ result:Any?) -> Void
typealias CompletionBoolBlockHandler = (_ flag:Bool, _ result:AnyObject?) -> Void
typealias CompletionSuccessBlockHandler = (_ isSuccess:Bool) -> Void

typealias CompletionElementBlockHandler<E> = (_ elementOrNil:E?) -> Void
typealias CompletionBoolElementBlockHandler<E> = (_ flag:Bool, _ elementOrNil:E?) -> Void

typealias UIAlertActionBlock = (UIAlertAction) -> Swift.Void

typealias CompletionReturnValueBlock<R> = () -> R?

func XYElementBy<E>(blocks: CompletionReturnValueBlock<E>...) -> E? {
    
    for block in blocks {
        
        guard let result = block() else { continue }
        
        return result
    }
    
    return nil
}

// MARK: - 校验方法
/**
 *    @description 校验String有效性
 *
 */
func IsValidateString(string:String?) -> Bool{
    
    return (string != nil) && (string!.count > 0)
}

/**
 *    @description 校验Array有效性
 *
 */
func IsValidateArray(_ arrOrNil:[Any]?) -> Bool{
    
    guard let arr = arrOrNil else { return false }
    
    return (arr.count > 0)
}

/**
 *    @description 校验NSArray有效性
 *
 */
func IsValidateNSArray(_ arrOrNil:NSArray?) -> Bool{
    
    guard let arr = arrOrNil else { return false }
    
    return (arr.count > 0)
}

/**
 *    @description 校验NSDictionary有效性
 *
 */
func IsValidateNSDictionary(_ dicOrNil:Any?) -> Bool{
    
    guard let dic = dicOrNil as? NSDictionary else { return false }
    
    return (dic.count > 0)
}

/**
 *    @description 根据显示模式筛选结果
 *
 */
func FilterByUserInterfaceStyle<T>(normal: T, dark: T) -> T {
    
    if #available(iOS 12.0, *) {
        
        switch APPDELEGATE.tabbarController.traitCollection.userInterfaceStyle {
            // 深色模式
            case .dark: return dark
            default: return normal
        }
    }
    
    return normal
}

/**
 *    @description 根据指定宽度与参考size(height/width)计算高度
 *
 *    @param    width    宽度
 *
 *    @param    referenceSize    参考size
 *
 *    @return   高度
 */
func CaculateHeightBySize(width: CGFloat, referenceSize: CGSize) -> CGFloat {
    
    let rate: CGFloat = referenceSize.height/referenceSize.width
    
    return CaculateHeightByRate(width: width, referenceRate: rate)
}

/**
*    @description 根据指定宽度与参考比值(height/width)计算高度
*
*    @param    width    宽度
*
*    @param    referenceRate    参考比值
*
*    @return   高度
*/
func CaculateHeightByRate(width: CGFloat, referenceRate: CGFloat) -> CGFloat {
    
    return referenceRate*width
}
