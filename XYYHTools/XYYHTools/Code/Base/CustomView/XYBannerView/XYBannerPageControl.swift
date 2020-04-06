//
//  XYBannerPageControl.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/25.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation


@objc protocol XYPageControlDelegate {
    
    @objc optional func pageControlItemSize(forNumberOfPages pageCount: UInt) -> CGSize
}

class XYPageControl: UIView, XYViewNewAutoLayoutProtocol {
    
    var delegate : XYPageControlDelegate?
    
    var itemDefaultSize = CGSize(width: UIW(6), height: UIW(6))
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initProperty()
        self.layoutAddViews()
        self.layoutAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initProperty() {
        
    }
    
    func layoutAddViews() {
        
    }
    
    func layoutAllViews() {
        
    }
    
    private var _numberOfPages : UInt = 0
    var numberOfPages: UInt {// default is 0
        
        get{
            
            return self._numberOfPages
        }
        
        set{
            
            self._numberOfPages = newValue
            
            self.isHiddenByNumberOfPages()
        }
    }
    
    private var _currentPage: UInt = 0 // default is 0. value pinned to 0..numberOfPages-1
    var currentPage: UInt {
        
        get{
            
            return self._currentPage
        }
        
        set{
            
            if newValue >= self.numberOfPages {
                
                self._currentPage = 0
            }else{
                
                self._currentPage = newValue
            }
            
            self.reSetups()
        }
    }

    private var _hidesForSinglePage : Bool = false
    var hidesForSinglePage: Bool { // default is false
        
        get{
            
            return self._hidesForSinglePage
        }
        
        set{
            
            self._hidesForSinglePage = newValue
            
            self.isHiddenByNumberOfPages()
        }
    }
    
    private func isHiddenByNumberOfPages() {
        
        if self.hidesForSinglePage == true,
            self._numberOfPages <= 1 {
            
            self.isHidden = true
        }else{
            
            self.isHidden = false
        }
    }
    
    var pageIndicatorTintColor: UIColor = UIColor.FromRGB(0xB3B3B3)

    var currentPageIndicatorTintColor: UIColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)
    
    var subPageViews : [String : UIView] = [String : UIView]()

    @discardableResult private func getOrAddSubPageView(index : UInt) -> UIView {

        let indexKey : String = "\(index)"
        
        let pageViewOrNil : UIView? = self.subPageViews[indexKey]
        
        if let pageView = pageViewOrNil {
            
            return pageView
        }
        
        let newPageView = UIView.newAutoLayout()
        newPageView.backgroundColor = self.pageIndicatorTintColor
        
        self.subPageViews[indexKey] = newPageView
        
        return newPageView
    }
    
    func reSetups() {
        
        for subIndexView in self.subPageViews.values {
            
            subIndexView.removeFromSuperview()
            
            subIndexView.removeAllConstraints()
        }
        
        let currentPageKey : String = "\(self.currentPage)"
        
        var lastPageViewOrNil : UIView? = nil
        for index in 0 ..< self.numberOfPages {
            
            let indexView = self.getOrAddSubPageView(index: index)
            
            if currentPageKey == "\(index)" {
                
                indexView.backgroundColor = self.currentPageIndicatorTintColor
            }else {
                
                indexView.backgroundColor = self.pageIndicatorTintColor
            }

            let size = self.size(forNumberOfPages: index)
            
            indexView.layer.masksToBounds = true
            indexView.layer.cornerRadius = size.height/2
            
            indexView.autoSetDimensions(to: size)
            
            self.addSubview(indexView)
            
            indexView.autoAlignAxis(.horizontal, toSameAxisOf: self)
            
            if let lastPageView = lastPageViewOrNil {
                
                indexView.autoPinEdge(.leading, to: .trailing, of: lastPageView, withOffset: UIW(10))
            }else{
                
                indexView.autoPinEdge(.leading, to: .leading, of: self, withOffset: UIW(10))
            }
            
            lastPageViewOrNil = indexView
        }
        
        if let lastPageView = lastPageViewOrNil {
            
            lastPageView.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -UIW(10))
        }
    }
    
    /**
     *    @description 获取某个page的大小
     *
     */
    func size(forNumberOfPages pageCount: UInt) -> CGSize {
        
        guard let del = self.delegate else {
            
            return self.itemDefaultSize
        }
        
        guard let itemSize = del.pageControlItemSize?(forNumberOfPages: pageCount) else {
            
            return self.itemDefaultSize
        }
        
        return itemSize
    }
}

//class XYBannerPageControl: UIPageControl {
//
//    var delegate : XYPageControlDelegate?
//
//    var itemDefaultSize = CGSize(width: UIW(10), height: UIW(10))
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        self.initProperty()
//        self.layoutAddViews()
//        self.layoutAllViews()
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func initProperty() {
//
//    }
//
//    func layoutAddViews() {
//
//    }
//
//    func layoutAllViews() {
//
//    }
//
//    func setCurrentPage(page: Int) {
//
//        self.currentPage = page
//
//
//    }
//
//    func changePageItemSize() {
//
//        for pageIndex in 0 ..< self.subviews.count {
//
//            let pageView = self.subviews[pageIndex]
//
//            var pageBounds = pageView.bounds
//
//
//
//        }
//
//    }
//
//    override func size(forNumberOfPages pageCount: Int) -> CGSize {
//
//        guard let del = self.delegate else {
//
//            return self.itemDefaultSize
//        }
//
//        guard let itemSize = del.pageControlItemSize?(forNumberOfPages: pageCount) else {
//
//            return self.itemDefaultSize
//        }
//
//        return itemSize
//    }
//}
