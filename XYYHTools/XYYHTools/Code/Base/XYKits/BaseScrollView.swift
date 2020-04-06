//
//  BaseScrollView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/5/25.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        
        if view is UISlider {
            
            /*
             直接拖动UISlider，此时touch时间在150ms以内，
             UIScrollView会认为是拖动自己，从而拦截了event，导致UISlider接受不到滑动的event。
             但是只要按住UISlider一会再拖动，此时此时touch时间超过150ms，因此滑动的event会发送到UISlider上。
             */
            
            //如果响应view是UISlider,则scrollview禁止滑动
            self.isScrollEnabled = false
            
        }else if (self is UICollectionView) {
            
            // 与 PracticeWordViewController 冲突 
            
        }else {
            
            //如果不是,则恢复滑动
            self.isScrollEnabled = true
        }
        
        return view
    }
}

@IBDesignable class BaseScrollView : UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initProperty()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
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
    
    override func updateConstraints() {
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    /// 是否一直显示滚动指示条
    var xyNeedNotHiddenIndicator : Bool = false
    
    /// 是否需要一直显示滚动指示条 (实际用于UIImageView的控制)
    var xyIsHiddenIndicator : Bool = false
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        
        guard 0 < self.bounds.size.width,
            0 < self.bounds.size.height else {
                
            //当前控件大小为0，不处理
            return
        }
        
        defer {
            
            self.flashScrollIndicators()
        }
        
        guard self.xyNeedNotHiddenIndicator == true else {
                
                //控件不需要常显示滚动条
                self.xyIsHiddenIndicator = false
                return
        }
        
        guard (self.bounds.size.height < self.contentSize.height) ||
            (self.bounds.size.width < self.contentSize.width) else {
            
            //内容不够多，不需要常显示滚动条
            self.xyIsHiddenIndicator = false
            return
        }
        
        //让滚动条一直显示
        self.xyIsHiddenIndicator = true
    }
    
}

extension BaseScrollView: XYViewNewByNibProtocol {

    func initProperty() {
        
        if #available(iOS 11.0, *) {
            // 在新版iOS11中automaticallyAdjustsScrollViewInsets方法被废弃，我们需要使用UIScrollView的 contentInsetAdjustmentBehavior 属性来替代它.
            
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func layoutAddViews() {
        
    }
    
    func layoutAllViews() {
        
    }
    
    func xyDidAddNibContentView() {
        
    }
}

/*
 
 iOS11 & iPhone X 上UIScrollView(UITableView)内容偏移问题

 原因:
 iOS11中UIViewController的automaticallyAdjustsScrollViewInsets属性已经不再使用，我们需要使用UIScrollView的contentInsetAdjustmentBehavior属性来替代它。
 当UIScrollView的frame超出安全区域范围时，系统会自动调整UIScrollView的safeAreaInsets值，于是会影响UIScrollView的adjustContentInse值，从而导致UIScrollView的内容发生偏移。iOS11控制UIScrollView内容偏移量的属性是adjustContentInset，而adjustContentInset值是系统根据safeAreaInsets、contentInset计算得来的，计算方式由contentInsetAdjustmentBehavior决定。
 
 补充：有导航栏时safeAreaInsets值自动调整为(88,0,34,0)。没有导航栏时safeAreaInsets值为(44,0,34,0)。
 
 安全区域
 安全区域是iOS 11新提出的。
 
 安全区域帮助我们将view放置在整个屏幕的可视的部分。即使把navigationBar设置为透明的，系统也认为安全区域是从navigationBar的bottom开始，保证不被系统的状态栏、或导航栏覆盖。controller可以使用additionalSafeAreaInsets去扩展安全区域使它包括自定义的content在界面上。每个view都可以改变安全区域嵌入的大小，controller也可以。
 
 safeAreaInsets属性反映了一个view距离该view的安全区域的边距。对于一个UIViewController的根视图而言，safeAreaInsets值包括了被statusbar和其他可视的bars覆盖的区域和其他通过additionalSafeAreaInsets自定义的insets值。view层次中的其它view，safeAreaInsets值反映了该view被覆盖的部分。如果一个view全部在它父视图的安全区域内，则safeAreaInsets值为(0,0,0,0)。
 
 adjustContentInset 属性的计算方式
 首先看UIScrollView在iOS11新增的两个属性：adjustContentInset和 contentInsetAdjustmentBehavior。
 
 UIScrollViewContentInsetAdjustmentAutomatic：如果scrollView在一个automaticallyAdjustsScrollViewContentInset = YES的UIViewController上，并且这个UIViewController包含在一个UINavigationController中，这种情况下会设置在top & bottom上 adjustedContentInset = safeAreaInset + contentInset不管是否滚动。其他情况下与UIScrollViewContentInsetAdjustmentScrollableAxes相同。
 
 UIScrollViewContentInsetAdjustmentScrollableAxes： 在可滚动方向上adjustedContentInset = safeAreaInset + contentInset，在不可滚动方向上adjustedContentInset = contentInset；依赖于scrollEnabled和alwaysBounceHorizontal / Vertical = YES，scrollEnabled默认为Yes，所以大多数情况下，计算方式还是adjustedContentInset = safeAreaInset + contentInset
 
 UIScrollViewContentInsetAdjustmentNever：adjustedContentInset = contentInset 。当contentInsetAdjustmentBehavior设置为UIScrollViewContentInsetAdjustmentNever的时候，adjustContentInset值不受safeAreaInset值的影响。
 
 UIScrollViewContentInsetAdjustmentAlways： adjustedContentInset = safeAreaInset + contentInset
 
 解决方法
 重新设置tableView的contentInset值，来抵消掉safeAreaInset值，因为adjustedContentInset = contentInset + safeAreaInset；
 
 设置tableView的contentInsetAdjustmentBehavior属性为UIScrollViewContentInsetAdjustmentNever，这样adjustedContentInset = contentInset；
 
 // 新API：`@available(iOS 11.0, *)` 可用来判断系统版本
 if ( @available(iOS 11.0, *) ) {
 self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
 }
 设置iOS11UIViewController新增属性addtionalSafeAreaInset；
 iOS 11之前，大家是通过将UIViewController的automaticallyAdjustsScrollViewInsets属性设置为NO，来禁止系统调整tableView的contentInset。如果还是想从controller级别解决问题，可以通过设置controller的additionalSafeAreaInsets属性，因为当tableView的frame没有超出安全区域范围时，系统就不会调整tableView的safeAreaInset值，从而也就不会发生内容偏移情况。
 组头组尾高度
 当tableView的类型为UITableViewStyleGrouped时，系统默认tableView组头和组尾是有间距的，如果不需要这个间距的话，iOS11之前可以通过实现代理方法heightForHeaderInSection / heightForFooterInSection（返回一个较小值：0.01）来解决的。
 
 iOS11之后不仅要实现代理方法heightForHeaderInSection / heightForFooterInSection，还要实现代理方法viewForHeaderInSection / viewForFooterInSection才能去掉间距。或者添加以下代码关闭高度估算，问题也能解决。
 
 self.tableView.estimatedRowHeight = 0;
 self.tableView.estimatedSectionHeaderHeight = 0;
 self.tableView.estimatedSectionFooterHeight = 0;

 
 */
