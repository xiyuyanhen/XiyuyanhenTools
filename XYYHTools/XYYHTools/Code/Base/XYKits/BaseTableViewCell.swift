//
//  BaseTableViewCell.swift
//  DPTools
//
//  Created by DragonPass on 2018/1/31.
//  Copyright © 2018年 Dragonpass. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseTableViewCell: UITableViewCell, XYNewSettingProtocol {
    
    /// Cell的显示位置
    var xyIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    lazy var cellView: BaseView = {
        
        return BaseView.newAutoLayout()
    }()
    
    lazy var longPressGR: UILongPressGestureRecognizer = {
        
        let longPressGR = UILongPressGestureRecognizer()
        
        self.addGestureRecognizer(longPressGR)
        
        return longPressGR
    }()
    
    lazy var rxLongPressGR_Began: Observable<UILongPressGestureRecognizer> = {
        
        let observable = self.longPressGR.rx.event.filter({ (lpGR) -> Bool in
            
            return (lpGR.state == UIGestureRecognizer.State.began)
        })
        
        return observable
    }()
    
    var xyAllowTouch : Bool = true //允许TableViewCell点击事件
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
    }

    /**
     *    @description 将实时渲染的代码放到 prepareForInterfaceBuild() 方法中，该方法并不会在程序运行时调用
     *
     */
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.initProperty()
        self.layoutAddViews()
        self.layoutAllViews()
    }
    
    /// 用于Cell重用时清除Rx观察者行为
    lazy var rxReuseDisposeBag: DisposeBag = {
        
        return DisposeBag()
    }()
    
    /**
     *    @description cell被重用
     *
     *  当前已经被分配的cell如果被重用了(通常是滚动出屏幕外了),会调用cell的prepareForReuse通知cell
     *
     *  在从dequeueReusableCellWithIdentifier取出之后,如果需要做一些额外的计算,比如说计算cell高度, 可以手动调用 prepareForReuse方法.手动调用,以确保与实际cell(显示在屏幕上)行为一致。
     *  cell = [self dequeueReusableCellWithIdentifier:identifier];
     *  [cell prepareForReuse];
     *
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // ...
        
        // 若Cell被复用，则新建并替换 DisposeBag
        self.rxReuseDisposeBag = DisposeBag()
    }
    
    func initProperty() {
        
        
    }
    
    override func updateConstraints() {
        
        XYLog.LogNote(msg: "\(self.xyClassName).updateConstraints xyIsDidUpdateConstraints:\(self.xyIsDidUpdateConstraints)")
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
        
    }
    
    func layoutAddViews() {
        
        XYLog.LogNote(msg: "\(self.xyClassName).layoutAddViews")
        
        self.contentView.addSubview(self.cellView)
    }
    
    func layoutAllViews() {
        
        XYLog.LogNote(msg: "\(self.xyClassName).layoutAllViews")
        
        self.cellView.autoEdgesPinView(otherView: self.contentView, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    var cellViewTapGROrNil : UITapGestureRecognizer? = nil
    
    deinit {
        
        XYLog.LogNote(msg: "\(self.xyClassName) -- deinit")
    }
    
    override func addSubview(_ view: UIView) {
        
        // 去掉系统分隔线
        guard view.xyClassName != "_UITableViewCellSeparatorView" else { return }
        
        super.addSubview(view)
    }
}

extension BaseTableViewCell {
    
    func setCellViewTapGR(needClear: Bool = false) {
        
        guard needClear == false else {
            
            
            if let tapGR = self.cellViewTapGROrNil {
                
                //移除手势
                self.cellView.removeGestureRecognizer(tapGR)
                self.cellViewTapGROrNil = nil
            }
            
            return
        }
        
        guard let tapGR = self.cellViewTapGROrNil,
            let cellViewGRArr = self.cellView.gestureRecognizers,
            0 < cellViewGRArr.count,
            cellViewGRArr.contains(tapGR) else {
                
                //添加手势
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.cellViewTapGRHandle(tapGR:)))
                self.cellView.addGestureRecognizer(tapGR)
                self.cellViewTapGROrNil = tapGR
                
                return
        }
        
        return
    }
    
    @objc func cellViewTapGRHandle(tapGR : UITapGestureRecognizer) {
        
        
    }
}

// MARK: - Touches
extension BaseTableViewCell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard self.xyAllowTouch else {
            
            return
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    //    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    //
    //        let resultViewOrNil : UIView? = super.hitTest(point, with: event)
    //
    //        guard self == resultViewOrNil  else {
    //
    //            return resultViewOrNil
    //        }
    //
    //        guard self.xyAllowTouch else {
    //
    //            return nil
    //        }
    //
    //        return self
    //    }
}

extension BaseTableViewCell {
    
    var superTableViewOrNil : UITableView? {
        
        if let tableView = self.superview as? UITableView {
            
            return tableView
            
        }else if let tableView = self.superview?.superview as? UITableView {
            
            return tableView
        }
        
        return nil
    }
}
