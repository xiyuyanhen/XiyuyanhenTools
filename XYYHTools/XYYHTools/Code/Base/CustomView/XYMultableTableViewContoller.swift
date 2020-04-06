//
//  XYMultableTableViewContoller.swift
//  EStudy
//
//  Created by Xiyuyanhen on 2018/7/18.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation

class XYMultableTableView : BaseView, UITableViewDelegate, UITableViewDataSource {
    
    override func initProperty() {
        super.initProperty()
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        self.addSubview(self.mulTableViewContainerView)
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        
        self.mulTableViewContainerView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
    }
    
    var subTableViewArr = [BaseTableView]()
    
    lazy var mulTableViewContainerView : BaseTableView = {
        
        let rect = CGRect(x: 0, y: 0, width: ScreenHeight(), height: ScreenWidth())
        let containerView = BaseTableView(frame: rect, style: UITableView.Style.plain)
        
        containerView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        containerView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
        containerView.showsHorizontalScrollIndicator = false
        containerView.showsVerticalScrollIndicator = false
        
        containerView.bounces = false

        containerView.xyRegister(XYMultableTableViewCell.self)
        
        containerView.delegate = self
        containerView.dataSource = self
        
        return containerView
    }()
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.subTableViewArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ScreenWidth()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let subTableView = self.subTableViewArr[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: XYMultableTableViewCell.ReuseIdentifier(), for: indexPath) as! XYMultableTableViewCell
        
        let bounds = tableView.bounds
        
        subTableView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        
//        let newRect = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
////        subTableView.frame = newRect
//        
//        cell.frame = newRect
        
//        cell.addSubview(subTableView)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

class XYMultableTableViewCell : BaseTableViewCell {
    
    override func initProperty() {
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func setupsContent(tableView:BaseTableView){
        
        self.cellView.removeSubviews()
        
        

        
        self.cellView.addSubview(tableView)
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()

    }
    
    override func layoutAllViews() {
        super.layoutAllViews()

    }
    
}


