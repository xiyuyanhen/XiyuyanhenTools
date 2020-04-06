//
//  StartView.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/7/17.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

struct StartView {
    
    var containerView:UIButton
    let radians:Bool
    
    var startSpace:CGFloat = UIW(4)
    var startWidth:CGFloat = UIW(12)
    
    func startYellowImg() -> UIImage? {
        return UIImage(named: "Public_Start_Lingth")
    }
    
    func startGaryImg() -> UIImage? {
        return UIImage(named: "Public_Start_Gary")
    }
    
    func startRedImg() -> UIImage? {
        return UIImage(named: "Public_Start_Red")
    }
    
    var bgImgNameOrNil : String? = nil
    var validateImgNameOrNil : String? = nil
    
    init(startNum:NSInteger, startWidth:CGFloat = UIW(12), radians:Bool = false) {
        
        let container = UIButton.newAutoLayout()
        container.setBackgroundColor(customColor: .clear)
        
        self.containerView = container
        self.radians = radians
        
        self.startWidth = startWidth
        
        self.setups(startNum: startNum)
    }
    
    /// 根据得分百分比返回应该显示多少颗星星
    static func StarNumberOfScore(score: Float) -> Int {
        
        //过滤不正常的数字 (Zero is neither a normal nor a subnormal)
        guard score.isNormal || score.isZero else { return 0 }
        
        var newScore = score
        if newScore < 0.0 {
            
            newScore = 0.0
        }else if 100.0 < newScore {
            
            newScore = 100.0
        }
        
        let starNum:Int
        if newScore <= 5.0 {
            
            starNum = 0
        }else if newScore < 50.0 {
            
            starNum = 1
        }else if newScore < 70.0 {
            
            starNum = 2
        }else if newScore < 80.0 {
            
            starNum = 3
        }else if newScore < 90.0 {
            
            starNum = 4
        }else{
            
            starNum = 5
        }
        
        return starNum
    }
    
    /*
     /v2
     评分星级逻辑:得分百分比
     5%及以下，无星
     50%以下，一星
     50%-70%，二星
     70%-80%，三星
     80%-90%，四星
     90%-100%，五星
     */
    //hundred-mark system
    func setups(mark:Float, bgImgOrNil:UIImage? = nil, validateImgOrNil:UIImage? = nil) {
        
        //过滤不正常的数字 (Zero is neither a normal nor a subnormal)
        guard mark.isNormal || mark.isZero else { return }
        
        var newMark = mark
        if newMark < 0.0 {
            
            newMark = 0.0
        }else if 100.0 < newMark {
            
            newMark = 100.0
        }
        
        let startNum:NSInteger
        if newMark <= 5.0 {
            
            startNum = 0
        }else if newMark < 50.0 {
            
            startNum = 1
        }else if newMark < 70.0 {
            
            startNum = 2
        }else if newMark < 80.0 {
            
            startNum = 3
        }else if newMark < 90.0 {
            
            startNum = 4
        }else{
            
            startNum = 5
        }
        
        self.setups(startNum: startNum, bgImgOrNil: bgImgOrNil, validateImgOrNil: validateImgOrNil)
    }
    
    func setups(startNum:NSInteger, bgImgOrNil:UIImage? = nil, validateImgOrNil:UIImage? = nil){
        
        var newBgImgOrNil : UIImage? = bgImgOrNil
        if newBgImgOrNil == nil,
            let bgImgName = self.bgImgNameOrNil,
            bgImgName.isNotEmpty,
            let bgImg = UIImage(named: bgImgName) {
            
            newBgImgOrNil = bgImg
        }
        
        var newValidateImgOrNil : UIImage? = validateImgOrNil
        if newValidateImgOrNil == nil,
            let validateImgName = self.bgImgNameOrNil,
            validateImgName.isNotEmpty,
            let validateImg = UIImage(named: validateImgName) {
            
            newValidateImgOrNil = validateImg
        }
        
        self.containerView.removeSubviews()
        
        var score = 0
        if (0 <= startNum) && (startNum <= 5){
            
            score = Int(startNum)
        }
        
        let max = 5
        let start = (score <= max) ? score : 0
        
        var lastImgView:BaseImageView?
        for index in 1...max {
            
            let startImgView = BaseImageView.newAutoLayout()
            startImgView.setContentMode(.scaleAspectFit)
            
            let newValidateImgOrNil = newValidateImgOrNil ?? self.startYellowImg()
            let bgImg = newBgImgOrNil ?? self.startGaryImg()
            
            startImgView.image = (index <= start) ? newValidateImgOrNil : bgImg
            
            self.containerView.addSubview(startImgView)
            
            startImgView.autoSetDimensions(to: CGSize(width: UIW(self.startWidth), height: UIW(self.startWidth)))
            
            var space:CGFloat = 0.0
            if self.radians {
                
                var startIndex:Int = index - 3
                if startIndex < 0 {
                    
                    startIndex = -startIndex
                }
                let s = UIH(8)
                space = CGFloat(startIndex)*s
            }
            
            if lastImgView == nil {
                
                startImgView.autoPinView(otherView: self.containerView, edgeInsets: UIEdgeInsetsMake(space, 0, 0, 0), edges: .top, .leading, .bottom)
                startImgView.autoPinView(otherView: self.containerView, edges: .top, .leading, .bottom)
            }else{
                
                startImgView.autoPinEdge(.leading, to: .trailing, of: lastImgView!, withOffset: self.startSpace)
                startImgView.autoAlignAxis(.horizontal, toSameAxisOf: lastImgView!)
            }
            
            lastImgView = startImgView
        }
        
        if lastImgView != nil {
            
            lastImgView?.autoPinEdge(.trailing, to: .trailing, of: self.containerView)
        }
    }
}
