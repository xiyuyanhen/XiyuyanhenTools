//
//  首页ViewController.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

extension 首页ViewController {
    
    
}

class 首页ViewController : BaseViewController {
    
    override func initProperty() {
        super.initProperty()
        
        self.title = "检查作业"
        
        self.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
    }
    
    @IBOutlet weak var titleContainerView: UIView!
    
    @IBOutlet weak var contentContainerView: UIView!
    
    @IBOutlet weak var tableView: BaseTableView! {
        
        willSet {
            
            newValue.contentInset = UIEdgeInsetsMake(0, 0, UIH(50), 0)
            newValue.alwaysBounceHorizontal = false
            newValue.showsVerticalScrollIndicator = false
            newValue.showsHorizontalScrollIndicator = false
            
            newValue.xyRegisterNib(TableViewCell.self)
            
            newValue.estimatedSectionHeaderHeight = 0.0
            
            newValue.delegate = self
            newValue.dataSource = self
            
            //下拉刷新
            newValue.mj_header = self.refreshHeader
        }
    }
    
    lazy var refreshHeader: MJRefreshNormalHeader = {
        
        return MJRefreshNormalHeader(refreshingBlock: { [weak self] in

            guard let weakSelf = self else { return }
            
            RequestData_Bitstamp.Ticker { (modelOrNil) in
                
                weakSelf.refreshHeader.endRefreshing()
                
                guard let model = modelOrNil else { return }
                
                weakSelf.dataArr.append(model)
                
                weakSelf.tableView.reloadData()
            }
        })
    }()
    
    lazy var dataArr: TableViewSectionData = {
        
        return TableViewSectionData()
    }()
    
    @IBOutlet weak var headerView: UIView!
    
}

extension 首页ViewController: UITableViewDelegate, UITableViewDataSource {
    
    typealias TableViewRowData = Any
    typealias TableViewSectionData = [TableViewRowData]
    typealias TableViewCell = HomeworkItemTableViewCell
    
    func numberOfSections(in tableView: UITableView) -> Int {
            
        1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let newValue = UIView.newAutoLayout()
//        newValue.setBackgroundColor(customColor: .xf6f6f6)
//
//        let titleLabel = BaseLabel.newAutoLayout()
//                    .setText("2019-09-05 16:33:04")
//                    .setFont(XYFont.BoldFont(size: 15))
//                    .setTextColor(customColor: .x999999)
//                    .setNumberOfLines(1)
//                    .setTextAlignment(.left)
//
//        newValue.addSubview(titleLabel)
//
//        newValue.autoSetDimensions(to: CGSize(width: ScreenWidth(), height: UIW(50)))
//
//        titleLabel.autoPinView(otherView: newValue, edgeInsets: UIEdgeInsets(adjustBy: 0, 14, 0, -14), edges: .leading, .bottom, .trailing)
//
//        newValue.xyUpdateFrameFromAutoLayout()
//        newValue.changeFrameByNewOrigin()
//
//        return newValue
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        let newValue = tableView.dequeueReusableCell(withIdentifier: TableViewCell.ReuseIdentifier(), for: indexPath) as! TableViewCell
                
        if let element = self.dataArr.elementByIndex(indexPath.row) {
            
            if let model = element as? VirtualCurrencyModel {
                
                newValue.setupsBy(model: model)
            }
            
        }

        cell = newValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
}

extension 首页ViewController {
    
}

extension 首页ViewController: XYStoryboardLoadProtocol {
    
    static var StoryboardName: String { return "首页_Storyboard"}
    
    static var StoryboardIdentifier: String { return "首页ViewController" }
}
