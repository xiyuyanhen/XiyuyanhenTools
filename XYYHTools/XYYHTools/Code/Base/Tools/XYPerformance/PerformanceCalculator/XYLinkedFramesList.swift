//
//  XYLinkedFramesList.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

/// Linked list node. Represents frame timestamp.
internal class XYFrameNode {
    
    // MARK: Public Properties
    
    var next: XYFrameNode?
    weak var previous: XYFrameNode?
    
    private(set) var timestamp: TimeInterval
    
    /// Initializes linked list node with parameters.
    ///
    /// - Parameter timeInterval: Frame timestamp.
    public init(timestamp: TimeInterval) {
        self.timestamp = timestamp
    }
}

// MARK: Class Definition

/// Linked list. Each node represents frame timestamp.
/// The only function is append, which will add a new frame and remove all frames older than a second from the last timestamp.
/// As a result, the number of items in the list will represent the number of frames for the last second.
internal class XYLinkedFramesList {
    
    // MARK: Private Properties
    
    private var head: XYFrameNode?
    private var tail: XYFrameNode?
    
    // MARK: Public Properties
    
    private(set) var count = 0
}

// MARK: Public Methods

internal extension XYLinkedFramesList {
    /// Appends new frame with parameters.
    ///
    /// - Parameter timestamp: New frame timestamp.
    func append(frameWithTimestamp timestamp: TimeInterval) {
        let newNode = XYFrameNode(timestamp: timestamp)
        if let lastNode = self.tail {
            newNode.previous = lastNode
            lastNode.next = newNode
            self.tail = newNode
        } else {
            self.head = newNode
            self.tail = newNode
        }
        
        self.count += 1
        self.removeFrameNodes(olderThanTimestampMoreThanSecond: timestamp)
    }
}

// MARK: Support Methods

private extension XYLinkedFramesList {
    func removeFrameNodes(olderThanTimestampMoreThanSecond timestamp: TimeInterval) {
        while let firstNode = self.head {
            guard timestamp - firstNode.timestamp > 1.0 else {
                break
            }
            
            let nextNode = firstNode.next
            nextNode?.previous = nil
            firstNode.next = nil
            self.head = nextNode
            
            self.count -= 1
        }
    }
}


