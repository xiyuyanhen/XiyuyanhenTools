//
//  MutableStepView.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/11/2.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SingleStepView : BaseView {

    override func initProperty() {
        super.initProperty()
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.leftLine)
        self.addSubview(self.rightLine)
        self.addSubview(self.dot)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.dot.autoAlignAxis(.vertical, toSameAxisOf: self)
        self.dot.autoAlignAxis(.horizontal, toSameAxisOf: self)
        
        self.leftLine.autoSetDimension(.height, toSize: UIW(2.0))
        self.leftLine.autoAlignAxis(.horizontal, toSameAxisOf: self.dot)
        self.leftLine.autoPinEdge(.leading, to: .leading, of: self, withOffset: 0)
        self.leftLine.autoPinEdge(.trailing, to: .leading, of: self.dot, withOffset: 0)
        
        self.rightLine.autoSetDimension(.height, toSize: UIW(2.0))
        self.rightLine.autoAlignAxis(.horizontal, toSameAxisOf: self.dot)
        self.rightLine.autoPinEdge(.leading, to: .trailing, of: self.dot, withOffset: 0)
        self.rightLine.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: 0)

    }
    
    lazy var leftLine: UIView = {
        
        let line = UIView.newAutoLayout()
//        line.setHidden(true)
        
        return line
    }()
    
    lazy var dot: UIView = {
       
        let dotView = UIView.newAutoLayout()
        dotView.layer.masksToBounds = true

        dotView.setXYControlStateChangeBlock(block: { (viewOrNil, state) in
            
            guard let view = viewOrNil as? UIView else { return }
            
            let width : CGFloat
            if state == .normal {
                
                width = UIW(30)
            }else {
                
                width = UIW(15)
            }
            
            view.layer.cornerRadius = width/2.0
            
            if let heightLC = view.xyLayoutConstraints.height,
                let widthLC = view.xyLayoutConstraints.width {
                
                heightLC.constant = width
                widthLC.constant = width
                
            }else {
                
                view.autoSetDimensions(to: CGSize(width: width, height: width))
            }
            
        })
        dotView.xyControlState = UIView.XYControlState.normal
        
        
        return dotView
    }()
    
    lazy var rightLine: UIView = {
        
        let line = UIView.newAutoLayout()
//        line.setHidden(true)
        
        return line
    }()
}

class MutableStepView : BaseView {
    
    typealias StepModel = String
    typealias StepModelArray = [String]
    
    override func initProperty() {
        super.initProperty()
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.contentView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.contentView.autoEdgesPinView(otherView: self, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0))
    }

//    lazy var tapGR: UITapGestureRecognizer = {
//
//        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapGRHandle(tapGR:)))
//
//        self.addGestureRecognizer(tapGR)
//
//        return tapGR
//    }()

    @objc func tapGRHandle(tapGR: UITapGestureRecognizer) {
        
        guard let tapView = tapGR.view else { return }
        
        XYLog.LogNoteBlock { () -> String? in
            
            return "TapGR_Tag: \(tapView.tag)"
        }
        
        self.changeIndex(index: tapView.tag)
        
        self.rxSelectIndex.onNext(tapView.tag)
    }
    
    lazy var rxSelectIndex: PublishSubject<Int> = {
        
        return PublishSubject<Int>()
    }()
    
    lazy var contentView: UIView = {
        
        let view = UIView.newAutoLayout()
        
        return view
    }()

    var unSelectedColor : UIColor = XYColor(custom: .xdddddd).uicolor
    var selectedColor : UIColor = XYColor(custom: .main).uicolor
    
    var modelArrCache : StepModelArray = StepModelArray()
    
    func changeIndex(index: Int) {
        
        self.setups(modelArr: self.modelArrCache, currentIndex: index)
    }

    func setups(modelArr: StepModelArray, currentIndex: Int = 0) {
        
        let supView = self.contentView
        supView.removeSubviews()
        
        guard 0 < modelArr.count else { return }
        
        self.modelArrCache = modelArr
        
        var lastViewOrNil: SingleStepView? = nil
        var stepViewArr : [SingleStepView] = [SingleStepView]()
        
        for index in 0 ..< modelArr.count {
            
            let model = modelArr[index]
            
            let stepView = SingleStepView.newAutoLayout()
            stepView.tag = index
            
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tapGRHandle(tapGR:)))
            stepView.addGestureRecognizer(tapGR)
            
            supView.addSubview(stepView)
            stepViewArr.append(stepView)
            
            stepView.autoSetDimension(.height, toSize: UIW(40))
            if let lastView = lastViewOrNil {
                
                stepView.autoLeadingPinViewTrailing(otherView: lastView, edges: .top)
                
            }else{
                
                stepView.autoPinView(otherView: supView, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .top, .leading, .bottom)
            }
            
            if index == 0 {
                
                stepView.leftLine.setHidden(true)
            }else if index == modelArr.count-1 {
                
                stepView.rightLine.setHidden(true)
            }
            
//            if index < currentIndex {
//
//                stepView.dot.backgroundColor = self.selectedColor
//                stepView.leftLine.backgroundColor = self.selectedColor
//                stepView.rightLine.backgroundColor = self.selectedColor
//
//            }else if index == currentIndex {
//
//                stepView.dot.backgroundColor = self.selectedColor
//                stepView.leftLine.backgroundColor = self.selectedColor
//                stepView.rightLine.backgroundColor = self.unSelectedColor
//
//            }else{
//
//                stepView.dot.backgroundColor = self.unSelectedColor
//                stepView.leftLine.backgroundColor = self.unSelectedColor
//                stepView.rightLine.backgroundColor = self.unSelectedColor
//            }
            
            if index == currentIndex {
                
                stepView.dot.backgroundColor = self.selectedColor
                stepView.leftLine.backgroundColor = self.unSelectedColor
                stepView.rightLine.backgroundColor = self.unSelectedColor
                
                stepView.dot.xyControlState = UIView.XYControlState.normal
                
            }else{
                
                stepView.dot.backgroundColor = self.unSelectedColor
                stepView.leftLine.backgroundColor = self.unSelectedColor
                stepView.rightLine.backgroundColor = self.unSelectedColor
                
                stepView.dot.xyControlState = UIView.XYControlState.selected
            }
            
            lastViewOrNil = stepView
        }
        
        if let lastView = lastViewOrNil {
            
            lastView.autoPinEdge(.trailing, to: .trailing, of: supView, withOffset: 0)
        }
        
        let stepViewNSArr = stepViewArr as NSArray
        stepViewNSArr.autoMatchViewsDimension(.width)
    }
    
}
