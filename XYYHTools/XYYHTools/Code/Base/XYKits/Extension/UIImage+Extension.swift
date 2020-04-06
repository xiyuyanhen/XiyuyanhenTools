//
//  UIImage+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/12/21.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

extension UIImage {
    
    static let NetworkDefaultImageName : String = "Public_Image_Default"
    
    static let NetworkDefaultImage : UIImage? = UIImage(named: UIImage.NetworkDefaultImageName)
    
}

extension UIImage {
    
    func xyCaculateHeight(_ width: CGFloat) -> CGFloat {
        
        return CaculateHeightBySize(width: width, referenceSize: self.size)
    }
    
}

extension UIImage {
    
    /**
     *    @description 从图片缓存库中清除指定的图片
     *
     *    @param    urlOrNil    图片路径
     *
     */
    static func ClearImageCacheBy(URL urlOrNil: String?) {
        
        guard let urlStr = urlOrNil,
            let url = URL(string: urlStr) else { return }
        
        self.ClearImageCacheBy(URL: url)
    }
    
    /**
     *    @description 从图片缓存库中清除指定的图片
     *
     *    @param    urlOrNil    图片路径
     *
     */
    static func ClearImageCacheBy(URL urlOrNil: URL?) {
        
        guard let url = urlOrNil else { return }
        
        let fetcher = NetworkFetcher<UIImage>(URL: url)
        
        Shared.imageCache.remove(key: fetcher.key)
    }
    
    /**
     *    @description 将指定的图片添加到图片缓存库
     *
     *    @param    key    图片索引
     *
     */
    @discardableResult static func SetImageCacheBy(key keyOrNil: String?, image imageOrNil: UIImage?) -> Bool {
        
        guard let key = keyOrNil,
            let image = imageOrNil else { return false }
        
        Shared.imageCache.set(value: image, key: key)
        
        return true
    }
}

extension UIImage{
    
    convenience init?(xyImgName imgNameOrNil: String?) {
        
        guard let imgName = imgNameOrNil else { return nil }
        
        self.init(named: imgName)
    }
    
    convenience init?(imgPath imgPathOrNil: String?) {
        
        guard let imgPath = imgPathOrNil else { return nil }
        
        let url = URL(fileURLWithPath: imgPath)
        
        guard let imgData = try? Data(contentsOf: url, options: Data.ReadingOptions.dataReadingMapped) else { return nil }
        
        self.init(data: imgData)
    }
    
    /**
    *    @description 生成矩形图片
    *
    *    @param    color    背景颜色
    *
    *    @param    size    矩形大小
    *
    *    @return   矩形图片
    */
    class func ImageWithColor(_ color:UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        var imageOrNil: UIImage? = nil
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setFillColor(color.cgColor)
            context.fill(rect)
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                
                imageOrNil = image
            }
        }
        
        UIGraphicsEndImageContext()
        
        return imageOrNil
    }
    
    /**
     *    @description 生成圆形图片
     *
     *    @param    diameter    直径
     *
     *    @param    color    背景颜色
     *
     *    @return   圆形图片
     */
    class func ImageCircleWith(_ diameter: CGFloat, color:UIColor) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        
        /// 半径
        let radius: CGFloat = diameter/2.0
        
        UIGraphicsBeginImageContext(rect.size)
        
        var imageOrNil: UIImage? = nil
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi*2.0, clockwise: true)
            
            context.setFillColor(color.cgColor)
            context.fillPath()
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                
                imageOrNil = image
            }
        }
        
        UIGraphicsEndImageContext()
        
        return imageOrNil
    }
    
    func imageResize(size : CGSize) -> UIImage {
        
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions( size, false, scale)
        
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImg!
    }
    
    func grayImage() -> UIImage {
        
        let imageRef:CGImage = self.cgImage!
        let width:Int = imageRef.width
        let height:Int = imageRef.height
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context:CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: width, height: height)
        context.draw(imageRef, in: rect)
        let outPutImage:CGImage = context.makeImage()!
        let newImage:UIImage = UIImage.init(cgImage: outPutImage, scale: self.scale, orientation: self.imageOrientation)
        return newImage
    }
}

// MARK: - Image From String
extension UIImage {
    
    static func CreateBy(view: UIView, size: CGSize) -> UIImage? {
        
        //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        guard let imageContext = UIGraphicsGetCurrentContext() else { return nil }
        
        view.layer.render(in: imageContext)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func CreateBy(attText attTextOrNil: NSAttributedString?, size: CGSize) -> UIImage? {
        
        guard let attText = attTextOrNil else { return nil }
        
        let label = BaseLabel.newAutoLayout()
        label.setBackgroundColor(customColor: .xe5e5e5)
            .setAttributedText(attText)
        
        // 添加一个像素以解决生成的图片底部有一条黑线
        var newSize = size
        newSize.height += 1.0
        
        label.frame = CGRect(origin: CGPoint.zero, size: newSize)
        
        label.layoutIfNeeded()
        
        return self.CreateBy(view: label, size: size)
    }
    
    static func CreateBy(attText attTextOrNil: NSAttributedString?, preferceWidth: CGFloat) -> UIImage? {
        
        guard let attText = attTextOrNil else { return nil }
        
        let label = BaseLabel.newAutoLayout()
        label.setBackgroundColor(customColor: .xe5e5e5)
            .setAttributedText(attText)
        
        let size = label.sizeThatFits(CGSize(width: preferceWidth, height: 0))
        
        label.frame = CGRect(origin: CGPoint.zero, size: size)
        
        label.layoutIfNeeded()
        
        return self.CreateBy(view: label, size: size)
    }
    
    /// 加载中...
    static var LoadingAttText : NSAttributedString {
        
        var loadingAttTextModel = NSMutableAttributedString.AttributesModel(text: "加载中...", fontSize: 18, textColor: XYColor.CustomColor.x666666)
        loadingAttTextModel.addAttFont(font: XYFont.BoldFont(size: 18))
        loadingAttTextModel.addAttParagraphStyle(alignment: .center, lineSpacing: 8, firstLineIndent: nil)
        
        return loadingAttTextModel.attributedString()
    }
    
}
