//
//  CGRect+Extension.swift
//  KL100
//
//  Created by 细雨湮痕 on 2020/4/26.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation

extension CGRect {
    
    var isZero: Bool {
        
        return 0 == (self.width + self.height)
    }
}
