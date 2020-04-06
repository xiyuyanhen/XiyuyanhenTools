//
//  UIViewController+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/18.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
    
    static private let XYVCDisposeBagNameKey = UnsafeRawPointer.init(bitPattern: "UIViewController_DisposeBag_Key".hashValue)
    var disposeBag: DisposeBag {
        
        set{
            
            objc_setAssociatedObject(self, UIViewController.XYVCDisposeBagNameKey!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        
        get{
            
            guard let bag = objc_getAssociatedObject(self, UIViewController.XYVCDisposeBagNameKey!) as? DisposeBag else {
                
                let newBag = DisposeBag()
                
                self.disposeBag = newBag
                
                return newBag
            }
            
            return bag
        }
    }
    
    
}
