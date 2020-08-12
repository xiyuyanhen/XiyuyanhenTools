//
//  DebugToolsViewController.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/9/7.
//  Copyright © 2018年 xiyuyanhen. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

protocol DebugToolsViewControllerDelegate {
    
    func selectType(viewController : DebugToolsViewController, type : DebugToolsType) -> Void
}

class DebugToolsViewController : BaseViewController {
    
    func updateTypes() {
        
        self.tableViewDataArr.removeAll()
        
        self.tableViewDataArr.append(contentsOf: self.managerType.typesArr)
        
        self.tableview.reloadData()
    }
    
    let managerType : DebugToolsMainManagerType
    
    var delegateOrNil : DebugToolsViewControllerDelegate?
    
    init(type: DebugToolsMainManagerType) {
        
        self.managerType = type
        
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
    
        self.view.addSubview(tableview);
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
        self.tableview.autoPinEdge(.top, to: .top, of: self.view, withOffset: 0);
        self.tableview.autoPinView(otherView: self.view, edges: .leading, .bottom, .trailing);
    }
    
    lazy var tableview = { () -> BaseTableView in
        
        let tableView = BaseTableView.newAutoLayout()
        tableView.setBackgroundColor(customColor: .xf6f6f6)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, UIH(50), 0)
        tableView.alwaysBounceHorizontal = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.xyRegister(DebugToolsTableViewCell.self);
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    var tableViewDataArr = [[DebugToolsType]]()
    
}

// MARK: - UITableView
extension DebugToolsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let count = self.tableViewDataArr.count
        
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let arr = self.tableViewDataArr[section]
        let count = arr.count
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 16.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.newAutoLayout()
        view.setBackgroundColor(customColor: .clear)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DebugToolsTableViewCell.ReuseIdentifier(), for: indexPath) as! DebugToolsTableViewCell
        
        let section = indexPath.section
        let row = indexPath.row
        
        let arr = self.tableViewDataArr[section]
        let type = arr[row]
        
        cell.setups(type : type)
        
        let isFirstCell = (row == 0)
        let isLastCell = ((arr.count-1) == row)
        
        cell.bottomLine.isHidden = isLastCell
        if let sectionTopLine = cell.sectionTopLine {
            
            sectionTopLine.isHidden = !isFirstCell
        }
        
        if let sectionBottomLine = cell.sectionBottomLine {
            
            sectionBottomLine.isHidden = !isLastCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let delegate = self.delegateOrNil else { return }
        
        let section = indexPath.section
        let row = indexPath.row
        
        let arr = self.tableViewDataArr[section]
        let type = arr[row]
        
        delegate.selectType(viewController: self, type: type)
    }
    
}
