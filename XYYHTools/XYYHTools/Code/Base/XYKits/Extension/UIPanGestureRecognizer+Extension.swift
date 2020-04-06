//
//  UIPanGestureRecognizer+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

extension UIPanGestureRecognizer {
    
    func directionByVelocityInView() -> UISwipeGestureRecognizer.Direction {
        
        let velocityPoint = self.velocity(in: self.view)
        
        let direction: UISwipeGestureRecognizer.Direction
        
        if 0 < velocityPoint.x {
            // 向右滑动
            direction = UISwipeGestureRecognizer.Direction.right
            
            XYLog.LogNote(msg: "directionByVelocityInView - 向右滑动")
            
        }else {
            // 向左滑动
            direction = UISwipeGestureRecognizer.Direction.left
            
            XYLog.LogNote(msg: "directionByVelocityInView - 向左滑动")
        }
        
        return direction
    }
}
