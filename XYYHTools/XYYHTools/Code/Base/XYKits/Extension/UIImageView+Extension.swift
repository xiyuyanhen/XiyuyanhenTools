//
//  UIImageView+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/11.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

typealias BaseImageView = UIImageView

public extension UIImageView {
    
    override open var alpha: CGFloat {
        
        set {
            
            // 处理ScrollView是否需要一直显示滚动指示条
            if let scrollView = self.superview as? BaseScrollView,
                scrollView.xyIsHiddenIndicator == true {
                
                super.alpha = 1.0
                return
            }
            
            super.alpha = newValue
        }
        
        get {
            
            return super.alpha
        }
    }
}

extension UIImageView {
    
    func setNetworkDefaultImg() {
        
        self.setImageByName(UIImage.NetworkDefaultImageName)
    }
}

extension UIImageView {
    
    static private let XYIsAutoChangeHeightByImageNameKey = UnsafeRawPointer.init(bitPattern: "UIImageView_IsAutoChangeHeightByImage_Key".hashValue)
    var isAutoChangeHeightByImage:Bool{
        set{
            
            objc_setAssociatedObject(self, UIImageView.XYIsAutoChangeHeightByImageNameKey!, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get{
            guard let bool = objc_getAssociatedObject(self, UIImageView.XYIsAutoChangeHeightByImageNameKey!) as? Bool else {
                
                return false
            }
            
            return bool
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard 0.0 < self.bounds.size.width else { return }
        
        self.updateSizeByImage()
    }
    
    
    
    /**
     *    @description 根据显示的图片更新视图大小
     *
     *    @return   最新的视图大小
     */
    @discardableResult func updateSizeByImage() -> CGSize {
        
        let viewSize = self.bounds.size
        
        guard self.isAutoChangeHeightByImage,
            let image = self.image else { return viewSize }
        
        let viewWidth : CGFloat
        if let widthLC = self.xyLayoutConstraints.width {
            
            viewWidth = widthLC.constant
            
        }else {
            
            viewWidth = viewSize.width
        }
        
        let newViewHeight: CGFloat = CalculateHeight(size: image.size, referenceWidth: viewWidth)
        
        if let heightLC = self.xyLayoutConstraints.height {
            
            heightLC.constant = newViewHeight
            
        }else {
            
            self.autoSetDimension(.height, toSize: newViewHeight)
        }
        
        return CGSize(width: viewWidth, height: newViewHeight)
    }
    
    /**
     *    @description 清除显示内容
     *
     */
    func clearImage() {
        
        self.image = nil
    }
    
    func setImage(_ imgOrNil: UIImage?) {
        
        guard let img = imgOrNil else { return }
        
        self.image = img
    }
    
    /**
     *    @description 通过图片资源名设置Image
     *
     *    @param    imageName    图片资源名
     *
     *    @return   是否获取到Image图片资源
     */
    @discardableResult func setImageByName(_ imgNameOrNil:String?) -> UIImage? {
        
        guard let imgName = imgNameOrNil,
            let image = UIImage(named: imgName) else { return nil }
        
        self.image = image
        
        return image
    }
    
    @discardableResult func setImageWithPath(_ imgPath: String) -> UIImage? {
        
        let url = URL(fileURLWithPath: imgPath)
        
        guard let imgData = try? Data(contentsOf: url, options: Data.ReadingOptions.dataReadingMapped),
            let img = UIImage(data: imgData) else { return nil }
        
        self.image = img
        
        return img
    }
    
    //    func setImageFromURL(URL: URL?, placeholder : UIImage? = nil){
    //
    //        //        if let imgUrl = URL {
    //        //
    //        //            self.hnk_setImageFromURL(imgUrl, placeholder: placeholder, format: nil, failure: nil, success: nil)
    //        //        }else{
    //        //
    //        //            self.image = placeholder
    //        //        }
    //
    //        self.xyFetcher(URL: URL, placeholder: placeholder)
    //    }
    
    //    func setImageFromURL(URLString: String?, placeholder : UIImage? = nil){
    //
    //        //        if let headUrlString = URLString {
    //        //
    //        //            self.setImageFromURL(URL: URL(string: headUrlString), placeholder: placeholder)
    //        //        }else{
    //        //
    //        //            self.image = placeholder
    //        //        }
    //
    //        self.xyFetcher(URLString: URLString, placeholder: placeholder)
    //    }
    
    typealias SetImgByUrlFetchedBlock = (_ imgView : UIImageView, _ fetchedImg: UIImage) -> Void
    
    func setImageFromURL(URLString: String?, placeholder : UIImage? = nil, fetchedBlock fbOrNil: SetImgByUrlFetchedBlock? = nil) {
        
        var urlOrNil : URL? = nil
        
        if let urlString = URLString,
            let url = URL(string: urlString) {
            
            urlOrNil = url
        }
        
        self.setImageFromURL(URL: urlOrNil, placeholder: placeholder, fetchedBlock : fbOrNil)
    }
    
    func setImageFromURL(URL urlOrNil: URL?, placeholder : UIImage? = nil, fetchedBlock fbOrNil: SetImgByUrlFetchedBlock? = nil) {
        
        self.image = placeholder
        
        guard let url = urlOrNil else { return }
        
        let fetcher = NetworkFetcher<UIImage>(URL: url)
        
        let cache = Shared.imageCache
        
        cache.fetch(fetcher: fetcher).onSuccess { [weak self] (image) in
            
            guard let weakSelf = self else { return }
            
            weakSelf.image = image
            
            guard let fb = fbOrNil else { return }
            
            fb( weakSelf , image)
        }
    }
    
    
}

extension UIImageView {
    
    func canShowByPhotoBrower() {
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.showByPhotoBrower(tapGR:)))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGR)
    }
    
    @objc @discardableResult func showByPhotoBrower(tapGR: UITapGestureRecognizer?) -> Bool {
        
        guard let img = self.image else { return false }
        
        let photo = SKPhoto.photoWithImage(img)

        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: [photo])
        browser.initializePageIndex(0)
    
        AlertShowedVC.present(browser, animated: true, completion: nil)
        
        return true
    }
}


