//
//  LTPageView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public typealias PageViewDidSelectIndexBlock = (LTPageView, Int) -> Void
public typealias AddChildViewControllerBlock = (Int, UIViewController) -> Void

@objc public protocol LTPageViewDelegate: class {
    @objc optional func glt_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func glt_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}

@objc public protocol XYLTPageViewExtraDelegate: class {
    @objc optional func xyLTPage_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func xyLTPage_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func xyLTPage_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func xyLTPage_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func xyLTPage_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func xyLTPage_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}

public class LTPageView: BaseView {
    
    private weak var currentViewController: UIViewController?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var layout: LTLayout = LTLayout()
    private var glt_currentIndex: Int = 0
    
    @objc public var didSelectIndexBlock: PageViewDidSelectIndexBlock?
    @objc public var addChildVcBlock: AddChildViewControllerBlock?
    
    /* 点击切换滚动过程动画  */
    @objc public var isClickScrollAnimation = false {
        didSet {
            pageTitleViewOrNil?.isClickScrollAnimation = isClickScrollAnimation
        }
    }
    
    /* pageView的scrollView左右滑动监听 */
    @objc public weak var delegate: LTPageViewDelegate?
    
    @objc public weak var xyPageViewScrollDelegate: XYLTPageViewExtraDelegate?
    
    var isCustomTitleView: Bool = false
    
    var pageTitleViewOrNil: LTPageTitleView?
    
    var isAutoLayout: Bool = false
    
    @objc public lazy var scrollView: UIScrollView = {
        
        let scrollView: UIScrollView
        if self.isAutoLayout {
            
            scrollView = UIScrollView.newAutoLayout()
            
        }else {
            
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        }
        
        scrollView.contentSize = CGSize(width: self.bounds.width * CGFloat(self.titles.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = layout.isShowBounces
        scrollView.isScrollEnabled = layout.isScrollEnabled
        scrollView.showsHorizontalScrollIndicator = layout.showsHorizontalScrollIndicator
        return scrollView
    }()
    
    @objc public init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: LTLayout, titleView: LTPageTitleView? = nil) {
        self.currentViewController = currentViewController
        self.viewControllers = viewControllers
        self.titles = titles
        self.layout = layout
        guard viewControllers.count == titles.count else {
            fatalError("控制器数量和标题数量不一致")
        }
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        if titleView != nil {
            
            self.isCustomTitleView = true
            
            self.pageTitleViewOrNil = titleView!
        }else {
            self.pageTitleViewOrNil = setupTitleView()
        }
        self.pageTitleViewOrNil?.isCustomTitleView = self.isCustomTitleView
        setupSubViews()
    }
    
    @objc public init(currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: LTLayout, titleView titleViewOrNil: LTPageTitleView? = nil) {
        
        self.currentViewController = currentViewController
        self.viewControllers = viewControllers
        self.titles = titles
        self.layout = layout
        
        self.isAutoLayout = true
        
        guard viewControllers.count == titles.count else {
            fatalError("控制器数量和标题数量不一致")
        }
        
        super.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        if let titleView = titleViewOrNil {
            
            
            self.isCustomTitleView = true
            
            self.pageTitleViewOrNil = titleView
            
        }else {
            
            self.pageTitleViewOrNil = setupTitleView()
        }
        
        let _ = self.rxSizeChangeOrNil
        
        let _ = self.rxRemoveFromSuperviewOrNil
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        guard self.isAutoLayout else { return }
        
        self.addSubview(self.scrollView)
        
        guard layout.isSinglePageView == false,
            let pageTitleView = self.pageTitleViewOrNil else { return }
        
        self.addSubview(pageTitleView)
    
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        guard self.isAutoLayout else { return }
        
        if let pageTitleView = self.pageTitleViewOrNil,
            pageTitleView.superview != nil {
            
            pageTitleView.autoPinView(otherView: self, edges: .top, .leading, .trailing)
            
            self.scrollView.autoPinEdge(.top, to: .bottom, of: pageTitleView)
            
        }else {
            
            self.scrollView.autoPinEdge(.top, to: .top, of: self)
        }
        
        self.scrollView.autoPinView(otherView: self, edges: .leading, .bottom, .trailing)
        
        self.glt_createViewController(0)
        
        if let pageTitleView = self.pageTitleViewOrNil {
            
            self.setupGetPageViewScrollView(self, pageTitleView)
        }
        
    }
    
    var scrollViewSizeCache : CGSize = CGSize.zero
    var needUpdateScrollViewSize : Bool = false
    
    var currentScrollViewSize: CGSize {
        
        let currentSize = self.scrollView.frame.size
        
        if self.scrollViewSizeCache != currentSize {
            
            self.scrollViewSizeCache = currentSize
            
            self.needUpdateScrollViewSize = true
        }
        
        return currentSize
    }
    
    /// 若View.bounds大小发生变化，相应更新
    fileprivate lazy var rxSizeChangeOrNil: Disposable? = {
        
        let disposeble = self.rx.observe(CGRect.self, "bounds")
            .takeUntil(self.rx.sentMessage(#selector(self.removeFromSuperview)))
            .subscribe(onNext: { [weak self] (frameOrNil) in
                
                guard let newSize = frameOrNil?.size,
                    let weakSelf = self,
                    weakSelf.cacheSize != newSize else { return }
                
                weakSelf.cacheSize = newSize
                
                weakSelf.scrollView.contentSize = CGSize(width: newSize.width * CGFloat(weakSelf.titles.count), height: 0)
                
//                guard weakSelf.isAutoLayout,
//                    let pageTitleView = weakSelf.pageTitleViewOrNil else { return }
//
//                /// 更新TitleView
//                pageTitleView.isCustomTitleView = weakSelf.isCustomTitleView
                
            })
        
        disposeble.disposed(by: self.disposeBag)
        
        return disposeble
    }()
    
    lazy var rxRemoveFromSuperviewOrNil: Disposable? = {
        
        let disposeble = self.rx.sentMessage(#selector(self.removeFromSuperview)).subscribe(onNext: { [weak self] (objects) in
            
            XYLog.LogNoteBlock { () -> String? in
            
            return "sentMessage.removeFromSuperview"
        }
            
            guard let weakSelf = self else { return }
            
            weakSelf.clearMemory()
            
        }, onDisposed: {
            
            XYLog.LogNoteBlock { () -> String? in
            
            return "sentMessage.removeFromSuperview.Disposed"
        }
        })
        
        disposeble.disposed(by: self.disposeBag)
        
        return disposeble
    }()
    
    /// 记录最近的一次大小
    var cacheSize : CGSize = CGSize.zero
    
    /* 滚动到某个位置 */
    @objc public func scrollToIndex(index: Int)  {
        pageTitleViewOrNil?.scrollToIndex(index: index)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LTPageView {
    
    public var showedTitles : [String] {
        
        return self.titles
    }
    
    public var showedViewControllers : [UIViewController] {
        
        return self.viewControllers
    }
    
    public func removeByDeinit() {
        
        if self.superview != nil {

            self.removeFromSuperview()
        }
        
        self.clearMemory()
    }
    
    private func clearMemory() {
    
        if let pageTitleView = self.pageTitleViewOrNil {
            
            pageTitleView.delegate = nil
            pageTitleView.mainScrollView = nil
            pageTitleView.glt_createViewControllerHandle = nil
            pageTitleView.glt_didSelectTitleViewHandle = nil
            
            self.pageTitleViewOrNil = nil
        }
        
        self.scrollView.removeSubviews()
        
        self.delegate = nil
        self.xyPageViewScrollDelegate = nil
        self.didSelectIndexBlock = nil
        self.addChildVcBlock = nil
        
        self.titles.removeAll()
        
        if let currentViewController = self.currentViewController {
            
            for childrenVC in currentViewController.children {
                
                childrenVC.removeFromParent()
                childrenVC.view.removeFromSuperview()
            }
            
            self.currentViewController = nil
        }
        
        self.scrollView.removeSubviews()
        self.removeSubviews()
        
        self.viewControllers.removeAll()
    }

}

extension LTPageView {
    
    private func setupSubViews()  {
        
        self.addSubview(scrollView)
        
        if layout.isSinglePageView == false,
            let pageTitleView = self.pageTitleViewOrNil {
            
            self.addSubview(pageTitleView)
            
            self.glt_createViewController(0)
            
            self.setupGetPageViewScrollView(self, pageTitleView)
        }
    }
    
}

extension LTPageView {
    
    private func setupTitleView() -> LTPageTitleView {
        
        let pageTitleView: LTPageTitleView
        
        if self.isAutoLayout {
            
            pageTitleView = LTPageTitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.layout.sliderHeight), titles: titles, layout: layout)
            pageTitleView.translatesAutoresizingMaskIntoConstraints = false
            pageTitleView.autoSetDimensions(to: CGSize(width: self.bounds.width, height: self.layout.sliderHeight))
            
            pageTitleView.layoutIfNeeded()
            
        }else {
            
            pageTitleView = LTPageTitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.layout.sliderHeight), titles: titles, layout: layout)
        }
        
        pageTitleView.backgroundColor = self.layout.titleViewBgColor
        
        return pageTitleView
    }
}

extension LTPageView {
    
    func setupGetPageViewScrollView(_ pageView:LTPageView, _ titleView: LTPageTitleView) {
        
        pageView.delegate = titleView
        
        titleView.mainScrollView = pageView.scrollView
        
        titleView.scrollIndexHandle = pageView.currentIndex
        
        titleView.glt_createViewControllerHandle = {[weak pageView] index in
            
            pageView?.glt_createViewController(index)
        }
        
        titleView.glt_didSelectTitleViewHandle = {[weak pageView] index in
            
            pageView?.didSelectIndexBlock?((pageView)!, index)
        }
    }
}

extension LTPageView {
    
    public func glt_createViewController(_ index: Int)  {
        
        let VC = viewControllers[index]
        
        guard let currentViewController = currentViewController else { return }
        
        let scrollViewSize = self.currentScrollViewSize
        
        var viewControllerY: CGFloat = 0.0
        (self.layout.isSinglePageView || self.isAutoLayout) ? viewControllerY = 0.0 : (viewControllerY = layout.sliderHeight)
        
        if currentViewController.children.contains(VC) {
            
            if self.needUpdateScrollViewSize {
                // 若需要更新视图大小
                
                for childrenVC in currentViewController.children {
                    
                    childrenVC.removeFromParent()
                    childrenVC.view.removeFromSuperview()
                }
                
                self.needUpdateScrollViewSize = false
                
            }else {
                
                return
            }
        }
        
        VC.view.frame = CGRect(x: scrollViewSize.width * CGFloat(index), y: viewControllerY, width: scrollViewSize.width, height: scrollViewSize.height)
        
        self.scrollView.addSubview(VC.view)
        
        currentViewController.addChild(VC)
        
        VC.automaticallyAdjustsScrollViewInsets = false
        
        addChildVcBlock?(index, VC)
        
        if let glt_scrollView = VC.glt_scrollView {
            
            if #available(iOS 11.0, *) {
                
                glt_scrollView.contentInsetAdjustmentBehavior = .never
            }
            
            glt_scrollView.frame.size.height = glt_scrollView.frame.size.height - viewControllerY
        }
    }
    
    public func currentIndex() -> Int {
        if scrollView.bounds.width == 0 || scrollView.bounds.height == 0 {
            return 0
        }
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width)
        return max(0, index)
    }
    
}

extension LTPageView {
    
    private func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给标题颜色赋值")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

extension UIColor {
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}

extension LTPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidScroll?(scrollView)
        self.xyPageViewScrollDelegate?.xyLTPage_scrollViewDidScroll?(scrollView)
        if isCustomTitleView {
            let index = currentIndex()
            if glt_currentIndex != index {
                glt_createViewController(index)
                didSelectIndexBlock?(self, index)
                glt_currentIndex = index
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDragging?(scrollView)
        self.xyPageViewScrollDelegate?.xyLTPage_scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDecelerating?(scrollView)
        self.xyPageViewScrollDelegate?.xyLTPage_scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndDecelerating?(scrollView)
        self.xyPageViewScrollDelegate?.xyLTPage_scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.glt_scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        self.xyPageViewScrollDelegate?.xyLTPage_scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndScrollingAnimation?(scrollView)
        self.xyPageViewScrollDelegate?.xyLTPage_scrollViewDidEndScrollingAnimation?(scrollView)
        
    }
}


