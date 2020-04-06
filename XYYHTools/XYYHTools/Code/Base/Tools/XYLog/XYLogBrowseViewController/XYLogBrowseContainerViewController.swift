//
//  XYLogBrowseContainerViewController.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/8/9.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

extension XYLogBrowseContainerViewController {
    
    @objc func clickMore(btn:BaseButton){
        
        let alertView = UIAlertController(title: "更多操作", message: "", preferredStyle: .alert)
        
        let comfirmAction = UIAlertAction(title: "清除所有记录", style: .default) { [weak self] (action) in
            
            guard let weakSelf = self else { return }
            
//            WCDB_XYLogMsg.DeleteAll(completionBlock: nil)
            
            if let pageView = weakSelf.pageViewOrNil {
                
                pageView.removeFromSuperview()
                pageView.removeByDeinit()
            }
            
            weakSelf.pageViewOrNil = weakSelf.newPageView(logMsgArrFromDBOrNil: [])
        }
        alertView.addAction(comfirmAction)
        
        let filterAction = UIAlertAction(title: "筛选", style: .default) { [weak self] (action) in
            
            guard let weakSelf = self else { return }
            
            weakSelf.filter()
        }
        alertView.addAction(filterAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        alertView.addAction(cancelAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func filter() {
        
        let alertView = UIAlertController(title: "筛选", message: nil, preferredStyle: .alert)
        
        alertView.addTextField {[weak self] (textfield:UITextField) in
            
            textfield.placeholder = "筛选内容"
            textfield.tag = 31
            
            if let weakSelf = self {
                
                textfield.text = weakSelf.filterTextOrNil
            }
        }
        
        let comfirmAction = UIAlertAction(title: "筛选", style: .default) {[weak self] (alertAction) in
            
            guard let textField = alertView.textFields?.first else { return }
            
            self?.reloadBrowseDataByFilter(filterText: textField.text)
        }
        alertView.addAction(comfirmAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (alertAction) in
            
        }
        alertView.addAction(cancelAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
}

class XYLogBrowseContainerViewController : BaseViewController {
    
    static let Title : String = "日志管理"
    
    override func initProperty() {
        super.initProperty()
        
        self.title = XYLogBrowseContainerViewController.Title
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    deinit {
        
        self.pageViewOrNil?.removeByDeinit()
    }
    
    override func changeCommondBackButtonItem() {
        
        let backButtonItem = BaseBarButtonItem(type: .Back, target: self, sel: #selector(self.popHandle(btn:)))
        self.navigationItem.backBarButtonItem = backButtonItem
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        self.navigationItem.rightBarButtonItem = BaseBarButtonItem(public_Title: "更多", target: self, sel: #selector(self.clickMore(btn:)))
        
        self.navigationItem.hidesBackButton = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewOrNil = self.newPageView(logMsgArrFromDBOrNil: self.logMsgArrFromDB)
        
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
    
    private lazy var layout: LTLayout = {
        
        let layout = LTLayout()
        
        layout.titleViewBgColor = UIColor.FromXYColor(color: XYColor.CustomColor.white)
        layout.titleColor = UIColor.FromXYColor(color: XYColor.CustomColor.x333333)
        layout.titleSelectColor = XYColor(argb: XYColor.CustomColor.main.argb).uicolor
        layout.titleFont = XYFont.Font(size: 15)
        layout.titleMargin = UIW(15)
        layout.bottomLineColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
        
        layout.isAverage = true
        layout.isNeedScale = false
        layout.showsHorizontalScrollIndicator = false
        
        return layout
    }()
    
    private var pageViewOrNil : LTPageView?
    
    lazy var logMsgsDataArr: [XYLogBrowseDataModel] = {
        
        return [XYLogBrowseDataModel]()
    }()
    
    var logMsgsDataTitles: [String] {
        
        var titleArr = [String]()
    
        for logMsgsData in self.logMsgsDataArr {
            
            titleArr.append(logMsgsData.dateText)
        }
        
        return titleArr
    }
    
    var filterTextOrNil: String? = nil
}

// MARK: - Data
extension XYLogBrowseContainerViewController {
    
    private var logMsgArrFromDB : WCDB_XYLogMsg.ModelArray? {
        
        return nil
    }
    
    func reloadData(logMsgArrFromDBOrNil : WCDB_XYLogMsg.ModelArray?) {
        
        defer {
            
            //reload
        }
        
        guard var logMsgArr = logMsgArrFromDBOrNil else { return }
        
        self.logMsgsDataArr.removeAll()
        
        let cal = Calendar.current
        
        let nowDate = Date()
    
        var components = cal.dateComponents([.day, .hour, .minute, .second], from: nowDate)
        
        components.day = 0
        if let hour = components.hour {

            components.hour = -hour
        }
        if let minute = components.minute {

            components.minute = -minute
        }
        if let second = components.second {

            components.second = -second
        }
        
        while logMsgArr.isNotEmpty {
            
            if let earlyDate = cal.date(byAdding: components, to: nowDate) {
                
                let earlyDateInterval = earlyDate.timeIntervalSince1970
                
                let (filters, others) = logMsgArr.filter { (msg) -> Bool in
                    
                    return earlyDateInterval <= msg.dateSince1970
                }
                
                if filters.isNotEmpty {
                    
                    let earlyText = earlyDate.dateString(cFormatter: .Custom_H)
                    
                    let earlyData = XYLogBrowseDataModel(dateText: earlyText, minDate: earlyDate, msgs: filters)
                    
                    self.logMsgsDataArr.insert(earlyData, at: 0)
                }
                
                logMsgArr = others
            }
            
            if let day = components.day {
                
                components.day = day - 1
            }else {
                
                components.day = -1
            }
        }
        
    }
    
    
}

extension XYLogBrowseContainerViewController {
    
    private func newPageView(logMsgArrFromDBOrNil : WCDB_XYLogMsg.ModelArray?) -> LTPageView? {
        
        self.reloadData(logMsgArrFromDBOrNil: logMsgArrFromDBOrNil)
        
        var browseArr = [BaseViewController]()
        
        for logMsgsData in self.logMsgsDataArr {
            
            let browseVC = XYLogBrowseViewController(sourceDataModel: logMsgsData)

            browseArr.append(browseVC)
        }
        
        guard browseArr.isNotEmpty else { return nil }
        
        let height = ScreenHeight() - (StatusBarHeight() + XYUIAdjustment.Share().navigationBarHeight + SafeAreaBottomHeight())
        
        let pageView = LTPageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth(), height: height),
                                  currentViewController: self,
                                  viewControllers: browseArr,
                                  titles: self.logMsgsDataTitles,
                                  layout: self.layout)
        
        pageView.didSelectIndexBlock = { (pView, index) in
            
            guard let viewController = pView.showedViewControllers.elementByIndex(index) as? XYLogBrowseViewController else { return }
            
            viewController.tableview.reloadData()
        }
        
        self.view.addSubview(pageView)
        
        return pageView
    }
    
    func reloadBrowseDataByFilter(filterText textOrNil: String?) {
        
        self.filterTextOrNil = textOrNil
        
        guard let pageView = self.pageViewOrNil else { return }
            
        for viewController in pageView.showedViewControllers {
            
            guard let browseVC = viewController as? XYLogBrowseViewController else { continue }
            
            browseVC.sourceDataModel.filterTextOrNil = textOrNil
            
            browseVC.reloadTableViewData(dataModelOrNil: browseVC.sourceDataModel)
        }
    }
}

// MARK: - XYLogBrowseDataModel
class XYLogBrowseDataModel: XYObject {
    
    let dateText: String
    let minDate: Date
    
    var filterTextOrNil: String? = nil
    
    var logMsgs: WCDB_XYLogMsg.ModelArray = WCDB_XYLogMsg.ModelArray()
    
    required init(dateText: String, minDate: Date, msgs: WCDB_XYLogMsg.ModelArray = []) {
        
        self.dateText = dateText
        self.minDate = minDate
        
        if msgs.isNotEmpty {
            
            self.logMsgs.append(contentsOf: msgs)
        }
        
        super.init()
    }
    
    func sectionDataModels() -> XYLogBrowseDataSectionModel.ModelArray? {
        
        guard self.logMsgs.isNotEmpty else { return nil }
        
        var result: XYLogBrowseDataSectionModel.ModelArray = XYLogBrowseDataSectionModel.ModelArray()
        
        /// 时间间隔
        let minuteSpacing: Int = 30
        
        var components = DateComponents()
        components.minute = minuteSpacing
        
        var logMsgArr = self.logMsgs
        
        let (filters, _) = logMsgArr.filter {[weak self] (msg) -> Bool in
            
            if let filterText = self?.filterTextOrNil,
                filterText.isNotEmpty {
                
                let outMsg = msg.outMsg.trimmingCharacters(in: ["\n", " "])
                
                // 若不包含筛选字符串，则过滤
                if outMsg.contains(filterText) == false {
                    
                    return false
                }
            }
            
            return true
        }
        
        logMsgArr = filters
        
        while logMsgArr.isNotEmpty {
            
            if let nextMinutesDate = Calendar.current.date(byAdding: components, to: self.minDate) {
                
                let nextMinutesDateInterval = nextMinutesDate.timeIntervalSince1970
                
                let (filters, others) = logMsgArr.filter { (msg) -> Bool in
                    
                    return msg.dateSince1970 <= nextMinutesDateInterval
                }
                
                if filters.isNotEmpty {
                    
                    let nextMinutesDateText = nextMinutesDate.dateString(cFormatter: .Time)
                    
                    let sectionModel = XYLogBrowseDataSectionModel(title: nextMinutesDateText, msgs: filters)
                    
                    result.append(sectionModel)
                }
                
                logMsgArr = others
            }
            
            //        components.day = -1
            if let minute = components.minute {
                
                components.minute = minute + minuteSpacing
            }else {
                
                components.minute = minuteSpacing
            }
        }
        
        guard result.isNotEmpty else { return nil }
        
        return result
    }
}
