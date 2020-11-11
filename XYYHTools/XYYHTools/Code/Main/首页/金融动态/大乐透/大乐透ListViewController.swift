//
//  大乐透ListViewController.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/11/11.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

class 大乐透ListViewController : BaseViewController {
    
    override func initProperty() {
        super.initProperty()
        
        self.title = "大乐透"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.loadList(loadStatus: XYNPDLoadStatus.NeedLoadFirst)
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
    
    @IBOutlet weak var contentContainerView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
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
            
            weakSelf.loadList(loadStatus: XYNPDLoadStatus.NeedLoadFirst)
        })
    }()
    
    lazy var refreshFooter: MJRefreshBackStateFooter = {
        
        return MJRefreshBackStateFooter(refreshingBlock: { [weak self] in
            
            guard let weakSelf = self else { return }
        
            //更新
            weakSelf.loadList(loadStatus: XYNPDLoadStatus.CanLoadMore)
        })
    }()
    
    lazy var pagingDatas : XYNetworkPagingData<XYBmobObject_大乐透> = {
        
        let newValue = XYNetworkPagingData<XYBmobObject_大乐透>()
        
        // 设置单页请求量
        newValue.setPageSize(20, padSize: 50)
        
        // 下拉刷新控件
        newValue.bindNewRefreshHeaderBy(self.refreshHeader)
        
        // 上拉加载控件
        newValue.bindNewRefreshFooterBy(self.refreshFooter)
        
        /// 数据变动响应处理
        newValue.rxDataChanged.subscribe(onNext: { [weak self] (pagingData) in
            guard let weakSelf = self else { return }
            
            let count = pagingData.allElementCount()
            
            if count < pagingData.loadPageSize {
                
                weakSelf.tableView.mj_footer = nil
                
            }else  if weakSelf.tableView.mj_footer == nil {
                    
                weakSelf.tableView.mj_footer = weakSelf.refreshFooter
            }
            
            weakSelf.tableView.reloadData()
            
        }).disposed(by: self.disposeBag)
        
        return newValue
    }()

}

extension 大乐透ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    typealias TableViewRowData = Any
    typealias TableViewSectionData = [TableViewRowData]
    
    func numberOfSections(in tableView: UITableView) -> Int {
            
        self.pagingDatas.pageCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.pagingDatas.elementCountByPage(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
        if let element = self.pagingDatas.elementBy(indexPath: indexPath) {
            
            let newValue = tableView.dequeueReusableCell(withIdentifier: 大乐透_TableViewCell.ReuseIdentifier(), for: indexPath) as! 大乐透_TableViewCell
            
            newValue.setupsBy(model: element)
            
            return newValue
        }

        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
}

extension 大乐透ListViewController {
    
    private func loadList(loadStatus: XYNPDLoadStatus) {
        
        let (loadIndex, size) = self.pagingDatas.indexAndSizeBy(status: loadStatus)
        
        /// 大乐透
        XYBmobObject_大乐透.Request(size: size, pageNo: loadIndex+1) { [weak self] (modelsOrNil) in
            
            guard let weakSelf = self else { return }
            
            defer {
                
                weakSelf.pagingDatas.endRefreshing()
            }
            
            weakSelf.pagingDatas.insertElementsNew(index: loadIndex, elements: modelsOrNil)
            
            guard let models = modelsOrNil else { return }
            
            XYDispatchQueueType.Public.xyAsync {
                
                for model in models {
                    
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
        }
    }
}

extension 大乐透ListViewController: XYStoryboardLoadProtocol {
    
    static var StoryboardName: String { return "首页_Storyboard"}
    
    static var StoryboardIdentifier: String { return "大乐透ListViewController" }
}
