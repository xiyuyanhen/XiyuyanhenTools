//
//  XYAlertView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/7/18.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

//func ShowTextFieldAlertView(showedVC:UIViewController) {
//
//    let alertView = UIAlertController(title: "请输入券码", message: nil, preferredStyle: .alert)
//
//    alertView.addTextField { (textfield:UITextField) in
//        textfield.placeholder = "券码"
//        textfield.tag = 31
//
//    }
//
//    let comfirmAction = UIAlertAction(title: "确定", style: .default) { (alertAction) in
//
//
//    }
//
//    alertView.addAction(comfirmAction)
//
//    let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (alertAction) in
//
//        showedVC.dismiss(animated: true, completion: nil)
//    }
//    alertView.addAction(cancelAction)
//
//    showedVC.present(alertView, animated: true, completion: nil)
//
//}

var AlertShowedVC : UIViewController {
    
//    return AppDelegate.Shared().tabbarController
    
    guard var topRootVC = AppDelegate.ShareApplication.keyWindow?.rootViewController else {

        return AppDelegate.Shared().tabbarController
    }

    while let presentedVC = topRootVC.presentedViewController {

        topRootVC = presentedVC
    }

    return topRootVC
}

var ProgressHudView : UIView? {
    
    let hudView : UIView?
    
    if let view = AlertShowedVC.view {
        
        hudView = view
        
    }else{
        
        hudView = AppDelegate.AppWindow
    }
    
    return hudView
}

@discardableResult func ShowNormalAlertView(title:String, message:String? = nil, comfirmTitle:String = "确定", cancelTitle:String = "取消", showedVC:UIViewController = AlertShowedVC, comfirmBtnBlock:UIAlertActionBlock? = nil, cancelBtnBlock:UIAlertActionBlock? = nil) -> UIAlertController {
    
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let comfirmAction = UIAlertAction(title: comfirmTitle, style: .default, handler: comfirmBtnBlock)
    alertView.addAction(comfirmAction)
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler:cancelBtnBlock)
    alertView.addAction(cancelAction)
    
    showedVC.present(alertView, animated: true, completion: nil)
    
    return alertView
}


@discardableResult func ShowSingleBtnAlertView(title:String, message:String? = nil, comfirmTitle:String = "确定", showedVC:UIViewController = AlertShowedVC, comfirmBtnBlock:UIAlertActionBlock? = nil) -> UIAlertController{
    
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let comfirmAction = UIAlertAction(title: comfirmTitle, style: .default, handler: comfirmBtnBlock)
    alertView.addAction(comfirmAction)
    
    showedVC.present(alertView, animated: true, completion: nil)
    
    return alertView
}

@discardableResult func ShowThreeAlertView(title: String,
                                           message: String? = nil,
                                           comfirmTitle: String = "确定",
                                           secondTitle: String = "第二选项",
                                           cancelTitle: String = "取消",
                                           showedVC: UIViewController = AlertShowedVC,
                                           comfirmBtnBlock: UIAlertActionBlock? = nil,
                                           secondBtnBlock: UIAlertActionBlock? = nil,
                                           cancelBtnBlock: UIAlertActionBlock? = nil) -> UIAlertController {
    
    let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let comfirmAction = UIAlertAction(title: comfirmTitle, style: .default, handler: comfirmBtnBlock)
    alertView.addAction(comfirmAction)
    
    let secondAction = UIAlertAction(title: secondTitle, style: .default, handler:secondBtnBlock)
    alertView.addAction(secondAction)
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler:cancelBtnBlock)
    alertView.addAction(cancelAction)
    
    showedVC.present(alertView, animated: true, completion: nil)
    
    return alertView
}
