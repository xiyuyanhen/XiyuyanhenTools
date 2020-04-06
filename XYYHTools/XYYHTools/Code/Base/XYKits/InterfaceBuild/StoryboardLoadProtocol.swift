//
//  StoryboardLoadProtocol.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/2/7.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

protocol XYStoryboardLoadProtocol : XYNewSettingProtocol {
    
    static var StoryboardName: String { get }
    
    static var StoryboardIdentifier: String { get }
}

extension XYStoryboardLoadProtocol where Self : UIViewController {
    
    static func LoadFromStoryboard(_ identifierOrNil: String? = nil) -> Self? {
        
        let storyboardName: String = StoryboardName
        
        guard XYBundle.StoryboardFileIsExist(name: storyboardName) else { return nil }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let identifier: String = identifierOrNil ?? StoryboardIdentifier
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else { return nil }
        
        vc.initProperty()
        
        vc.view.xyFitSizeByNibNewView()
        
        return vc
    }
}

func LoadVCFromStoryboard<E: UIViewController>(storyboardName: String, identifier: String) -> E? {
    
    let storyboardName: String = storyboardName
    
    guard XYBundle.StoryboardFileIsExist(name: storyboardName) else { return nil }
    
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    
    guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? E else { return nil }
    
    if let protocolObj = vc as? XYNewSettingProtocol {
        
        protocolObj.initProperty()
    }

    vc.view.xyFitSizeByNibNewView()
    
    return vc
}
