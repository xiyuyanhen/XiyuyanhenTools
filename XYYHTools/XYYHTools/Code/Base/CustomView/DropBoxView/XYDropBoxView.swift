//
//  XYDropBoxView.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/12.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYDropBoxView : UIButton, XYViewNewAutoLayoutProtocol{
    
    // 当前是否展开了
    private(set) var isShow: Bool = false
    // 即将展示或隐藏完成后回调，形参true:展示；false:隐藏
    var willShowOrHideBoxListHandler: ((Bool) -> Void)?
    // 完成展示或隐藏完成后回调，形参true:展示；false:隐藏
    var didShowOrHideBoxListHandler: ((Bool) -> Void)?
    // 选择中了某个项回调，形参0~n-1
    var didSelectBoxItemHandler: ((Int) -> Void)?

    var currentItemIndex = -1
    
    fileprivate lazy var items: [String] = {
        
        return [String]()
    }()
    
    /// 列表父视图
    var tableViewSuperViewOrNil: UIView?
    
    //newAutoLayout()会调用此方法创建View
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.initProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initProperty() {
        
        self.setBackgroundColor(customColor: .white)
            .setLayerBorder(width: 1.0, color: .xe5e5e5)
            .setLayerCornerRadius(UIW(8))
        
        self.addTarget(self, action: #selector(onboxButtonAction), for: .touchUpInside)
    }
    
    lazy var boxTitle: BaseLabel = {
        
        let newValue = BaseLabel.newAutoLayout()
        newValue.setText("")
            .setFont(XYFont.Font(size: 14))
            .setTextColor(customColor: .x999999)
            .setNumberOfLines(1)
            .setTextAlignment(.left)
        
        return newValue
    }()
    
    fileprivate lazy var boxArrow: BaseImageView = {
        
        let newValue = BaseImageView.newAutoLayout()
        newValue.setContentMode(.scaleAspectFill)
            .setImageByName("Public_Drop_Black")
        
        return newValue
    }()
    
    fileprivate lazy var listTableView = { () -> BaseTableView in
        
        let newValue = BaseTableView.newAutoLayout()
        newValue.setBackgroundColor(customColor: .xf6f6f6)
        newValue.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        newValue.alwaysBounceHorizontal = false
        newValue.showsVerticalScrollIndicator = false
        newValue.showsHorizontalScrollIndicator = false
//        newValue.bounces = false
        
        newValue.xyRegister(XYDropBoxTableViewCell.self);
        newValue.delegate = self
        newValue.dataSource = self
        
        return newValue
    }()
    
    lazy var listTableViewHeightLC: NSLayoutConstraint = {
        
//        self.listTableView.autoSetDimension(.height, toSize: UIW(300), relation: .lessThanOrEqual)
        
        let heightLC = self.listTableView.autoSetDimension(.height, toSize: UIW(300), relation: .equal)
//        heightLC.priority = .dragThatCanResizeScene
        
        return heightLC
    }()
    
    override func updateConstraints() {
        
        if self.xyIsDidUpdateConstraints == false {
            
            self.layoutAddViews()
            self.layoutAllViews()
            self.xyIsDidUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func layoutAddViews() {
        
        self.addSubviews(self.boxTitle, self.boxArrow)
    }
    
    func layoutAllViews() {
        
        self.boxTitle.autoAlignAxis(.horizontal, toSameAxisOf: self)
        self.boxTitle.autoPinEdge(.leading, to: .leading, of: self, withOffset: UIW(10))
        
        self.boxArrow.autoSetDimensions(to: CGSize(width: UIW(9), height: UIW(5)))
        self.boxArrow.autoAlignAxis(.horizontal, toSameAxisOf: self)
        self.boxArrow.autoPinEdge(.leading, to: .trailing, of: self.boxTitle, withOffset: UIW(3))
        self.boxArrow.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -UIW(10))
    }
    
    func setups(defaultTitle: String, items: [String]) {
        
        self.boxTitle.setText(defaultTitle)
        
        self.items.removeAll()
        self.items.append(contentsOf: items)
        
        self.listTableView.reloadData()
    }
    
    func setBoxTitle(title: String) {
        
        self.boxTitle.setTextColor(customColor: .x333333).setFont(XYFont.Font(size: 14))
        
        self.boxTitle.text = title
    }
}

extension XYDropBoxView {
    
    // MARK: - Public Methods
    func currentTitle() -> String {
        return self.boxTitle.text!
    }

    // MARK: - Private Methods
    @objc fileprivate func onboxButtonAction(_ sender: UIButton) {
        (self.isShow == true) ? self.hideBoxList() : self.showBoxList()
    }

    @objc fileprivate func onHideBoxList(_ sender: UITapGestureRecognizer) {
        self.hideBoxList()
    }

    func showBoxList() {
        
        guard self.isShow == false else { return }

        self.rotateBoxArrow()
        self.isShow = true

        self.willShowOrHideBoxListHandler?(true)
        
        guard var itemCount = [self.items.count, 10].min() else { return }
        
        if itemCount == 0 {
            
            itemCount = 1
        }
        
        
        if self.listTableView.superview == nil,
            let superView: UIView = self.tableViewSuperViewOrNil ?? self.superview {
            
            superView.addSubview(self.listTableView)
            
            self.listTableView.autoTopPinViewBottom(otherView: self, edgeInsets: UIEdgeInsetsMake(0, UIW(3), 0, -UIW(3)), edges: .leading, .trailing)
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                
                self.listTableViewHeightLC.constant = CGFloat(itemCount) * UIW(40)
        }, completion: { _ in
            self.didShowOrHideBoxListHandler?(true)
        })
    }

    func hideBoxList() {
        
        guard self.isShow else { return }

        self.rotateBoxArrow()
        self.isShow = false

        self.willShowOrHideBoxListHandler?(false)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                
                self.listTableViewHeightLC.constant = 0
            },
            completion: { _ in
                
                self.didShowOrHideBoxListHandler?(false)
            }
        )
    }

    fileprivate func rotateBoxArrow() {
        
        let angle: CGFloat = ((self.isShow) ? -179.9 : 179.9)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.boxArrow.transform = self.boxArrow.transform.rotated(by: angle * CGFloat.pi/180.0)
        })
    }

    fileprivate func didSelectItem(row: Int) {
        
        /// 上次选中的索引
        var oldSelectedIndexOrNil: Int?
        
        if self.currentItemIndex == -1 {
            
            self.boxTitle.setTextColor(customColor: .x333333).setFont(XYFont.Font(size: 14))
        }else {
            
            oldSelectedIndexOrNil = self.currentItemIndex
        }

        self.currentItemIndex = row
        self.boxTitle.text = self.items[self.currentItemIndex]
        self.hideBoxList()
        
        if let oldSelectedIndex = oldSelectedIndexOrNil {
            
            self.listTableView.reloadRows(at: [IndexPath(row: oldSelectedIndex, section: 0)], with: UITableView.RowAnimation.none)
        }
        
        self.listTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: UITableView.RowAnimation.none)

        self.didSelectBoxItemHandler?(row)
    }
}

extension XYDropBoxView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XYDropBoxTableViewCell.ReuseIdentifier(), for: indexPath) as! XYDropBoxTableViewCell
        
        if let item = self.items.elementByIndex(indexPath.row) {
            
            cell.textLabel?.text = item
        }
        
        cell.xyControlState = (self.currentItemIndex == indexPath.row).xyReturn(.selected, .normal)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.didSelectItem(row: indexPath.row)
    }
}

class XYDropBoxTableViewCell: BaseTableViewCell {

    override func initProperty() {
        
        self.textLabel?.setNumberOfLines(1)
            .setFont(XYFont.Font(size: 14))
        
        self.setXYControlStateChangeBlock { (cell, state) in
            
            if state == .selected {
                
                cell.cellView.setBackgroundColor(customColor: .xf6f6f6)
                
                cell.textLabel?.setTextColor(customColor: .main)
                
            }else {
                
                cell.cellView.setBackgroundColor(customColor: .white)
                
                cell.textLabel?.setTextColor(customColor: .x333333)
            }
            
            cell.selectedImgView.setHidden(state != .selected)
        }
        self.xyControlState = .normal
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.cellView.addSubview(self.selectedImgView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
    
        self.cellView.autoSetDimension(.height, toSize: UIW(40))
        
        self.selectedImgView.autoSetDimensions(to: CGSize(squareByAdjust: 16))
        self.selectedImgView.autoAlignAxis(.horizontal, toSameAxisOf: self.cellView)
        self.selectedImgView.autoPinEdge(.trailing, to: .trailing, of: self.cellView, withOffset: -UIW(20))
    }
    
    lazy var selectedImgView: BaseImageView = {
        
        let imgView = BaseImageView.newAutoLayout()
            .setContentMode(.scaleAspectFit)
            .setHidden(true)
        
        imgView.setImageByName(APP_CurrentTarget.imageName("Public-selected"))
            
        return imgView
    }()
    
}
