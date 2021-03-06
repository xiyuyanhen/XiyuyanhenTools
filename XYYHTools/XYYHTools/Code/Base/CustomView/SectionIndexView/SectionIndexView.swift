//
//  ViewController.swift
//  SectionIndexViewDemo
//
//  Created by 陈健 on 2018/3/13.
//  Copyright © 2018年 ChenJian. All rights reserved.
//

import UIKit


//MARK: - SectionIndexViewDataSource

@objc protocol SectionIndexViewDataSource: AnyObject {
    func numberOfItemViews(in sectionIndexView: SectionIndexView) -> Int
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemViewAt section: Int) -> SectionIndexViewItem
    
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, itemPreviewFor section: Int) -> SectionIndexViewItemPreview
}

//MARK: - SectionIndexViewDelegate

@objc protocol SectionIndexViewDelegate: AnyObject {
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int)
    
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheMoved section: Int)
    
    @objc optional func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheCancelled section: Int)
    
}


//MARK: - SectionIndexViewItemPreviewDirection
@objc enum SectionIndexViewItemPreviewDirection: Int {
    case left,right
}

//MARK: - SectionIndexView
class SectionIndexView: UIView {
    
    enum LayoutType {
        case Frame
        case AutoLayout
    }
    
    var layoutTypeCreated : LayoutType = .Frame
    
    
    class func CreateAutolayout(itemSize: CGSize) -> SectionIndexView{
        
        let sectionIndexView = SectionIndexView.newAutoLayout()
        sectionIndexView.layoutTypeCreated = .AutoLayout
        sectionIndexView.autoLayoutItemSize = itemSize
        
        return sectionIndexView
    }
    
    weak var dataSource: SectionIndexViewDataSource?
    weak var delegate:   SectionIndexViewDelegate?
    
    var isShowItemPreview: Bool = true
    
    var itemPreviewDirection: SectionIndexViewItemPreviewDirection = .left
    
    var itemPreviewMargin: CGFloat = 0
    
    var isItemPreviewAlwaysInCenter = false
    
    var itemHeight: CGFloat? {
        get {
            return _itemHeight
        }
    }

    var currentItem: SectionIndexViewItem? {
        get {
            return _currentItem
        }
    }
    
    
    //MARK: - private
    
    typealias ItemPreViewArray = Array<SectionIndexViewItemPreview>
    
    private var items : [SectionIndexViewItem] = [SectionIndexViewItem]()
    private var itemPreviews: ItemPreViewArray?
    
    private var _itemHeight: CGFloat?
    
    private var _currentItem: SectionIndexViewItem?
    
    private var touchItem: SectionIndexViewItem?
    
    fileprivate var currentItemPreview: UIView?
    
    // MARK: - Func
    private func loadData() {
        
        guard let numberOfItemViews = dataSource?.numberOfItemViews(in: self) else { return }
            
        guard self.layoutTypeCreated == .AutoLayout else {
            
            self.layoutByFrame(numberOfItemViews: numberOfItemViews)
            return
        }
        
        self.layoutByAutoLayout(numberOfItemViews: numberOfItemViews)

    }
    
    private func layoutByFrame(numberOfItemViews: Int) {
        
        let height = bounds.height / CGFloat(numberOfItemViews)
        _itemHeight = height
        self.itemPreviews = ItemPreViewArray()
        for i in 0..<numberOfItemViews {
            if let itemView = dataSource?.sectionIndexView(self, itemViewAt: i) {
                items.append(itemView)
                itemView.frame = CGRect.init(x: 0, y: height * CGFloat(i), width: bounds.width, height: height)
                addSubview(itemView)
            }
            if let itemPreview = dataSource?.sectionIndexView?(self, itemPreviewFor: i) {
                self.itemPreviews?.append(itemPreview)
            }
        }
    }
    
    var autoLayoutItemSize : CGSize = CGSize(width: FontSize(30).size, height: FontSize(12).size)
    var autoLayoutItemSpace : CGFloat = UIW(7)
    private func layoutByAutoLayout(numberOfItemViews: Int) {
        
        self._itemHeight = self.autoLayoutItemSize.height
        self.itemPreviews = ItemPreViewArray()
        
        var lastItemViewOrNil : SectionIndexViewItem?
        for i in 0 ..< numberOfItemViews {
            
            if let itemView = dataSource?.sectionIndexView(self, itemViewAt: i) {
                
                self.items.append(itemView)
                self.addSubview(itemView)
                
                itemView.autoSetDimensions(to: self.autoLayoutItemSize)
                
                if let lastItemView = lastItemViewOrNil {
                    
                    itemView.autoPinEdge(.top, to: .bottom, of: lastItemView, withOffset: self.autoLayoutItemSpace)
                    itemView.autoPinEdge(.trailing, to: .trailing, of: lastItemView, withOffset: 0)
                    
                }else{
                    
                    itemView.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, UIW(50), 0, 0), edges: .top, .leading, .trailing)
                }
                
                lastItemViewOrNil = itemView
            }
            
            if let itemPreview = dataSource?.sectionIndexView?(self, itemPreviewFor: i) {
                
                self.itemPreviews?.append(itemPreview)
            }
        }
        
        if let lastItemView = lastItemViewOrNil {
            
            lastItemView.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: 0)
        }
    }
    
    func reloadData() {
        
        for itemView in self.items {
            itemView.removeFromSuperview()
        }
        
        self.items.removeAll()
        
        self.loadData()
    }
    
    func item(at section: Int) -> SectionIndexViewItem? {
        if section >= items.count || section < 0 {
            return nil
        }
        return items[section]
    }
    
    func selectItem(at section: Int) {
        if section >= items.count || section < 0 {
            return
        }
        deselectCurrentItem()
        _currentItem = items[section]
        items[section].select()
    }
    
    func deselectCurrentItem() {
        _currentItem?.deselect()
    }
    
    func showItemPreview(at section:Int, hideAfter delay: Double) {
        showItemPreview(at: section)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.currentItemPreview?.removeFromSuperview()
        }
    }
    
    func showItemPreview(at section:Int) {
        guard
            isShowItemPreview == true,
            let count = self.itemPreviews?.count,
            section < count && section >= 0,
            let preview = self.itemPreviews?[section],
            let currentItem = _currentItem
            else { return }
        currentItemPreview?.removeFromSuperview()
        
        var x,
        y:CGFloat
        switch self.itemPreviewDirection {
        case .right:
            x = currentItem.bounds.width + preview.bounds.width * 0.5 + itemPreviewMargin
        case .left:
            x = -(preview.bounds.width * 0.5 + itemPreviewMargin)
        }
        let centerY = currentItem.center.y
        y = isItemPreviewAlwaysInCenter == true ? (bounds.height - currentItem.bounds.height) * 0.5 : centerY
        preview.center = CGPoint.init(x: x, y: y)
        
        addSubview(preview)
        currentItemPreview = preview
    }
    
    private func getSectionBy(touches: Set<UITouch>) -> Int? {
        if let touch = touches.first {
            let point = touch.location(in: self)
            var item: SectionIndexViewItem
            for i in 0..<items.count {
                item = items[i]
                
                var frame = item.frame
                frame.origin.x = 0
                frame.size.width = self.frame.size.width
                frame.size.height += self.autoLayoutItemSpace
                
                if frame.contains(point) == true {
                    return i
                }
            }
        }
        return nil
    }
    // MARK: - TouchesEvent
    override internal func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            var item: SectionIndexViewItem
            for i in 0..<items.count {
                item = items[i]
                if touchItem != item && point.y <= (item.frame.origin.y + item.frame.size.height) && point.y >= item.frame.origin.y {
                    if  delegate?.sectionIndexView?(self, toucheMoved: i) != nil {
                        //
                    } else {
                        selectItem(at: i)
                        showItemPreview(at: i)
                    }
                    touchItem = item
                    return
                }
            }
        }
    }
    
    override internal func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let section = getSectionBy(touches: touches) {
            if delegate?.sectionIndexView?(self, didSelect: section) != nil {
                //
            }else {
                selectItem(at: section)
                showItemPreview(at: section, hideAfter: 0.2)
            }
            return
        }
        
        for i in 0..<items.count {
            if items[i] == _currentItem {
                delegate?.sectionIndexView?(self, didSelect: i)
            }
        }
    }
    
    override internal func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let section = getSectionBy(touches: touches) {
            if delegate?.sectionIndexView?(self, toucheCancelled: section) != nil {
                //
            }else {
                currentItemPreview?.removeFromSuperview()
            }
        }
    }
}

