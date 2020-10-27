//
//  XYObject.swift
//  XYStudio
//
//  Created by Xiyuyanhen on 2017/8/3.
//  Copyright © 2017年 XyyH. All rights reserved.
//

import Foundation


class XYObject: NSObject, ModelProtocol_Array, XYObjectProtocol {
    
    override init() {
        super.init()
        
        #if DEBUG
        
        //DebugToolsManage.AddForObjectRetain(self.xyClassName)

        #else
        #endif
    }
    
    deinit {
        
        #if DEBUG
        
        //DebugToolsManage.ReduceForObjectRetain(self.xyClassName)
           
        #else
        #endif
        
        XYLog.LogNote(msg: "\(self.xyClassName) -- deinit")
    }
    
}

// MARK: - XYObjectProtocol
protocol XYObjectProtocol {
    
    
}

extension XYObjectProtocol where Self : XYObject {
    
    
    
    
}


