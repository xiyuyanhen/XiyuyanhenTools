//
//  BaseTableView.swift
//  DPTools
//
//  Created by Xiyuyanhen on 2018/1/31.
//  Copyright © 2018年 Xiyuyanhen. All rights reserved.
//

import Foundation

@IBDesignable class BaseTableView: UITableView, XYViewNewByNibProtocol {

    override init(frame:CGRect, style:UITableView.Style) {

        super.init(frame: frame, style: style)
        
        self.initProperty()
    }
    
    convenience init(autoStyle: UITableView.Style) {
        
        self.init(frame: CGRect.zero, style: autoStyle)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.initProperty()
        
//        self.xyAddContentViewByNib()
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
        
        //iOS8以后这句话是默认的，所以可以省略这句话
        self.rowHeight = UITableView.automaticDimension
        
        //设置cell的估计高度
        self.estimatedRowHeight = 200

        //去掉分隔线
        self.separatorStyle = .none
    
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
    
    private var sectionIndexView:UIView? {
        
        //明确指定类型为AnyClass,否则编译器会有警告.
        //索引视图的类名为UITableViewIndex
        let tableViewIndexClass:AnyClass = NSClassFromString("UITableViewIndex")!
        
        for view in self.subviews {
            
            guard view.isKind(of: tableViewIndexClass) else { continue }
                
            let sectionIndexView = view
            
            return sectionIndexView
        }
        
        return nil
    }
    
    private var isIndexFontSeted : Bool = false
    
//    override func reloadData() {
//        super.reloadData()
//
//        if self.separatorStyle != .none {
//
//            //去掉分隔线
//            self.separatorStyle = .none
//        }
//        
//    }
    
}

extension BaseTableView {
    
    ///设置TableView索引的字体
    func setTableViewIndexFont(_ font:UIFont){
        
        
        guard self.isIndexFontSeted == false,
            let sectionIndexView = self.sectionIndexView else { return }
        
        //        let selector = Selector("setFont:")
        //        guard sectionIndexView.responds(to: selector) else { return }
        //        sectionIndexView.perform(selector, with: font)
        
        if let oldFont = sectionIndexView.value(forKeyPath: "_font") as? UIFont {
            
            sectionIndexView.setValue(font, forKey: "_font")
            
            let newSize = font.pointSize
            let oldSize = oldFont.pointSize
            let radio : CGFloat = newSize/oldSize
            
            //光是用上一句修改字体还不够,还需要修改siView的宽度.
            
            let frame = sectionIndexView.frame
            
            let newX = frame.origin.x - 10
            let newY = frame.origin.y
            let newWidth = radio * frame.size.width
            let newHeight = radio * frame.size.height
            
            sectionIndexView.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
            
        }
        
        self.isIndexFontSeted = true
    }
}

// MARK: - UITableView extension
extension UITableView {
    
    func setTableHeaderView(_ headerViewOrNil : UIView?, size: CGSize) {
        
        guard let headerView = headerViewOrNil else {
            
            self.tableHeaderView = nil
            return
        }
        
        let supView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        supView.addSubview(headerView)
        
        headerView.autoEdgesPinView(otherView: supView, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        
        self.tableHeaderView = supView
    }
    
    @discardableResult func setTableHeaderView(_ headerViewOrNil : UIView?, sizeOrNil: CGSize? = nil, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) -> UIView? {
        
        guard let headerView = headerViewOrNil else {
            
            self.tableHeaderView = nil
            return nil
        }
        
        let size : CGSize
        
        if let fixedSize = sizeOrNil {
            
            size = fixedSize
            
        }else {
            
            headerView.layoutIfNeeded()
            
            size = headerView.bounds.size
        }
        
        var frame = CGRect(x: 0,
                           y: 0,
                           width: size.width+edgeInsets.left+edgeInsets.right,
                           height: size.height+edgeInsets.top+edgeInsets.bottom)
        
        /// 重新计算实际大小
        let newSize = headerView.systemLayoutSizeFitting(CGSize(width: frame.size.width, height: 0))
        if newSize.height != frame.size.height {
            
            frame.size.height = newSize.height
        }
        
        let supView = UIView(frame: frame)
        
        supView.addSubview(headerView)
        
        headerView.autoEdgesPinView(otherView: supView, edgeInsets: UIEdgeInsetsMake(edgeInsets.top, edgeInsets.left, 0, 0))
        
        self.tableHeaderView = supView
        
        return supView
    }
    
    func setTableFooterView(_ footerViewOrNil : UIView?, size: CGSize) {
        
        guard let footerView = footerViewOrNil else {
            
            self.tableFooterView = nil
            return
        }
        
        let supView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        supView.addSubview(footerView)
        
        footerView.autoEdgesPinView(otherView: supView, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        
        self.tableFooterView = supView
    }
    
    static func CreateViewForHeaderInSection(title: String, size: CGSize) -> UIView {
        
        let attModel = NSAttributedString.AttributesModel(text: title, fontSize: 13, textColor: .x999999)
        
        return self.CreateViewForHeaderInSection(attText: attModel.attributedString(), size: size)
    }
    
    static func CreateViewForHeaderInSection(attText: NSAttributedString, size: CGSize) -> UIView {
        
        let label = BaseLabel.newAutoLayout()
        label.attributedText = attText
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.left
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        containerView.addSubview(label)
        
        label.autoAlignAxis(.horizontal, toSameAxisOf: containerView)
        label.autoPinEdge(.leading, to: .leading, of: containerView, withOffset: UIW(16))
        label.autoPinEdge(.trailing, to: .trailing, of: containerView, withOffset: -UIW(16))
        
        return containerView
    }
    
    
}



