//
//  XYNetworkPagingData.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/7/11.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

protocol XYNetworkPagingDataProtocol : ModelProtocol_Array {
    
    var elementId : String { get }
}

class XYNetworkPagingData<Element: XYNetworkPagingDataProtocol>: XYObject {
    
    /// 数据存储集
    lazy var elementsDic = {() -> [String: Element.ModelArray] in
        
        var dic = [String: Element.ModelArray]()
        
        return dic
    }()
    
    /// 当前请求数据页
    var currentPageIndex : Int = XYNetworkPagingData.FirstPageIndex
    
    /// 每页请求加载的数据量
    var loadPageSize : Int = 10
    
    /// 数据加载状态
    var loadDataStatus : XYNPDLoadStatus = XYNPDLoadStatus.NeedLoadFirst
    
    /// 标记数据
    var tagElementIdOrNil : String? = nil
    
    /// 数据变动信号
    lazy var rxDataChanged: PublishSubject<XYNetworkPagingData> = {
        
        return PublishSubject<XYNetworkPagingData>()
    }()
    
    /// 下拉刷新控件
    weak var refreshHeaderOrNil: MJRefreshHeader?
    
    /// 上拉刷新控件
    weak var refreshFooterOrNil: MJRefreshFooter?
    
    override init() {
        
        super.init()
    }
}

// MARK: - Page-Size
extension XYNetworkPagingData {
    
    /**
     *    @description 设置单页请求数据量
     *
     *    @param    size    页面请求数据量
     *
     *    @param    padSize    如果是iPad设备时的数据量
     *
     */
    func setPageSize(_ size: Int, padSize padSizeOrNil: Int?) {
        
        guard XYDevice.Model() == .iPad,
            let padSize = padSizeOrNil else {
            
            self.loadPageSize = size
            return
        }
        
        // 平板的请求数
        
        self.loadPageSize = padSize
    }
}

// MARK: - Page-Index 页面数索引相关
extension XYNetworkPagingData {
    
    /// 当前数据总页数
    var pageCount : Int {
        
        return self.elementsDic.count
    }
    
    /// 当前页是否为首页 (将被移除)
    var currentPageIsFirst : Bool {
        
        return self.currentPageIndex == XYNetworkPagingData.FirstPageIndex
    }
    
    /// 保存数据的Key值
    private func pageIndexKeyBy(index: Int) -> String {
        
        return "\(index)"
    }
    
    /**
     *    @description 恢复至请求首页的参数与状态
     *
     */
    func setupsForFirstPage() {
        
        self.currentPageIndex = XYNetworkPagingData.FirstPageIndex
        
        self.loadDataStatus = XYNPDLoadStatus.NeedLoadFirst
        
    }
    
    /**
     *    @description 下一页的页面索引值(可以加载更多数据时，即当前页面数+1)
     *
     *    @return   Bool
     */
    var nextPageIndexForLoadMoreDataOrNil: Int? {
        
        guard self.loadDataStatus.xyEqual(types: .CanLoadMore) else { return nil }
        
        return self.currentPageIndex+1
    }
}

// MARK: - 接口请求参数相关
extension XYNetworkPagingData {
    
    /**
     *    @description 指定页用于接口的对应请求值
     *
     *    @param    index    页值
     *
     *    @return   请求值
     */
    private func pageIndexTextForRequest(index: Int) -> String {
        
        /*
        由于现在设计的首页为0，但接口的首页为1，所以要在请求页索引值的基础上再+1使用
        */
        
        return "\(index + 1)"
    }
    
    /**
    *    @description 页面请求数据数量的字符串值
    *
    *    @return   String
    */
    var pageSizeTextForRequest: String {
        
        return "\(self.loadPageSize)"
    }
    
    /**
     *    @description 根据数据加载状态返回对应的请求参数
     *
     *    @param    status    XYNPDLoadStatus
     *
     *    @return   (index: String, size: String)
     */
    func indexAndSizeByLoadStatus(status: XYNPDLoadStatus) -> (index: Int, indexText: String, sizeText: String) {
        
        switch status {
        case .CanLoadMore:
            // 加载下一页的数据参数
            if let nextPageIndex = self.nextPageIndexForLoadMoreDataOrNil {
                
                return (index: nextPageIndex,
                indexText: self.pageIndexTextForRequest(index: nextPageIndex),
                sizeText: self.pageSizeTextForRequest)
            }
            break
            
        case .Update(let index):
            // 更新指定页的数据参数
            return (index: index,
            indexText: self.pageIndexTextForRequest(index: index),
            sizeText: self.pageSizeTextForRequest)

        default: break
        }
        
        // 更新首页的数据参数
        return (index: XYNetworkPagingData.FirstPageIndex,
        indexText: self.pageIndexTextForRequest(index: XYNetworkPagingData.FirstPageIndex),
        sizeText: self.pageSizeTextForRequest)
    }
    
    /**
     *    @description 根据数据加载状态返回对应的请求参数
     *
     *    @param    status    XYNPDLoadStatus
     *
     *    @return   (index: String, size: String)
     */
    func parametersByLoadStatus(status: XYNPDLoadStatus, indexKey: String = "pageIndex", sizeKey: String = "pageSize") -> (parameters: XYNetWorkManage.XYParameters, loadIndex: Int) {
        
        let (index, indexText, sizeText) = self.indexAndSizeByLoadStatus(status: status)
    
        var parameters:XYNetWorkManage.XYParameters = XYNetWorkManage.XYParameters()
        parameters[indexKey] = indexText
        parameters[sizeKey] = sizeText
        
        return (parameters: parameters, loadIndex: index)
    }
}

/// 数据加载状态
enum XYNPDLoadStatus: XYEnumTypeProtocol {
    
    /// 应该加载第一页(首页)
    case NeedLoadFirst
    
    /// 更新指定页数据
    case Update(Int)
    
    /// 可以加载下一页(中间页)
    case CanLoadMore
    
    /// 没有更多数据(最后一页)
    case NoMoreData
}

// MARK: - 插入数据
extension XYNetworkPagingData {
    
    /// 首页索引值
    static private var FirstPageIndex: Int { return 0 }
    
    /// index: 当前页索引 (从0开始) allEelementCount: 当前所有数据的总数
    typealias InsertElementsCompletionBlock = (_ index: Int, _ pagingData: XYNetworkPagingData) -> Void
    
    /**
     *    @description 将数据插入第Index页
     *
     *    @param    index    第index页
     *
     *    @param    elements    数据组
     *
     */
    func insertElementsNew(index: Int, elements elementsOrNil: Element.ModelArray?) {
        
        defer {
            
            self.rxDataChanged.onNext(self)
        }
        
        // 保存当前页
        self.currentPageIndex = index
        
        /// 当前请求页是否为首页
        let isFirstIndex: Bool = (index == XYNetworkPagingData.FirstPageIndex)
        
        // 首页先移除所有数据
        if isFirstIndex {
            
            self.removeAll()
        }
        
        guard let elements = elementsOrNil,
            elements.isNotEmpty else {
                
            // 无有效数据
        
            if isFirstIndex {
                // 当前为首页
                
                // 重置状态: 应该请求首页
                self.loadDataStatus = XYNPDLoadStatus.NeedLoadFirst
                
            }else {
                
                // 重置状态: 没有更多数据
                self.loadDataStatus = XYNPDLoadStatus.NoMoreData
            }
            
            return
        }
        
        // 数据有效
        
        if elements.count < self.loadPageSize {
            // 当前页数据量少于请求数，则视为最后一页
            
            if isFirstIndex {
                
                // 重置状态: 可以更新首页
                self.loadDataStatus = XYNPDLoadStatus.NeedLoadFirst
            }else {
                
                // 重置状态: 可以继续请求数据
                self.loadDataStatus = XYNPDLoadStatus.NoMoreData
            }
            
        }else {
            
            // 重置状态: 可以继续请求数据
            self.loadDataStatus = XYNPDLoadStatus.CanLoadMore
        }
        
        self.elementsDic.xySetObject(elements, forKey: self.pageIndexKeyBy(index: index))
    }
    
    /**
     *    @description 将数据插入第Index页
     *
     *    @param    index    第index页
     *
     *    @param    elements    数据组
     *
     */
    func insertElements(index: Int, elements: Element.ModelArray) {
        
        self.elementsDic[self.pageIndexKeyBy(index: index)] = elements
    }
    
    
}

// MARK: - 移除数据
extension XYNetworkPagingData {
    
    func removeAll() {
        
        self.elementsDic.removeAll()
    }
    
    /**
     *    @description 检查数据Id是否与标记数据Id一致
     *
     *    @param    elementId    检查数据Id
     *
     *    @return   Bool
     */
    func isEqualTagElementId(elementId elementIdOrNil: String?) -> Bool {
        
        if let elementId = elementIdOrNil,
            let tagElementId = self.tagElementIdOrNil,
            elementId == tagElementId {
            
            return true
        }
        
        return false
    }
    
}

// MARK: - 获取数据
extension XYNetworkPagingData {
    
    /**
     *    @description 所有数据
     *
     */
    var allElements : Element.ModelArray {
        
        var allElementArr : Element.ModelArray = Element.ModelArray()
        
        for elementArrKey in self.elementsDic.keys {
            
            guard let elementArr = self.elementsDic[elementArrKey] else { continue }
            
            allElementArr.append(contentsOf: elementArr)
        }
        
        return allElementArr
    }
    
    /**
     *    @description 数据总数
     *
     */
    func allElementCount() -> Int {
        
        var count : Int = 0
        
        for elementArrKey in self.elementsDic.keys {
            
            guard let elementArr = self.elementsDic[elementArrKey] else { continue }
            
            count += elementArr.count
        }
        
        return count
    }
    
    /**
     *    @description 获取第index页的数据
     *
     *    @param    index    第index页
     *
     *    @return   第index页的数据组
     */
    func elementsByPage(index: Int) -> Element.ModelArray? {
        
        guard let elements = self.elementsDic[self.pageIndexKeyBy(index: index)] else {
            
            return nil
        }
        
        return elements
    }
    
    /**
     *    @description 获取第index页的数据数
     *
     *    @param    index    第index页
     *
     *    @return   第index页的数据数
     */
    func elementCountByPage(index: Int) -> Int {
        
        guard let elements = self.elementsByPage(index: index) else { return 0 }
        
        return elements.count
    }
    
    func elementBy(indexPath: IndexPath) -> Element? {
        
        guard let elements = self.elementsByPage(index: indexPath.section),
            let element = elements.elementByIndex(indexPath.row) else { return nil }
        
        return element
    }
    
    func lastElement(_ elementIdOrNil: String?) -> Element? {
        
        guard let elementId = elementIdOrNil else { return nil }
        
        for (index, element) in self.allElements.enumerated() {
            
            guard element.elementId == elementId,
                let result = self.allElements.elementByIndex(index-1) else { continue }
            
            return result
        }
        
        return nil
    }
    
    func lastElement(_ elementNil: Element?) -> Element? {
        
        guard let element = elementNil else { return nil }
        
        return self.lastElement(element.elementId)
    }
    
    var lastElementByTagElementId : Element? {
        
        return self.lastElement(self.tagElementIdOrNil)
    }
    
    func nextElement(_ elementIdOrNil: String?) -> Element? {
        
        guard let elementId = elementIdOrNil else { return nil }
        
        for (index, element) in self.allElements.enumerated() {
            
            guard element.elementId == elementId,
                let result = self.allElements.elementByIndex(index+1) else { continue }
            
            return result
        }
        
        return nil
    }
    
    func nextElement(_ elementNil: Element?) -> Element? {
        
        guard let element = elementNil else { return nil }
        
        return self.nextElement(element.elementId)
    }
    
    var nextElementByTagElementId : Element? {
        
        return self.nextElement(self.tagElementIdOrNil)
    }
    
    /**
     *    @description 是否为最后一页
     *
     *    @param    page    页数
     *
     *    @return   Bool
     */
    func isLastPageBy(_ page: Int) -> Bool {
        
        return page == (self.pageCount - 1)
    }
    
    /**
     *    @description 是否为指定页最后一个数据
     *
     *    @param    page    页数
     *
     *    @param    index    数据索引
     *
     *    @return   Bool
     */
    func isLastElementInPageBy(page: Int, index: Int) -> Bool {
        
        if let modelArr = self.elementsByPage(index: page),
            index == (modelArr.count - 1) {
            /// 最后一个数据

            return true
        }

        return false
    }
    
    /**
     *    @description 是否为所有数据中的最后一个数据
     *
     *    @param    page    页数
     *
     *    @param    index    数据索引
     *
     *    @return   Bool
     */
    func isLastElementInAllBy(page: Int, index: Int) -> Bool {
        
        guard self.isLastPageBy(page),
            self.isLastElementInPageBy(page: page, index: index) else { return false }
        
        return true
    }
    
    /**
     *    @description 是否为所有数据中的最后一个数据
     *
     *    @param    page    页数
     *
     *    @param    index    数据索引
     *
     *    @return   Bool
     */
    func isLastElementInAllBy(indexPath: IndexPath) -> Bool {
    
        return self.isLastElementInAllBy(page: indexPath.section, index: indexPath.row)
    }
    
    /**
     *    @description 根据elementId检索其所在位置
     *
     *    @param    elementId    元素数据Id
     *
     *    @return   IndexPath?
     */
    func indexPathBy(elementId elementIdOrNil: String?) -> (element: Element, indexPath: IndexPath)? {
        
        guard let elementId = elementIdOrNil,
            elementId.isNotEmpty else { return nil }
        
        for pageIndex in 0 ..< self.pageCount {
            
            guard let elements = self.elementsByPage(index: pageIndex) else { continue }
            
            for (index, element) in elements.enumerated() {
                
                guard element.elementId == elementId else { continue }
                
                return (element: element, indexPath: IndexPath(row: index, section: pageIndex))
            }
        }
        
        return nil
    }
    
    /**
    *    @description 根据element检索其所在位置
    *
    *    @param    element    元素数据
    *
    *    @return   IndexPath?
    */
    func indexPathBy(element elementOrNil: Element?) -> IndexPath? {
        
        return self.indexPathBy(elementId: elementOrNil?.elementId)?.indexPath
    }
    
    
 }

// MARK: - MJRefresh
extension XYNetworkPagingData {
    
    /**
     *    @description 停止刷新动画
     *
     */
    func endRefreshing() {
        
        if let refreshHeader = self.refreshHeaderOrNil,
            refreshHeader.state == MJRefreshStateRefreshing {

            refreshHeader.endRefreshing()
            
            // 如果是下拉刷新首页，要将已经没有更多数据状态下的上拉刷新重置
            if let refreshFooter = self.refreshFooterOrNil,
                refreshFooter.state == MJRefreshStateNoMoreData {
                
                refreshFooter.endRefreshing()
            }
        }
        
        if let refreshFooter = self.refreshFooterOrNil,
            refreshFooter.state == MJRefreshStateRefreshing {
            
            if self.loadDataStatus.xyEqual(types: .NoMoreData) {
                
                refreshFooter.endRefreshingWithNoMoreData()
            }else {
                
                refreshFooter.endRefreshing()
            }
        }
    }
    
}


