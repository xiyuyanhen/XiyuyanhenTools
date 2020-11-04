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
    
        self.refreshData()
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
            
            newValue.xyRegisterNib(HomeworkItemTableViewCell.self, 大乐透_TableViewCell.self)
            
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
            
            weakSelf.refreshData()
        })
    }()
    
    lazy var dataArr: TableViewSectionData = {
        
        return TableViewSectionData()
    }()
    
    private var virtualCurrencyModelOrNil: VirtualCurrencyModel?
    
    private var 大乐透ModelOrNil: XYBmobObject_大乐透?
    
    @IBOutlet weak var headerView: UIView!
    
}

extension 首页ViewController: UITableViewDelegate, UITableViewDataSource {
    
    typealias TableViewRowData = Any
    typealias TableViewSectionData = [TableViewRowData]
    
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
             
        if let element = self.dataArr.elementByIndex(indexPath.row) {
            
            if let model = element as? VirtualCurrencyModel {
                
                let newValue = tableView.dequeueReusableCell(withIdentifier: HomeworkItemTableViewCell.ReuseIdentifier(), for: indexPath) as! HomeworkItemTableViewCell
                
                newValue.setupsBy(model: model)
                
                return newValue
                
            }else if let model = element as? XYBmobObject_大乐透 {
                
                let newValue = tableView.dequeueReusableCell(withIdentifier: 大乐透_TableViewCell.ReuseIdentifier(), for: indexPath) as! 大乐透_TableViewCell
                
                newValue.setupsBy(model: model)
                
                return newValue
            }
        }

        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
}

extension 首页ViewController {
    
    private func refreshData() {
        
        /// BTC
        RequestData_Bitstamp.Ticker { [weak self] (modelOrNil) in
            guard let weakSelf = self else { return }
            
            weakSelf.refreshHeader.endRefreshing()
            
            guard let model = modelOrNil else { return }
            
            weakSelf.virtualCurrencyModelOrNil = model
            
            weakSelf.reloadDataTableView()
    
        }
        
        /// 大乐透
        XYBmobObject_大乐透.Request(size: 1) { [weak self] (modelsOrNil) in
            
            guard let weakSelf = self else { return }
            
            weakSelf.refreshHeader.endRefreshing()
            
            guard let models = modelsOrNil,
                let model = models.first else { return }
            
            weakSelf.大乐透ModelOrNil = model
            
            weakSelf.reloadDataTableView()
            
            model.save { (result) in

                switch result {
                case .Complete(let object):

                    XYLog.LogNote(msg: "保存数据成功(\(object.objectId ?? ""))")
                    break

                case .Error(let error):

                    XYLog.LogNote(msg: "error: \(error.detailMsg)(\(error.code))")
                    break
                }
            }
        }
    }
    
    private func reloadDataTableView() {
        
        var dataArr = TableViewSectionData()
        
        if let model = self.virtualCurrencyModelOrNil {
            
            dataArr.append(model)
        }
        
        if let model = self.大乐透ModelOrNil {
            
            dataArr.append(model)
        }
        
        self.dataArr = dataArr
        
        self.tableView.reloadData()
    }
}

extension 首页ViewController: XYStoryboardLoadProtocol {
    
    static var StoryboardName: String { return "首页_Storyboard"}
    
    static var StoryboardIdentifier: String { return "首页ViewController" }
}
