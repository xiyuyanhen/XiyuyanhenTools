//
//  BaseCollectionView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/19.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

extension UICollectionView {
    
    func xyCellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        
        if let cell = self.cellForItem(at: indexPath) {
            
            return cell
        }
        
        // 若没有找到Cell，先手动创建Cell数据，再重新找
        
        self.reloadItems(at: [indexPath])
        
        if let cell = self.cellForItem(at: indexPath) {
            
            return cell
        }
        
        return nil
    }
}

@IBDesignable class BaseCollectionView : UICollectionView, XYViewNewByNibProtocol {
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout) {
        
        self.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.initProperty()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
        
        self.xyDidAddNibContentView()
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
    
    func initProperty() {
        
        self.setBackgroundColor(customColor: .clear)
        
        if #available(iOS 11.0, *) {
            // 在新版iOS11中automaticallyAdjustsScrollViewInsets方法被废弃，我们需要使用UIScrollView的 contentInsetAdjustmentBehavior 属性来替代它.
            
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    override func updateConstraints() {
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
        
        
    }
    
    func layoutAddViews() {
        
        
    }
    
    func layoutAllViews() {
        
        
    }
    
    func xyDidAddNibContentView() {
        
        
    }
    
    
    
}
