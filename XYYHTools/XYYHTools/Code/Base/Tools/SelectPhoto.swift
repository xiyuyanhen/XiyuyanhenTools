//
//  SelectPhoto.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/2/14.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

class SelectPhoto: XYObject, UINavigationControllerDelegate {
    
    //单例
    private static let `default` = SelectPhoto();
    
    class func Share() -> SelectPhoto{
        
        let selectPhoto:SelectPhoto = self.default;
        
        return selectPhoto;
    }
    
    override private init() {
        
        super.init();
    }
    
    public typealias SelectPhotoBlock = (_ selectImage:UIImage?) -> Void
    
    var selectedImageBlock:SelectPhotoBlock?
    
    class func ShowSelectUserHeadImg(showedVC:UIViewController) {
        
        let selectPhoto = SelectPhoto.Share()
        
        selectPhoto.showSelectPhotoActionSheet(showedVC: showedVC) { (selectedImage:UIImage?) in
            
            guard let uploadImg = selectedImage else{
                
                ShowSingleBtnAlertView(title: "选择的图片存在错误")
                return
            }
            
            selectPhoto.upload(uploadImg: uploadImg) {}
        }
    }
    
//    var showedVC:UIViewController? = nil
    func showSelectPhotoActionSheet(showedVC:UIViewController, selectedImgBlock:@escaping SelectPhotoBlock) {
        
//        self.showedVC = showedVC
        
        self.selectedImageBlock = selectedImgBlock
        
        var style = UIAlertController.Style.actionSheet
        
        if XYDevice.Model() == .iPad {
            
            style = .alert
        }
        
        let selectPhotoAS = UIAlertController(title: "选择图片来源方式", message: "", preferredStyle: style)
        
        let photoAction = UIAlertAction(title: "相册", style: .default) { (alertAction) in
            
            self.selectPhotoByImagePicker(showedVC: showedVC, sourceType: UIImagePickerController.SourceType.photoLibrary, allowsEditing: false)
        }
        
        selectPhotoAS.addAction(photoAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraAction = UIAlertAction(title: "相机", style: .default) { (alertAction) in
                
//                let screenSize = UIScreen.main.bounds.size
//                let aspectRatio:CGFloat = 4.0/3.0
//                let scale = screenSize.height/screenSize.width * aspectRatio
//
//                /// 全屏尺寸拍摄
//                let cameraViewTransform = CGAffineTransform(scaleX: scale, y: scale)
                
                self.selectPhotoByImagePicker(showedVC: showedVC, sourceType: UIImagePickerController.SourceType.camera)
            }
            
            selectPhotoAS.addAction(cameraAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (alertAction) in
            
            showedVC.dismiss(animated: true, completion: nil)
        }
        selectPhotoAS.addAction(cancelAction)
        
        showedVC.present(selectPhotoAS, animated: true, completion: nil)
        
    }
    
    func selectPhotoByImagePicker(showedVC:UIViewController, sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = true, cameraViewTransformOrNil: CGAffineTransform? = nil) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = allowsEditing
        
        if let cameraViewTransform = cameraViewTransformOrNil {
            
            imagePickerController.cameraViewTransform = cameraViewTransform
        }
        
        showedVC.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    var uploadingImgOrNil: UIImage? = nil
    
    // MARK: - 上传头像
    func upload(uploadImg:UIImage, completion: @escaping CompletionBlock){
        
        completion()
        
        /*
        guard let userInfo = UserManage.UserInfoOrNil else {
            
            completion()
            return
        }
        
        self.uploadingImgOrNil = uploadImg

        XYNetWorkManage.UploadImage(RequestConfig(url: RequestUrl_User.更新教师头像, parametersOrNil: ["teacherId": userInfo.userId]), img: uploadImg) { [weak self] (state) in
            
            guard let weakSelf = self else { return }
            
            switch state {
            case .Progress(_):
                break
            case .Complete(let completeState):
                
                switch completeState {
                case .Data(_):
                    break
                case .Failure(_):
                    break
                case .Success(let dataDic):
                    
                    if let wxAvatarUrl = userInfo.wxAvatarUrlOrNil,
                        wxAvatarUrl.isNotEmpty {
                        
                        UIImage.ClearImageCacheBy(URL: wxAvatarUrl)
                    }
                    
                    if let imgUrl: String = dataDic.xyObject("imgUrl"),
                        imgUrl.isNotEmpty {
                        
                        /// 保存新图片到图片缓存库在，节约图片下载的流程
                        UIImage.SetImageCacheBy(key: imgUrl, image: uploadImg)
                    }
                    
                    //更新用户信息
                    UserManage.UpdateUserInfoFromService()
                    
                    weakSelf.uploadingImgOrNil = nil
                    
                    break
                case .NeedLogin(_):
                    break
                }
                
                completion()
                
                return
                
            case .Error(let xyError):
                
                var note = "服务器异常，请确认网络是否正常或者稍候再试~"
                if xyError.detailMsg.isNotEmpty {
                    
                    note = "\(xyError.detailMsg)(\(xyError.code)"
                }
                
                ShowNormalAlertView(title: "上传头像失败", message: note, comfirmTitle: "再试一次", cancelTitle: "取消", showedVC: AppDelegate.Shared().tabbarController, comfirmBtnBlock: { (action) in
                    
                    weakSelf.upload(uploadImg: uploadImg, completion: completion)
                    
                }, cancelBtnBlock: nil)
                
                return
                
            default:
                break
            }
        }
        */
    }
}

extension SelectPhoto : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //        if (image != nil) {
        //            UIImage *userIcoImage =[UIImage createThumbImage:image size:CGSizeMake(300, 300)];
        //            [self uploadUerIco:userIcoImage];
        //
        //        }
        
        /*
         ▿ 7 elements
         ▿ 0 : 2 elements
         - key : "UIImagePickerControllerImageURL"
         - value : file:///Users/Xiyuyanhen/Library/Developer/CoreSimulator/Devices/4337341A-13E4-4FFB-B0DF-610FD7E541A8/data/Containers/Data/Application/C42C32C9-58EA-46F7-A677-FE82643CA3DA/tmp/A153A72A-F7EE-43C9-8A9F-DA75D32C4B19.jpeg
         ▿ 1 : 2 elements
         - key : "UIImagePickerControllerMediaType"
         - value : public.image
         ▿ 2 : 2 elements
         - key : "UIImagePickerControllerPHAsset"
         - value : <PHAsset: 0x7f8ec6438a90> 106E99A1-4F6A-45A2-B320-B0AD4A8E8473/L0/001 mediaType=1/0, sourceType=1, (4288x2848), creationDate=2011-03-13 00:17:25 +0000, location=1, hidden=0, favorite=0
         ▿ 3 : 2 elements
         - key : "UIImagePickerControllerReferenceURL"
         - value : assets-library://asset/asset.JPG?id=106E99A1-4F6A-45A2-B320-B0AD4A8E8473&ext=JPG
         ▿ 4 : 2 elements
         - key : "UIImagePickerControllerCropRect"
         - value : NSRect: {{0, 0}, {3072, 2039.808}}
         ▿ 5 : 2 elements
         - key : "UIImagePickerControllerEditedImage"
         - value : <UIImage: 0x6040000ab280> size {750, 496} orientation 0 scale 1.000000
         ▿ 6 : 2 elements
         - key : "UIImagePickerControllerOriginalImage"
         - value : <UIImage: 0x6040000b11c0> size {4288, 2848} orientation 0 scale 1.000000
         */
        
        let selectedImg : UIImage
        
        if let editedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            //获取编辑后的图片
            selectedImg = editedImg
            
        }else if let originalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            //获取原图
            selectedImg = originalImg
            
        }else {
            
            ShowSingleBtnAlertView(title: "无法获取此图片，请重新尝试")
            return
        }
        
        picker.dismiss(animated: true) {
            
            if  let block = SelectPhoto.Share().selectedImageBlock {
                
                block(selectedImg)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        XYLog.LogNoteBlock { () -> String? in
            
            return "取消选择图片"
        }
        
        // 退出
        picker.dismiss(animated: true) { }
    }
}




