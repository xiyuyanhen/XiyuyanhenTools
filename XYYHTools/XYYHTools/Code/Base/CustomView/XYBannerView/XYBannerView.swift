//
//  XYBannerView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/21.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

@objc protocol XYBannerViewDelegate {
    
    @objc func selectModel(model: XYBannerModel) -> Void
}

class XYBannerView : BaseView, UICollectionViewDataSource, UICollectionViewDelegate, XYPageControlDelegate {
    
    enum Mode {
        case Default
        case Custom
    }
    
    private var _mode : Mode = Mode.Default
    var mode : Mode {
        
        get{
            
            return self._mode
        }
        
        set{
            
            self._mode = newValue
            
            self.reLayoutAllViews()
        }
    }
    
    var delegate : XYBannerViewDelegate?
    
    override func initProperty() {
        super.initProperty()
        
        self.backgroundColor = UIColor.clear
        
        self.mode = .Default
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        
    }
    
    func reLayoutAllViews() {
        
        self.collectionView.removeFromSuperview()
        self.pageControl.removeFromSuperview()
        
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
        
        switch self._mode {
        case .Default:
            
            self.collectionView.autoSetDimension(.width, toSize: XYBannerViewCell.ItemSize().width)
            self.collectionView.autoSetDimension(.height, toSize: XYBannerViewCell.ItemSize().height)
            self.collectionView.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .top, .leading, .trailing)
            
            self.pageControl.autoSetDimension(.height, toSize: UIW(20))
            self.pageControl.autoAlignAxis(.vertical, toSameAxisOf: self.collectionView)
            self.pageControl.autoPinEdge(.top, to: .bottom, of: self.collectionView, withOffset: UIW(5))
            self.pageControl.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -UIW(5))
            
            break
        case .Custom:
            
            self.collectionView.autoSetDimension(.width, toSize: XYBannerViewCell.ItemSize().width)
            self.collectionView.autoSetDimension(.height, toSize: XYBannerViewCell.ItemSize().height)
            self.collectionView.autoPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .top, .leading, .bottom, .trailing)
            
            self.pageControl.autoSetDimension(.height, toSize: UIW(20))
            self.pageControl.autoAlignAxis(.vertical, toSameAxisOf: self.collectionView)
//            self.pageControl.autoPinEdge(.top, to: .bottom, of: self.collectionView, withOffset: UIW(5))
            self.pageControl.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -UIW(5))
            
            break
        }
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
    
        
    }
    

    private lazy var collectionLayout : UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        
        //布局方向 设置collectionView滚动方向
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        //头视图尺寸大小
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        
        //尾视图尺寸大小
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        
        //行与行之间的间距最小距离
        layout.minimumLineSpacing = 0
        
        //列与列之间的间距最小距离
        layout.minimumInteritemSpacing = 0
        
        //分区的偏移量
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        //分区的头视图是否始终固定在屏幕上边
        layout.sectionHeadersPinToVisibleBounds = false
        
        //分区的尾视图是否始终固定在屏幕下边
        layout.sectionFootersPinToVisibleBounds = false
        
        //每个item的大小
        layout.itemSize = XYBannerViewCell.ItemSize()
        
        //每个Item的估计大小，一般不需要设置
        //        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        
        return layout
    }()
    
    lazy var collectionView : BaseCollectionView = {
        
        let collectionView = BaseCollectionView(collectionViewLayout: self.collectionLayout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(XYBannerViewCell.self, forCellWithReuseIdentifier: XYBannerViewCell.ReuseIdentifier())
        
        return collectionView
    }()
    
    var bannerDataArr : [Any] = [Any]()
    
    lazy var pageControl : XYPageControl = {
        
        let pageControl = XYPageControl.newAutoLayout()
        
        pageControl.hidesForSinglePage = true
        
        pageControl.pageIndicatorTintColor = UIColor.FromRGB(0xB3B3B3)
        pageControl.currentPageIndicatorTintColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)
        
        pageControl.delegate = self
        
        return pageControl
    }()
    
    var bannerModelArr : XYBannerModel.ModelArray = XYBannerModel.ModelArray()
    
    @discardableResult func reloadData() -> Bool {
        
        self.collectionView.reloadData()
        
        let count = self.bannerModelArr.count
        
        guard 0 < count else { return false }
        
        let newCount = UInt(count)
        
        self.pageControl.numberOfPages = newCount
        
        self.currentPage = 0
        
//        XYDispatchQueueType.Main.after(time: 4.0) {
//
//            self.collectionView.reloadData()
//        }
        
        return true
    }
    
    func pageControlItemSize(forNumberOfPages pageCount: UInt) -> CGSize {

        guard pageCount == self.pageControl.currentPage  else {

            return self.pageControl.itemDefaultSize
        }

        return CGSize(width: UIW(12), height: UIW(6))
    }
    
    private var _currentPage : UInt = 0
    var currentPage : UInt {
        
        get{
            
            return self._currentPage
        }
        
        set{
            
            self._currentPage = newValue
            
            self.pageControl.currentPage = newValue
            
            //解决图片模糊临时方案
            self.collectionView.reloadData()
        }
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        

        
        let itemWidth = XYBannerViewCell.ItemSize().width
        
        let index : UInt = UInt(offset.x/itemWidth)
        
        self.currentPage = index
    }
    
    let animationTimeInterval:TimeInterval = 5.0
    lazy var animationTimer: Timer = {
        
        let timer = Timer.scheduledTimer(timeInterval: self.animationTimeInterval, target: self, selector: #selector(self.animationTimerHandle(timer:)), userInfo: nil, repeats: true)
        
        timer.fireDate = Date.distantFuture
//        timer.invalidate()
        
        return timer
    }()
    
    func startAnimation() {
        
        self.isFirst = true
        self.animationTimer.fireDate = Date.distantPast
    }
    
    func suspendAnimation() {
        
        self.animationTimer.fireDate = Date.distantFuture
    }
    
    var isFirst: Bool = true
    @objc func animationTimerHandle(timer:Timer) {
        
        guard self.isFirst == false else {
            
            self.isFirst = false
            return
        }
        
        guard 1 < self.bannerModelArr.count else { return }
        
        var nextPage = self.currentPage + 1
        
        if self.bannerModelArr.count <= nextPage {
            
            nextPage = 0
        }
        
        self.scrollToPage(indexPage: nextPage)
    }
    
    func scrollToPage(indexPage: UInt) {
        
        let toX : CGFloat = CGFloat(indexPage) * XYBannerViewCell.ItemSize().width
        
        let currentOffset = self.collectionView.contentOffset
        
        let toOffset = CGPoint(x: toX, y: currentOffset.y)
        
        self.collectionView.setContentOffset(toOffset, animated: true)
        
        XYDispatchQueueType.Main.after(time: 1.5) {

            self.currentPage = indexPage
        }

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        
        let itemWidth = XYBannerViewCell.ItemSize().width
        
        let index : UInt = UInt(offset.x/itemWidth)
        
        self.currentPage = index
        
        
    }
    
    // MARK: - collectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.bannerModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : XYBannerViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: XYBannerViewCell.ReuseIdentifier(), for: indexPath) as! XYBannerViewCell
        
        let model = self.bannerModelArr[indexPath.row]
        
        cell.setContent(model: model, mode: self.mode)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let del = self.delegate else { return }
        
        let model = self.bannerModelArr[indexPath.row]
        
        del.selectModel(model: model)
    }
}
