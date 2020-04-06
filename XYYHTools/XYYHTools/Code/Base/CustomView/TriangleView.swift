//
//  TriangleView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/14.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

/// 方向
enum XYDirectEdge {
    case TopLeft
    case Top
    case TopRight
    case Right
    case BottomRight
    case Bottom
    case BottomLeft
    case Left
}

class TriangleView : BaseView {
    
    var triangleDirectEdge: XYDirectEdge = XYDirectEdge.Top
    
    convenience init(directEdge edge: ALEdge) {
        
        self.init()
    }
    
    override func initProperty() {
        super.initProperty()
        
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.layer.mask = self.cutTriangle(self.bounds, directEdge: self.triangleDirectEdge)
        
    }
    
    // MARK: - 切割成三角形View
    /**
     *    @description 切割成三角形View
     *
     *    @param    originalFrame
     *
     *    @param    directEdge    切割方向
     *
     *    @return   CAShapeLayer(遮罩图层)
     */
    func cutTriangle(_ originalFrame: CGRect, directEdge edge: XYDirectEdge) -> CAShapeLayer {
        
        let rect: CGRect = originalFrame
        
        let width: CGFloat = rect.size.width
        let height: CGFloat = rect.size.height
        
        let bezierPath = UIBezierPath()
        
        let pointTL = CGPoint(x: 0, y: 0)
        let pointTM = CGPoint(x: width / 2, y: 0)
        let pointTR = CGPoint(x: width, y: 0)
        let pointML = CGPoint(x: 0, y: height / 2)
        let pointMR = CGPoint(x: width, y: height / 2)
        let pointBL = CGPoint(x: 0, y: height)
        let pointBM = CGPoint(x: width / 2, y: height)
        let pointBR = CGPoint(x: width, y: height)
        
        switch edge {
        case .TopLeft:
            bezierPath.move(to: pointTL)
            bezierPath.addLine(to: pointTR)
            bezierPath.addLine(to: pointBL)
            bezierPath.addLine(to: pointTL)
            break
        case .Top:
            bezierPath.move(to: pointTM)
            bezierPath.addLine(to: pointBR)
            bezierPath.addLine(to: pointBL)
            bezierPath.addLine(to: pointTM)
            break
        case .TopRight:
            bezierPath.move(to: pointTL)
            bezierPath.addLine(to: pointTR)
            bezierPath.addLine(to: pointBR)
            bezierPath.addLine(to: pointTL)
            break
        case .Right:
            bezierPath.move(to: pointTL)
            bezierPath.addLine(to: pointMR)
            bezierPath.addLine(to: pointBL)
            bezierPath.addLine(to: pointTL)
            break
        case .BottomRight:
            bezierPath.move(to: pointTR)
            bezierPath.addLine(to: pointBR)
            bezierPath.addLine(to: pointBL)
            bezierPath.addLine(to: pointTR)
            break
        case .Bottom:
            bezierPath.move(to: pointTL)
            bezierPath.addLine(to: pointTR)
            bezierPath.addLine(to: pointBM)
            bezierPath.addLine(to: pointTL)
            break
        case .BottomLeft:
            bezierPath.move(to: pointTL)
            bezierPath.addLine(to: pointBR)
            bezierPath.addLine(to: pointBL)
            bezierPath.addLine(to: pointTL)
            break
        case .Left:
            bezierPath.move(to: pointTR)
            bezierPath.addLine(to: pointBR)
            bezierPath.addLine(to: pointML)
            bezierPath.addLine(to: pointTR)
            break
        }
        
        bezierPath.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        
        return maskLayer
        
    }
}
