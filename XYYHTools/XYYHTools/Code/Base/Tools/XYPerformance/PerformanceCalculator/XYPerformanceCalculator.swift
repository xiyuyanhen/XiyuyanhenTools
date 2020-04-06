//
//  XYPerformanceCalculator.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/3/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import QuartzCore

/// Memory usage tuple. Contains used and total memory in bytes.
public typealias XYMemoryUsage = (used: UInt64, total: UInt64)

/// Performance report tuple. Contains CPU usage in percentages, FPS and memory usage.
public typealias XYPerformanceReport = (cpuUsage: Double, fps: Int, memoryUsage: XYMemoryUsage)

internal class XYPerformanceCalculator {
    
    // MARK: Structs
    
    private struct Constants {
        static let accumulationTimeInSeconds = 1.0
    }
    
    // MARK: Internal Properties
    
    internal var onReport: ((_ performanceReport: XYPerformanceReport) -> ())?
    
    // MARK: Private Properties
    
    private var displayLink: CADisplayLink!
    private let linkedFramesList = XYLinkedFramesList()
    private var startTimestamp: TimeInterval?
    private var accumulatedInformationIsEnough = false
    
    // MARK: Init Methods & Superclass Overriders
    
    required internal init() {
        self.configureDisplayLink()
    }
}

// MARK: Public Methods

internal extension XYPerformanceCalculator {
    /// Starts performance monitoring.
    func start() {
        self.startTimestamp = Date().timeIntervalSince1970
        self.displayLink?.isPaused = false
    }
    
    /// Pauses performance monitoring.
    func pause() {
        self.displayLink?.isPaused = true
        self.startTimestamp = nil
        self.accumulatedInformationIsEnough = false
    }
}

// MARK: Timer Actions

private extension XYPerformanceCalculator {
    @objc func displayLinkAction(displayLink: CADisplayLink) {
        self.linkedFramesList.append(frameWithTimestamp: displayLink.timestamp)
        self.takePerformanceEvidence()
    }
}

// MARK: Monitoring

private extension XYPerformanceCalculator {
    
    func takePerformanceEvidence() {
        
        if self.accumulatedInformationIsEnough {
            
//            let cpuUsage = self.cpuUsage()
//            let fps = self.linkedFramesList.count
//            let memoryUsage = self.memoryUsage()
            
            self.onReport?(self.currentReport)
            
        } else if let start = self.startTimestamp, Date().timeIntervalSince1970 - start >= Constants.accumulationTimeInSeconds {
            
            self.accumulatedInformationIsEnough = true
        }
    }
    
    func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                guard infoResult == KERN_SUCCESS else {
                    break
                }
                
                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }
    
    func memoryUsage() -> XYMemoryUsage {
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.resident_size)
        }
        
        let total = ProcessInfo.processInfo.physicalMemory
        return (used, total)
    }
}

// MARK: Configurations

private extension XYPerformanceCalculator {
    func configureDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(XYPerformanceCalculator.displayLinkAction(displayLink:)))
        self.displayLink.isPaused = true
        self.displayLink?.add(to: .current, forMode: .common)
    }
}

// MARK: Support Methods

extension XYPerformanceCalculator {
    
    var currentReport : XYPerformanceReport {
        
        let report = (cpuUsage: self.cpuUsage(),
                      fps: self.linkedFramesList.count,
                      memoryUsage: self.memoryUsage())
        
        return report
    }
    
    var memoryUsagePercent : Float {
        
        return Float(self.memoryUsage().used)/Float(self.memoryUsage().total)
    }
    
    var reportText : String {
        
        let text : String = "CPU使用率: \(self.cpuUsage().xyDecimalLength(0))%\n内存使用率: \(self.memoryUsagePercent.xyDecimalLength(0))%\nUsedCount: \(self.memoryUsage().used)\nTotalCount: \(self.memoryUsage().total)"
        
        return text
    }
    
}

