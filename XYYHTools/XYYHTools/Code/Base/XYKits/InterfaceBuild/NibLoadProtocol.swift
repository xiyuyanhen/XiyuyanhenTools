//
//  NibLoadProtocol.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/10/28.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYNibLoadViewControllerProtocol : XYNewSettingProtocol {
    
    
}

extension XYNibLoadViewControllerProtocol where Self : UIViewController {
    
    static func LoadNibViewController( _ nibNameOrNil: String? = nil) -> Self {
        
        let nibName : String
        
        if let nName = nibNameOrNil {
            
            nibName = nName
        }else {
            
            nibName = Self.ClassName()
        }
        
        guard XYBundle.NibFileIsExist(name: nibName),
            let nibArr = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil),
            let firstNib = nibArr.first,
            let nib_Self = firstNib as? Self else {
                
            let viewController = Self()
            
            return viewController
        }
        
        nib_Self.initProperty()
        
        nib_Self.view.xyFitSizeByNibNewView()
        
        return nib_Self
    }
}
