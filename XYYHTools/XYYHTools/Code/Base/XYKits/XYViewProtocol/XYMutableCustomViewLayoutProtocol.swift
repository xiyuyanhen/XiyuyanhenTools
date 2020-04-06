//
//  XYMutableCustomViewLayoutProtocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/18.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - UIView Extension
extension UIView : XYMutableCustomViewLayoutProtocol { }

struct XYMutableCustomViewLayoutConfig : Equatable {
    
    let containerViewOrNil: UIView?
    let removedSubViews : Bool
    let edgesInsets : UIEdgeInsets
    
    /// 末尾的视图是否与容器关联
    var closedByLast: Bool = true
    
    /// 一行应容纳的单元数
    var columnNumOrNil : Int?
    
    /// 一行中的cell视图是否互相相等
    var isEqualByRowCellsOrNil: Bool?
    
    /// cell的约束关系
    var cellViewRelation : NSLayoutConstraint.Relation = NSLayoutConstraint.Relation.equal
    
    /// 布局方向
    var priorityLayoutForCellOrNil: ALEdge?
    
    init() {
        
        self.containerViewOrNil = nil
        self.removedSubViews = true
        self.edgesInsets = UIEdgeInsets.zero
    }
    
    init(containerView containerViewOrNil: UIView?, removedSubViews : Bool = true, edgesInsets : UIEdgeInsets = UIEdgeInsets.zero) {
        
        self.containerViewOrNil = containerViewOrNil
        self.removedSubViews = removedSubViews
        self.edgesInsets = edgesInsets
    }
    
    
}

protocol XYMutableCustomViewLayoutProtocol : UIView {
  
    typealias CreatedViewBlockResult = (cellSpace: CGFloat, view: Self)
    
    typealias CreatedMultipleViewBlockResult = (rowSpace: CGFloat, sectionSpace: CGFloat, view: Self)
}

extension XYMutableCustomViewLayoutProtocol {
    
    /// 垂直布局
    @discardableResult static func VerticalLayout<M>(modelArr: [M], config: XYMutableCustomViewLayoutConfig, createdBlock: ((_ index: Int, _ model:M) -> CreatedViewBlockResult?)) -> (containerView: UIView, itemViews: [Self]) {
        
        let containerView: UIView
        if let cView = config.containerViewOrNil {
            
            containerView = cView
            
            if config.removedSubViews {
                
                containerView.removeSubviews()
            }
            
        }else {
            
            containerView = UIView.newAutoLayout()
        }
        
        var itemViewArr : [Self] = [Self]()
        var lastViewOrNil:Self?
        for (index, model) in modelArr.enumerated() {
            
            guard let (cellSpace, modelView) = createdBlock( index, model) else { continue }
            
            itemViewArr.append(modelView)
            containerView.addSubview(modelView)
            
            if let lastView = lastViewOrNil {
                
                modelView.autoTopPinViewBottom(otherView: lastView, edgeInsets: UIEdgeInsetsMake(cellSpace, 0, 0, 0), edges: .leading)
                modelView.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: config.edgesInsets.right, relation: config.cellViewRelation)
                
            }else{
                
                modelView.autoPinView(otherView: containerView, edgeInsets: config.edgesInsets, edges: .top, .leading)
                modelView.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: config.edgesInsets.right, relation: config.cellViewRelation)
            }
            
            lastViewOrNil = modelView
        }
        
        if config.closedByLast,
            let lastView = lastViewOrNil {
            
            lastView.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: config.edgesInsets.bottom)
        }
        
        return (containerView, itemViewArr)
    }
}

extension XYMutableCustomViewLayoutProtocol {

    /// 水平布局
    @discardableResult static func HorizontalLayout<M>(modelArr: [M], config: XYMutableCustomViewLayoutConfig, createdBlock: ((_ index: Int,_ model:M) -> CreatedViewBlockResult?)) -> (containerView: UIView, itemViews: [Self]) {
        
        let containerView: UIView
        if let cView = config.containerViewOrNil {
            
            containerView = cView
            
            if config.removedSubViews {
                
                containerView.removeSubviews()
            }
            
        }else {
            
            containerView = UIView.newAutoLayout()
        }
        
        var itemViewArr : [Self] = [Self]()
        var lastViewOrNil:Self?
        for (index, model) in modelArr.enumerated() {
            
            guard let (cellSpace, modelView) = createdBlock( index, model) else { continue }
            
            itemViewArr.append(modelView)
            containerView.addSubview(modelView)
            
            if let lastView = lastViewOrNil {
                
                modelView.autoLeadingPinViewTrailing(otherView: lastView, edgeInsets: UIEdgeInsetsMake(0, cellSpace, 0, 0), edges: .top, .bottom)
                
            }else{
                
                modelView.autoPinView(otherView: containerView, edgeInsets: config.edgesInsets, edges: .top, .leading, .bottom)
            }
            
            lastViewOrNil = modelView
        }
        
        if config.closedByLast,
            let lastView = lastViewOrNil {
            
            lastView.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: config.edgesInsets.right)
        }
        
        return (containerView, itemViewArr)
    }
}

extension XYMutableCustomViewLayoutProtocol {
    
    /// 垂直网格状布局
    @discardableResult static func MultipleCellLayout<M>(modelArr: [M], config: XYMutableCustomViewLayoutConfig, createdBlock: ((_ index: Int,_ model:M) -> CreatedMultipleViewBlockResult?)) -> (containerView: UIView, itemViews: [Self]) {
        
        guard let columnNum = config.columnNumOrNil else {
            
            fatalError("缺少参数: columnNum")
        }
        
        guard let isEqualByRowCells = config.isEqualByRowCellsOrNil else {
            
            fatalError("缺少参数: isEqualByRowCells")
        }
        
        let containerView: UIView
        if let cView = config.containerViewOrNil {
            
            containerView = cView
            
            containerView.removeSubviews()
            
        }else {
            
            containerView = UIView.newAutoLayout()
        }
        
        var itemViewArr : [Self] = [Self]()
        
        var rowItemViewArr : [Self] = [Self]()
        
        var fistViewOrNil : Self?
        var lastViewOrNil : Self?
        for (index, model) in modelArr.enumerated() {
            
            guard let (rowSpace, sectionSpace, modelView) = createdBlock( index, model) else { continue }
            
            let row = index % columnNum
            
            itemViewArr.append(modelView)
            rowItemViewArr.append(modelView)
            
            containerView.addSubview(modelView)
            
            if let lastView = lastViewOrNil {
                
                if row == 0 {
                    //一行中的第一个
                    
                    modelView.autoPinEdge(.top, to: .bottom, of: lastView, withOffset: sectionSpace)
                    modelView.autoPinEdge(.leading, to: .leading, of: containerView, withOffset: config.edgesInsets.left)
                    
                }else {
                    
                    
                    modelView.autoPinEdge(.top, to: .top, of: lastView, withOffset: 0)
                    modelView.autoPinEdge(.leading, to: .trailing, of: lastView, withOffset: rowSpace)
                    
                    if row == (columnNum-1)  {
                        //一行中的最后一个
                        
                        modelView.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: config.edgesInsets.right)
                        
                        if isEqualByRowCells {
                            
                            //一行中的所有View 宽度相同
                            (rowItemViewArr as NSArray).autoMatchViewsDimension(.width)
                        }
                        
                        rowItemViewArr.removeAll()
                    }
                }
                
            }else{
                
                fistViewOrNil = modelView
                
                modelView.autoPinView(otherView: containerView, edgeInsets: config.edgesInsets, edges: .top, .leading)
                
            }
            
            lastViewOrNil = modelView
        }
        
        if let lastView = lastViewOrNil {
            
            if isEqualByRowCells,
                let fistView = fistViewOrNil,
                rowItemViewArr.isNotEmpty {
                
                rowItemViewArr.append(fistView)
                
                (rowItemViewArr as NSArray).autoMatchViewsDimension(.width)
                
                rowItemViewArr.removeAll()
            }
            
            lastView.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: config.edgesInsets.bottom)
        }
        
        return (containerView, itemViewArr)
    }

}

// MARK: - 瀑布流布局
extension XYMutableCustomViewLayoutProtocol {
    
    /// 垂直网格状布局
    @discardableResult static func MultipleCellWaterfallsFlowVerticalLayout<M>(modelArr: [M], config: XYMutableCustomViewLayoutConfig, createdBlock: ((_ index: Int,_ model:M) -> CreatedMultipleViewBlockResult?)) -> (containerView: UIView, itemViews: [Self])? {
        
        guard let containerView = config.containerViewOrNil,
            let priorityLayoutForCellUnknow = config.priorityLayoutForCellOrNil else {
               
            fatalError("参数缺失！")
        }
        
        /// 约束方向
        let priorityLayoutForCellIsLeading: Bool
    
        if (priorityLayoutForCellUnknow == .leading) || (priorityLayoutForCellUnknow == .left) {
            
            priorityLayoutForCellIsLeading = true
            
        }else if (priorityLayoutForCellUnknow == .trailing) || (priorityLayoutForCellUnknow == .right) {
            
            priorityLayoutForCellIsLeading = false
            
        }else {
            
            fatalError("参数不规范！")
        }
        
        
        containerView.layoutIfNeeded()
        
        /// 视图宽度
        let containerViewWidth: CGFloat = containerView.frame.size.width
        
        guard 0.0 < containerViewWidth,
            modelArr.isNotEmpty else {
            
            config.removedSubViews.xyRunBlockWhenTrue {
                
                containerView.removeSubviews()
            }
            return nil
        }
        
        config.removedSubViews.xyRunBlockWhenTrue { containerView.removeSubviews() }
        
        var itemViewArr : [Self] = [Self]()
        
        /// 水平基准间距
        let baseSpaceForH: CGFloat = priorityLayoutForCellIsLeading.xyReturn(config.edgesInsets.left, -config.edgesInsets.right)
        
        /// 视图的水平间距
        var modelViewHSpace: CGFloat = baseSpaceForH
        
        /// 视图的垂直间距
        var modelViewVSpace: CGFloat = config.edgesInsets.top
        
        /// 当前剩余宽度
        var rowRemainWidth: CGFloat = containerViewWidth - baseSpaceForH
        
        /// 所有视图中的最后一个
        var lastViewOrNil : Self?
        
        for (index, model) in modelArr.enumerated() {
            
            guard let (rowSpace, sectionSpace, modelView) = createdBlock( index, model) else { continue }
            
            modelView.layoutIfNeeded()
            
            itemViewArr.append(modelView)
            
            let modelViewWidth = modelView.frame.size.width
            let modelViewHeight = modelView.frame.size.height
            
            /// 减少的宽度
            let needWidth = modelViewWidth + rowSpace
            
            var newline: Bool = false
            
            if containerViewWidth < modelViewWidth {
                
                // 需要的宽度大于容器视图所能提供的宽度
                
                if config.edgesInsets.left < modelViewHSpace {
                    
                    // 位置不是当前行的第一个位置，换行显示
                    
                    newline = true
                }
            
            }else if rowRemainWidth < needWidth {
                
                // 当前行剩余宽度小于需要的宽度，换行
                
                newline = true
                
            }
            
            newline.xyRunBlockWhenTrue {
                
                // 换行处理
                
                modelViewHSpace = baseSpaceForH
                
                modelViewVSpace += (sectionSpace + modelViewHeight)
                
                rowRemainWidth = containerViewWidth - baseSpaceForH
            }
            
            containerView.addSubview(modelView)
            
            priorityLayoutForCellIsLeading.xyRunBlock({
                
                modelView.autoPinView(otherView: containerView, edgeInsets: UIEdgeInsets(top: modelViewVSpace, left: modelViewHSpace, bottom: 0, right: 0), edges: .top, .leading)
            }) {
                
                modelView.autoPinView(otherView: containerView, edgeInsets: UIEdgeInsets(top: modelViewVSpace, left: 0, bottom: 0, right: -modelViewHSpace), edges: .top, .trailing)
            }
            
            modelViewHSpace += needWidth
            
            rowRemainWidth -= needWidth
            
            lastViewOrNil = modelView
        }
        
        if let lastView = lastViewOrNil {
            
            lastView.autoPinEdge(.bottom, to: .bottom, of: containerView, withOffset: config.edgesInsets.bottom)
        }
        
        return (containerView, itemViewArr)
    }
}
