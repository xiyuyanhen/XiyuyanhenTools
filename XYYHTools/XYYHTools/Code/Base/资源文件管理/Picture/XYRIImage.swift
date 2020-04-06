//
//  XYResourceItemImage.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/8/5.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/**
 *    @description 计算高度
 *
 *    @param    size    尺寸
 *
 *    @param    referenceWidth    参考宽度
 *
 *    @return   计算高度
 */
func CalculateHeight(size: CGSize, referenceWidth: CGFloat) -> CGFloat {
    
    var rate : CGFloat = size.width/size.height
    
    if rate.isNaN || rate.isZero {
    
        rate = 1.0
    }
    
    let referenceHeight : CGFloat = referenceWidth / rate
    
    return referenceHeight
}

class XYRIImage : XYResourceItem {
    
    static let ResourceType : XYResourceType = XYResourceType.Picture

    override init(resourceAddress: XYResourceAddress, resourceType: XYResourceType = XYRIImage.ResourceType) {
        
        super.init(resourceAddress: resourceAddress, resourceType: resourceType)
    }
    
    lazy var imageOrNil: UIImage? = {
        
        guard self.resourceAddress.type == .Path,
            let image = UIImage(imgPath: self.resourceAddress.address) else { return nil }
        
        return image
    }()
    
    lazy var imageSizeOrNil : CGSize? = {
        
        guard let image = self.imageOrNil else { return nil }
        
        return image.size
    }()
    
    lazy var imgFormatOrNil: XYFileFormat.ImageFormat? = {
        
        guard self.resourceAddress.type == .Path,
            let imgData = try? Data(contentsOf: URL(fileURLWithPath: self.resourceAddress.address), options: Data.ReadingOptions.dataReadingMapped) else { return nil }
        
        return imgData.imageFormat
    }()
    
    static func ImgRIArrNotEqual(format: XYFileFormat.ImageFormat, imgRIArr: XYRIImage.ModelArray) -> XYRIImage.ModelArray? {
        
        var results: XYRIImage.ModelArray = XYRIImage.ModelArray()
        
        for imgRI in imgRIArr {
            
            guard let formatForImg = imgRI.imgFormatOrNil,
                formatForImg != format else { continue }
            
            results.append(imgRI)
        }
        
        guard results.isNotEmpty else { return nil }
        
        return results
    }
    
}

extension XYRIImage {
    
    convenience init?(data: Any) {
        
        /*
         {
         "fileUrl" : "http:\/\/testimage.queryall.cn\/product\/group\/85E5FB6A87BE4F46AD1708DF0AB6A374.png",
         "width" : 169,
         "height" : 219
         }
        */
        
        guard let dataDic = data as? [String: Any],
            let fileUrl = dataDic["fileUrl"] as? String,
            let address = XYResourceAddress(address: fileUrl, type: .URL) else { return nil }
        
        self.init(resourceAddress: address)
        
        if let widthStr = dataDic["width"] as? String,
            let width = widthStr.toCGFloatOrNil,
            let heightStr = dataDic["height"] as? String,
            let height = heightStr.toCGFloatOrNil {
            
            self.imageSizeOrNil = CGSize(width: width, height: height)
        }
    }
    
    func creatViewAttText(_ referenceWidthOrNil: CGFloat? = nil) -> NSAttributedString? {
        
        guard var size: CGSize = self.imageSizeOrNil else { return nil }
        
        if let referenceWidth = referenceWidthOrNil {
            
            let referenceHeight = CalculateHeight(size: size, referenceWidth: referenceWidth)
            
            size = CGSize(width: referenceWidth, height: referenceHeight)
        }
        
        let imgView = BaseImageView(frame: CGRect(origin: CGPoint.zero, size: size))
        imgView.setContentMode(.scaleToFill)
            .setBackgroundColor(argb: 0xffE5E5E5)
        
        switch self.resourceAddress.type {
        case .URL:
            imgView.setImageFromURL(URLString: self.resourceAddress.address, placeholder: UIImage.CreateBy(attText: UIImage.LoadingAttText, size: size), fetchedBlock: nil)
            break
            
        case .Path:
            imgView.setImageWithPath(self.resourceAddress.address)
            break
        }

        imgView.canShowByPhotoBrower()
        
        size.width += UIW(10)
        size.height += UIW(15)
        
        return NSAttributedString.yy_attachmentString(withContent: imgView, contentMode: UIView.ContentMode.center, attachmentSize: size, alignTo: XYFont.Font(size: 16), alignment: YYTextVerticalAlignment.center)
    }

    
}

/// NSCopying
extension XYRIImage : XYCopyProtocol {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let newObj = XYRIImage(resourceAddress: self.resourceAddress)
        newObj.queueIdOrNil = self.queueIdOrNil
        
        return newObj
    }
}




