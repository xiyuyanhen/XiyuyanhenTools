//
//  BaseCollectionViewCell.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/19.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseCollectionViewCell: UICollectionViewCell {
    
    /// Cell的显示位置
    var xyIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    lazy var cellView: BaseView = {
        
        return BaseView.newAutoLayout()
    }()
    
    lazy var longPressGR: UILongPressGestureRecognizer = {
        
        let longPressGR = UILongPressGestureRecognizer()
        
//        longPressGR.rx.event.subscribe(onNext: { (gr) in
//
//
//        }) {
//            XYLog.LogNoteBlock { () -> String? in
//
//            return "BaseCollectionViewCell.longPressGR.rx.Disposed"
//        }
//        }.disposed(by: self.disposeBag)
        
        self.cellView.addGestureRecognizer(longPressGR)
        
        return longPressGR
    }()
    
    lazy var rxLongPressGR_Began: Observable<UILongPressGestureRecognizer> = {
        
        let observable = self.longPressGR.rx.event.filter({ (lpGR) -> Bool in
            
            return (lpGR.state == UIGestureRecognizer.State.began)
        })
        
        return observable
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.initProperty()
        self.layoutAddViews()
        self.layoutAllViews()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 若Cell被复用，则新建并替换 DisposeBag
        self.rxReuseDisposeBag = DisposeBag()
    }
    
    func initProperty() {
        
        
    }
    
    func layoutAddViews() {
        
        self.contentView.addSubview(self.cellView)
    }
    
    func layoutAllViews() {
        
        self.cellView.autoEdgesPinView(otherView: self.contentView, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    func cellSize() -> CGSize{
        
        self.layoutIfNeeded()
        
        let size = self.bounds.size
        
        return size
    }
    
    deinit {
        
        XYLog.LogNote(msg: "\(self.className) -- deinit")
    }
}



