//
//  PureLayout+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/19.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

extension ALEdge: XYEnumTypeProtocol {
    
    var name: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .top: return "top"
        case .bottom: return "bottom"
        case .leading: return "leading"
        case .trailing: return "trailing"
        @unknown default: return "unknown"
        }
    }
}

// MARK: - Custom AutoLayout Function
extension UIView {
    
    convenience init(autoLayout:Bool = true) {
        
        self.init()
        
        if( autoLayout ) {
            
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupsSubView(subView: UIView?, edgeInsets: UIEdgeInsets) {
        
        setupsSupView(self, subView: subView, edgeInsets: edgeInsets)
    }
    
    func setupsSupView(_ supView: UIView?, subView: UIView?, edgeInsets: UIEdgeInsets) {
        
        if (supView == nil) {
            
            return
        }
        
        supView!.removeSubviews()
        
        if (subView != nil) {
            
            if let baseShadowView = supView as? BaseShadowView {
                
                baseShadowView.insertSubview(baseShadowView.bgCornerView, at: 0)
                
                baseShadowView.bgCornerView.autoEdgesPinView(otherView: baseShadowView)
            }
            
            supView!.addSubview(subView!)
            
            subView!.autoEdgesPinView(otherView: supView!, edgeInsets: edgeInsets)
        }
    }
    
    @discardableResult
    func autoEdgesPinView(otherView:UIView, relation: NSLayoutConstraint.Relation = .equal) -> NSArray {
        
        let edgelcs = self.autoEdgesPinView(otherView: otherView, edgeInsets: UIEdgeInsets.zero, relation:relation)
        
        return edgelcs
    }
    
    @discardableResult
    func autoEdgesPinView(otherView:UIView, edgeInsets:UIEdgeInsets, relation: NSLayoutConstraint.Relation = .equal) -> NSArray {
        
        let oneEdges = NSMutableArray(array: [ALEdge.top, ALEdge.leading, ALEdge.bottom, ALEdge.trailing])
        
        let otherEdges = NSMutableArray(array: [ALEdge.top, ALEdge.leading, ALEdge.bottom, ALEdge.trailing])
        
        let edgelcs = self.autoPinView(otherView: otherView, edgeInsets: edgeInsets, oneEdges:oneEdges, otherEdges: otherEdges, relation:relation)
        
        return edgelcs
    }
    
    @discardableResult
    func autoTopPinViewBottom(otherView:UIView, relation: NSLayoutConstraint.Relation = .equal, edges:ALEdge...) -> NSArray {
        
        let oneEdges = NSMutableArray(array: edges)
        oneEdges.add(ALEdge.top)
        
        let otherEdges = NSMutableArray(array: edges)
        otherEdges.add(ALEdge.bottom)
        
        let edgelcs = self.autoPinView(otherView: otherView, edgeInsets: UIEdgeInsets.zero, oneEdges:oneEdges, otherEdges: otherEdges, relation:relation)
        
        return edgelcs
    }
    
    @discardableResult
    func autoTopPinViewBottom(otherView:UIView, edgeInsets:UIEdgeInsets, relation: NSLayoutConstraint.Relation = .equal, edges:ALEdge...) -> NSArray {
        
        let oneEdges = NSMutableArray(array: edges)
        oneEdges.add(ALEdge.top)
        
        let otherEdges = NSMutableArray(array: edges)
        otherEdges.add(ALEdge.bottom)
        
        let edgelcs = self.autoPinView(otherView: otherView, edgeInsets: edgeInsets, oneEdges:oneEdges, otherEdges: otherEdges, relation:relation)
        
        return edgelcs
    }
    
    @discardableResult
    func autoLeadingPinViewTrailing(otherView:UIView, relation: NSLayoutConstraint.Relation = .equal, edges:ALEdge...) -> NSArray {
        
        let oneEdges = NSMutableArray(array: edges)
        oneEdges.add(ALEdge.leading)
        
        let otherEdges = NSMutableArray(array: edges)
        otherEdges.add(ALEdge.trailing)
        
        let edgelcs = self.autoPinView(otherView: otherView, edgeInsets: UIEdgeInsets.zero, oneEdges:oneEdges, otherEdges: otherEdges, relation:relation)
        
        return edgelcs
    }
    
    @discardableResult
    func autoLeadingPinViewTrailing(otherView:UIView, edgeInsets:UIEdgeInsets, relation: NSLayoutConstraint.Relation = .equal, edges:ALEdge...) -> NSArray {
        
        let oneEdges = NSMutableArray(array: edges)
        oneEdges.add(ALEdge.leading)
        
        let otherEdges = NSMutableArray(array: edges)
        otherEdges.add(ALEdge.trailing)
        
        let edgelcs = self.autoPinView(otherView: otherView, edgeInsets: edgeInsets, oneEdges:oneEdges, otherEdges: otherEdges, relation:relation)
        
        return edgelcs
    }
    
    @discardableResult
    func autoPinView(otherView:UIView, relation: NSLayoutConstraint.Relation = .equal, edges:ALEdge...) -> NSArray {
        
        let oneEdges = edges as NSArray
        let otherEdges = edges as NSArray
        
        let edgelcs = self.autoPinView(otherView: otherView, edgeInsets: UIEdgeInsets.zero, oneEdges: oneEdges, otherEdges: otherEdges, relation:relation)
        
        return edgelcs
    }
    
    @discardableResult
    func autoPinView(otherView:UIView, edgeInsets:UIEdgeInsets, relation: NSLayoutConstraint.Relation = .equal, edges:ALEdge...) -> NSArray {
        
        let oneEdges = edges as NSArray
        let otherEdges = edges as NSArray
        
        let edgelcs = self.autoPinView(otherView: otherView, edgeInsets: edgeInsets, oneEdges: oneEdges, otherEdges: otherEdges, relation:relation)
        
        return edgelcs
    }
    
    private func autoPinView(otherView:UIView, edgeInsets:UIEdgeInsets, oneEdges:NSArray, otherEdges:NSArray, relation: NSLayoutConstraint.Relation) -> NSArray {
        
        if oneEdges.count == 0 {
            
            return NSArray();
        }
        
        let lcArr = NSMutableArray.init(capacity: oneEdges.count)
        
        for i in 0...(oneEdges.count-1) {
            
            let oneEdge = oneEdges[i]
            let otherEdge = otherEdges[i]
            
            let oneAledge = oneEdge as! ALEdge
            let otherAledge = otherEdge as! ALEdge
            
            var offset:CGFloat
            
            switch oneAledge {
                
            case ALEdge.top :
                offset = edgeInsets.top;
                break
                
            case ALEdge.left:
                offset = edgeInsets.left;
                break
                
            case .right:
                offset = edgeInsets.right;
                break
                
            case .bottom:
                offset = edgeInsets.bottom;
                break
                
            case .leading:
                offset = edgeInsets.left;
                break
                
            case .trailing:
                offset = edgeInsets.right;
                break
            }
            
            let edgeLC = self.autoPinEdge(oneAledge, to: otherAledge, of: otherView, withOffset: offset, relation: relation);
            
            switch oneAledge {
            case ALEdge.top :
                self.xyLayoutConstraints.top = edgeLC
                break
                
            case ALEdge.left, ALEdge.leading:
                self.xyLayoutConstraints.leading = edgeLC
                break
                
            case ALEdge.right, ALEdge.trailing:
                self.xyLayoutConstraints.trailing = edgeLC
                break
                
            case ALEdge.bottom:
                self.xyLayoutConstraints.bottom = edgeLC
                break
            }
            
            lcArr.add(edgeLC)
            
        }
        
        let resultArr = NSArray(array: lcArr)
        
        return resultArr
    }
}

// MARK: - 替换主干方法以使用xyLayoutConstraints参数
extension BaseView {
    
    @discardableResult
    open override func autoPinEdge(_ edge: ALEdge, to toEdge: ALEdge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoPinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: relation)
        
        switch edge {
            
        case ALEdge.top:
            self.xyLayoutConstraints.top = constraint
            break
            
        case ALEdge.leading:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.left:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.trailing:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.right:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.bottom:
            self.xyLayoutConstraints.bottom = constraint
            break
            
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoSetDimension(_ dimension: ALDimension, toSize size: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoSetDimension(dimension, toSize: size, relation: relation)
        
        switch dimension {
        case ALDimension.width:
            self.xyLayoutConstraints.width = constraint
            break
            
        case ALDimension.height:
            self.xyLayoutConstraints.height = constraint
            break
            
        }
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withOffset: offset)
        switch axis {
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withMultiplier: multiplier)
        
        switch axis {
            
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        return constraint
    }
}

extension UILabel {
    
    @discardableResult
    open override func autoPinEdge(_ edge: ALEdge, to toEdge: ALEdge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoPinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: relation)
        
        switch edge {
            
        case ALEdge.top:
            self.xyLayoutConstraints.top = constraint
            break
            
        case ALEdge.leading:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.left:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.trailing:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.right:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.bottom:
            self.xyLayoutConstraints.bottom = constraint
            break
            
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoSetDimension(_ dimension: ALDimension, toSize size: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoSetDimension(dimension, toSize: size, relation: relation)
        
        switch dimension {
        case ALDimension.width:
            self.xyLayoutConstraints.width = constraint
            break
            
        case ALDimension.height:
            self.xyLayoutConstraints.height = constraint
            break
            
        }
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withOffset: offset)
        switch axis {
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withMultiplier: multiplier)
        
        switch axis {
            
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        return constraint
    }
}

extension UIImageView {
    
    @discardableResult
    open override func autoPinEdge(_ edge: ALEdge, to toEdge: ALEdge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoPinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: relation)
        
        switch edge {
            
        case ALEdge.top:
            self.xyLayoutConstraints.top = constraint
            break
            
        case ALEdge.leading:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.left:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.trailing:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.right:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.bottom:
            self.xyLayoutConstraints.bottom = constraint
            break
            
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoSetDimension(_ dimension: ALDimension, toSize size: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoSetDimension(dimension, toSize: size, relation: relation)
        
        switch dimension {
        case ALDimension.width:
            self.xyLayoutConstraints.width = constraint
            break
            
        case ALDimension.height:
            self.xyLayoutConstraints.height = constraint
            break
            
        }
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withOffset: offset)
        switch axis {
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withMultiplier: multiplier)
        
        switch axis {
            
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        return constraint
    }
}

extension UIButton {
    
    @discardableResult
    open override func autoPinEdge(_ edge: ALEdge, to toEdge: ALEdge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoPinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: relation)
        
        switch edge {
            
        case ALEdge.top:
            self.xyLayoutConstraints.top = constraint
            break
            
        case ALEdge.leading:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.left:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.trailing:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.right:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.bottom:
            self.xyLayoutConstraints.bottom = constraint
            break
            
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoSetDimension(_ dimension: ALDimension, toSize size: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoSetDimension(dimension, toSize: size, relation: relation)
        
        switch dimension {
        case ALDimension.width:
            self.xyLayoutConstraints.width = constraint
            break
            
        case ALDimension.height:
            self.xyLayoutConstraints.height = constraint
            break
            
        }
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withOffset: offset)
        switch axis {
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withMultiplier: multiplier)
        
        switch axis {
            
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        return constraint
    }
}

extension UITextField {
    
    @discardableResult
    open override func autoPinEdge(_ edge: ALEdge, to toEdge: ALEdge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoPinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: relation)
        
        switch edge {
            
        case ALEdge.top:
            self.xyLayoutConstraints.top = constraint
            break
            
        case ALEdge.leading:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.left:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.trailing:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.right:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.bottom:
            self.xyLayoutConstraints.bottom = constraint
            break
            
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoSetDimension(_ dimension: ALDimension, toSize size: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoSetDimension(dimension, toSize: size, relation: relation)
        
        switch dimension {
        case ALDimension.width:
            self.xyLayoutConstraints.width = constraint
            break
            
        case ALDimension.height:
            self.xyLayoutConstraints.height = constraint
            break
            
        }
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withOffset: offset)
        switch axis {
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withMultiplier: multiplier)
        
        switch axis {
            
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        return constraint
    }
}

extension UIScrollView {
    
    @discardableResult
    open override func autoPinEdge(_ edge: ALEdge, to toEdge: ALEdge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoPinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: relation)
        
        switch edge {
            
        case ALEdge.top:
            self.xyLayoutConstraints.top = constraint
            break
            
        case ALEdge.leading:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.left:
            self.xyLayoutConstraints.leading = constraint
            break
            
        case ALEdge.trailing:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.right:
            self.xyLayoutConstraints.trailing = constraint
            break
            
        case ALEdge.bottom:
            self.xyLayoutConstraints.bottom = constraint
            break
            
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoSetDimension(_ dimension: ALDimension, toSize size: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoSetDimension(dimension, toSize: size, relation: relation)
        
        switch dimension {
        case ALDimension.width:
            self.xyLayoutConstraints.width = constraint
            break
            
        case ALDimension.height:
            self.xyLayoutConstraints.height = constraint
            break
            
        }
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withOffset: offset)
        switch axis {
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        
        return constraint
    }
    
    @discardableResult
    open override func autoAlignAxis(_ axis: ALAxis, toSameAxisOf otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint = super.autoAlignAxis(axis, toSameAxisOf: otherView, withMultiplier: multiplier)
        
        switch axis {
            
        case ALAxis.horizontal:
            self.xyLayoutConstraints.horizontal = constraint
            break
            
        case ALAxis.vertical:
            self.xyLayoutConstraints.vertical = constraint
            break
            
        default:
            break
        }
        return constraint
    }
}
