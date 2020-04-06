//
//  PracticeProcess_TimeSchedule.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/9/29.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

//分段处理
class PracticeProcess_TimeSchedule_Queue : XYObject {
    
    let queueId : String
    var name : String
    var items: [PracticeProcessTimeConsumingItemProtocol] = [PracticeProcessTimeConsumingItemProtocol]()
    
    init(queueId: String, name: String, timeConsumingItems items: [PracticeProcessTimeConsumingItemProtocol] = []) {
        
        self.queueId = queueId
        self.name = name
        
        self.items = items
        
        super.init()
    }
    
    func itemBy(index: Int) -> PracticeProcessTimeConsumingItemProtocol? {
        
        guard let item = self.items.elementByIndex(index) else { return nil }
        
        return item
    }

    func itemDuration(index: Int) -> TimeInterval? {
        
        guard let item = self.itemBy(index: index) else { return nil }
            
        if let audioItem = item as? XYRIAudio {
            
            if let duration = audioItem.durationOrNil,
                0.0 < duration {
                
                return duration
            }else {
                
                DebugNote(tip: "currentTimeForCurrentQueue - 无法获取音频时间!")
            }
            
        }else if let videoItem = item as? PracticeProcessTimeConsumingItem_Video {
            
            let duration = AudioOrAVTime(filePath: videoItem.realVideoPath)
            
            if 0.0 < duration {
                
                return duration
            }else {
                
                DebugNote(tip: "currentTimeForCurrentQueue - 无法获取视频时间!")
            }
            
        }else if let timmingItem = item as? PracticeProcessTimeConsumingItem_Timing {
            
            if 0.0 < timmingItem.time {
                
                return timmingItem.time
            }
        }
        
        return nil
    }
    
    /// 在Queue中当前Item前面的时长总和
    func frontTimeForQueue(index: Int) -> TimeInterval {
        
        var result: TimeInterval = 0.0
        
        var row = index - 1
        
        while 0 <= row {
            
            guard let itemDuration = self.itemDuration(index: row) else { continue }
            
            result += itemDuration
            
            row -= 1
        }
        
        return result
    }
    
    var totalTime: TimeInterval {
        
        var result: TimeInterval = 0.0
        
        for (index, _) in self.items.enumerated() {
            
            guard let itemDuration = self.itemDuration(index: index) else { continue }
            
            result += itemDuration
        }
        
        return result
    }
}

extension PracticeProcess_TimeSchedule_Queue {
    
    /// 添加一个Item
    func appendItem(item: PracticeProcessTimeConsumingItemProtocol) {
        
        self.items.append(item)
    }
    
    func removeAllItem() {
        
        self.items.removeAll()
    }
    
}

/// 时间段
class PracticeProcess_TimeSchedule: XYObject {
    
    /// 当前Item的位置
    var currentItemIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    /// 所有queueArr
    var queueArr: PracticeProcess_TimeSchedule_Queue.ModelArray = PracticeProcess_TimeSchedule_Queue.ModelArray()
    
    override init() {
        
        super.init()
    }
}

extension PracticeProcess_TimeSchedule {
    
    /// 添加一个Queue队列
    @discardableResult func appendItem(item: PracticeProcess_TimeSchedule_Queue) -> Bool {
        
        guard item.items.isNotEmpty else { return false }
        
        self.queueArr.append(item)
        
        return true
    }
    
    func removeAllItems() {
        
        self.queueArr.removeAll()
    }
    
    /// currentItemIndexPath 对应的Queue的名称
    var currentQueueNameOrNil: String? {
        
        guard let queue = self.queueArr.elementByIndex(self.currentItemIndexPath.section) else { return nil }
        
        return queue.name
    }
    
    /// 在Queue中当前Item前面的时长与当前item进行时间和
    func currentTimeForCurrentQueue(currentItemTime: TimeInterval) -> TimeInterval {
        
        var result = currentItemTime
        
        if let frontTime = self.frontTimeForCurrentQueueOrNil {
            
            result += frontTime
        }
        
        return result
    }
    
    /// 在Queue中当前Item前面的时长总和
    var frontTimeForCurrentQueueOrNil: TimeInterval? {
        
        guard let queue = self.queueArr.elementByIndex(self.currentItemIndexPath.section) else { return nil }
        
        return queue.frontTimeForQueue(index: self.currentItemIndexPath.row)
    }
    
    /// 当前Queue的剩余时长
    func remainingTimeForCurrentQueue(currentItemTime: TimeInterval) -> (currentTime: TimeInterval, remainingTime: TimeInterval, queueTotalTime: TimeInterval)? {
        
        guard let queue = self.queueArr.elementByIndex(self.currentItemIndexPath.section) else { return nil }
        
        let cTime = self.currentTimeForCurrentQueue(currentItemTime: currentItemTime)
        let totalTime = queue.totalTime
        
        var rTime = totalTime - cTime
        if rTime < 0.0 {
            
            rTime = 0.0
        }
        
        return (currentTime: cTime, remainingTime: rTime, queueTotalTime: totalTime)
    }
    
    /// 当前Queue的第一个Item
    var currentQueueFirstItemOrNil: (index: IndexPath, item: PracticeProcessTimeConsumingItemProtocol)? {
        
        var newIndexPath = self.currentItemIndexPath

        guard let queue = self.queueArr.elementByIndex(newIndexPath.section),
            queue.items.isNotEmpty else { return nil }
        
        newIndexPath.row = 0
        
        return self.itemBy(indexPath: newIndexPath, isSet: true)
    }
    
    /// 上一个Queue的第一个Item
    var lastQueueFirstItemOrNil: (index: IndexPath, item: PracticeProcessTimeConsumingItemProtocol)? {
        
        var newIndexPath = self.currentItemIndexPath
        
        newIndexPath.row = 0
        newIndexPath.section -= 1
        
        guard let queue = self.queueArr.elementByIndex(newIndexPath.section),
            queue.items.isNotEmpty else { return nil }
        
        return self.itemBy(indexPath: newIndexPath, isSet: true)
    }
    
    /// 下一个Queue的第一个ItemItem
    var nextQueueFirstItemOrNil: (index: IndexPath, item: PracticeProcessTimeConsumingItemProtocol)? {
        
        var newIndexPath = self.currentItemIndexPath
        
        newIndexPath.row = 0
        newIndexPath.section += 1
        
        guard let queue = self.queueArr.elementByIndex(newIndexPath.section),
            queue.items.isNotEmpty else { return nil }
        
        return self.itemBy(indexPath: newIndexPath, isSet: true)
    }
    
    /// currentItemIndexPath 对应的Item
    var currentItemOrNil: (index: IndexPath, item: PracticeProcessTimeConsumingItemProtocol)? {
        
        guard let item = self.itemBy(indexPath: self.currentItemIndexPath, isSet: false) else { return nil }
        
        return item
    }
    
    /// 上一个Item
    var lastItemOrNil: (index: IndexPath, item: PracticeProcessTimeConsumingItemProtocol)? {
        
        var newIndexPath = self.currentItemIndexPath
        
        guard newIndexPath.row == 0 else {
            
            // 0 < row 时
            
            newIndexPath.row -= 1
            
            return self.itemBy(indexPath: newIndexPath, isSet: true)
        }
        
        // row == 0 ,则取前一个section的最后一个数据
        
        newIndexPath.section -= 1
        
        guard let queue = self.queueArr.elementByIndex(newIndexPath.section),
            queue.items.isNotEmpty else { return nil }
        
        newIndexPath.row = queue.items.count - 1
        
        return self.itemBy(indexPath: newIndexPath, isSet: true)
        
    }
    
    /// 下一个Item
    var nextItemOrNil: (index: IndexPath, item: PracticeProcessTimeConsumingItemProtocol)? {
        
        var newIndexPath = self.currentItemIndexPath
        
        guard let currentSectionQueue = self.queueArr.elementByIndex(newIndexPath.section),
            newIndexPath.row == (currentSectionQueue.items.count - 1) else {
                
                // row 不是当前sectionQueue的最后一个数据
                
                newIndexPath.row += 1
                
                return self.itemBy(indexPath: newIndexPath, isSet: true)
        }
        
        // 当前Item为此section的最后一个数据
        
        newIndexPath.section += 1
        newIndexPath.row = 0
        
        return self.itemBy(indexPath: newIndexPath, isSet: true)
    }
    
    /// 获取指定位置的Item
    fileprivate func itemBy(indexPath: IndexPath, isSet: Bool = false) -> (index: IndexPath, item: PracticeProcessTimeConsumingItemProtocol)? {
        
        guard let queue = self.queueArr.elementByIndex(indexPath.section),
            let item = queue.itemBy(index: indexPath.row) else { return nil }
        
        if isSet {
            
            self.currentItemIndexPath = indexPath
        }
        
        return (index: indexPath, item: item)
    }
}
