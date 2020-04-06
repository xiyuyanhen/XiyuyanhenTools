//
//  XYLogBrowseViewController.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/24.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

class XYLogBrowseDataSectionModel: XYObject {
    
    let title: String
    var logMsgs: WCDB_XYLogMsg.ModelArray = WCDB_XYLogMsg.ModelArray()
    
    required init(title: String, msgs: WCDB_XYLogMsg.ModelArray = []) {
        
        self.title = title
        
        if msgs.isNotEmpty {
            
            self.logMsgs.append(contentsOf: msgs)
        }
        
        super.init()
    }
}

class XYLogBrowseViewController : BaseViewController {
    
    let sourceDataModel : XYLogBrowseDataModel
    
    init(sourceDataModel: XYLogBrowseDataModel) {
        
        self.sourceDataModel = sourceDataModel
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initProperty() {
        super.initProperty()
        
        self.enablePerformanceMonitor = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.sourceDataModel.dateText
        
        self.reloadTableViewData(dataModelOrNil: self.sourceDataModel)
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
        
        self.view.addSubviews(self.controlView, self.tableview, self.sectionIndexView)
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.controlView.autoPinView(otherView: self.view, edgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), edges: .top, .leading, .trailing)
        
        self.tableview.autoPinEdge(.top, to: .bottom, of: self.controlView, withOffset: 0)
        self.tableview.autoPinView(otherView: self.view, edges: .leading, .bottom, .trailing)
        
        self.sectionIndexView.autoPinEdge(.trailing, to: .trailing, of: self.tableview, withOffset: -UIW(5))
        self.sectionIndexView.autoAlignAxis(.horizontal, toSameAxisOf: self.tableview)
    }
    
    lazy var controlView : XYLogBrowseTableViewHeaderView = {
        
        let view = XYLogBrowseTableViewHeaderView.NewByNib()
        view.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.main, alpha: 0.2)
        
        view.scrollToTopBtn.addTarget(self, action: #selector(self.headerViewBtnsHandle(btn:)), for: .touchUpInside)
        view.scrollToBottomBtn.addTarget(self, action: #selector(self.headerViewBtnsHandle(btn:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
        
        return view
    }()
    
    lazy var tableview = { () -> BaseTableView in
        
        let newValue = BaseTableView(autoStyle: UITableView.Style.plain)
        newValue.setBackgroundColor(customColor: .xf6f6f6)
        newValue.contentInset = UIEdgeInsetsMake(0, 0, UIH(30), 0)
        
        newValue.xyRegister(TableViewCell.self)
        
        newValue.delegate = self
        newValue.dataSource = self
        
        newValue.estimatedSectionHeaderHeight = 0
        
        return newValue
    }()
    
    var tableViewDataArr : TableViewDataArray = TableViewDataArray()
    
    var currentSectionOrNil : Int?
    
    var disableScrollSelect : Bool = false
    
    var sectionIndexTitles : [String] = [String]()
    
    func reloadSectionIndexTitles(sectionModels: XYLogBrowseDataSectionModel.ModelArray) {
        
        self.sectionIndexTitles.removeAll()
        
        for sectionModel in sectionModels {
            
            self.sectionIndexTitles.append(sectionModel.title)
        }
    }
    
    lazy var sectionIndexView: SectionIndexView = {
        
        let size = CGSize(width: UIW(30), height: UIW(14))
        
        let view = SectionIndexView.CreateAutolayout(itemSize: size)
        view.itemPreviewMargin = UIW(120)
        weak var weakSelf = self
        view.delegate = weakSelf
        view.dataSource = weakSelf
        
        return view
    }()
}

// MARK: - 数据处理
extension XYLogBrowseViewController {
    
    @objc func clickHeaderInSection(button: UIButton) {
        
        if let currentSection = self.currentSectionOrNil,
            currentSection == button.tag {
            
            self.currentSectionOrNil = nil
            
        }else {
            
            self.currentSectionOrNil = button.tag
        }
        
//        self.reloadTableViewData()
    }
    
    func reloadTableViewData(dataModelOrNil: XYLogBrowseDataModel?) {
        
        // msgs
        self.tableViewDataArr.removeAll()
        
        if let dataModel = dataModelOrNil,
            let sectionDataModels = dataModel.sectionDataModels() {
            
            self.tableViewDataArr.append(contentsOf: sectionDataModels)
            
            self.reloadSectionIndexTitles(sectionModels: sectionDataModels)
        }
        
        self.view.updateConstraintsIfNeeded()
        
        self.tableview.reloadData()
        self.sectionIndexView.reloadData()
    }
}

extension XYLogBrowseViewController: UITableViewDelegate, UITableViewDataSource {
    
    typealias TableViewDataModel = WCDB_XYLogMsg.ModelArray
    typealias TableViewDataArray = XYLogBrowseDataSectionModel.ModelArray
    typealias TableViewCell = XYLogBrowseTableViewCell
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.tableViewDataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionModel = self.tableViewDataArr[section]
        
        return sectionModel.logMsgs.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let model = self.tableViewDataArr.elementByIndex(section) else {
            
            return nil
        }
        
        return model.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.ReuseIdentifier(), for: indexPath) as! TableViewCell
        
        if let sectionModel = self.tableViewDataArr.elementByIndex(indexPath.section),
            let model = sectionModel.logMsgs.elementByIndex(indexPath.row) {
            
            cell.setups(msg: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let sectionModel = self.tableViewDataArr.elementByIndex(indexPath.section),
            let model = sectionModel.logMsgs.elementByIndex(indexPath.row) else { return }
        
        XYLog_AlertTextView.Show(note: model.outMsg)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.disableScrollSelect == false else { return }
        
        if let section = self.tableview.indexPathsForVisibleRows?.first?.section,
            self.sectionIndexView.currentItem != self.sectionIndexView.item(at: section) {
            
            self.sectionIndexView.selectItem(at: section)
        }
    }
}

extension XYLogBrowseViewController : SectionIndexViewDelegate, SectionIndexViewDataSource {
    
    func numberOfItemViews(in sectionIndexView: SectionIndexView) -> Int {
        
        return self.sectionIndexTitles.count
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemViewAt section: Int) -> SectionIndexViewItem {
        
        let itemView = SectionIndexViewItem.newAutoLayout()
        itemView.title = self.sectionIndexTitles[section]
        
        itemView.selectedColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)
        itemView.selectedCornerRadius = 5.0
        
        itemView.titleColor = UIColor.FromXYColor(color: XYColor.CustomColor.main)
        itemView.titleSelectedColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        
        return itemView
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemPreviewFor section: Int) -> SectionIndexViewItemPreview {
        
        let preview = SectionIndexViewItemPreview.init(title: self.sectionIndexTitles[section], type: .empty)
        preview.titleColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        preview.color = UIColor.FromXYColor(color: XYColor.CustomColor.main)
        
        return preview
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheMoved section: Int) {
        sectionIndexView.selectItem(at: section)
        sectionIndexView.showItemPreview(at: section)
        
        self.disableScrollSelect = true
        self.tableview.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
        self.disableScrollSelect = false
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int) {
        sectionIndexView.selectItem(at: section)
        sectionIndexView.showItemPreview(at: section, hideAfter: 0.2)
        
        self.disableScrollSelect = true
        self.tableview.scrollToRow(at: IndexPath.init(row: 0, section: section), at: .top, animated: false)
        self.disableScrollSelect = false
    }
}


extension XYLogBrowseViewController {
    
    @objc func headerViewBtnsHandle(btn: UIButton) {
        
        guard let type = XYLogBrowseTableViewHeaderView.BtnTagType(rawValue: btn.tag) else { return }
        
        switch type {
        case .DeleteAll:
            
            self.reloadTableViewData(dataModelOrNil: nil)
            
            break
            
        case .ScrollToTop:
            
            self.tableview.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
            break
            
        case .ScrollToBottom:
            
            if let sectionModelArr = self.tableViewDataArr.last,
                sectionModelArr.logMsgs.isNotEmpty {
                
                let section = self.tableViewDataArr.count - 1
                let row = sectionModelArr.logMsgs.count - 1
                
                self.tableview.scrollToRow(at: IndexPath(row: row, section: section), at: .bottom, animated: true)
            }
            
            break
            
        }
        
    }
    
}
