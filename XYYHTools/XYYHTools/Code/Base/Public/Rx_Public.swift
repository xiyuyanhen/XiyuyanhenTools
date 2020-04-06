//
//  Rx_Public.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2020/1/15.
//  Copyright © 2020 xiyuyanhen. All rights reserved.
//

import Foundation
import RxSwift

@discardableResult
func RxPublic_AsyncObservable<E>(block: @escaping () -> E) -> Observable<E> {
    
    let newValue = Observable<E>.create({ observer -> Disposable in
        
        XYDispatchQueueType.Public.xyAsync {
            
            observer.onNext(block())
            
            observer.onCompleted()
        }
        
        return Disposables.create()
        
    }).subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.userInitiated)) //后台构建序列
    .observeOn(MainScheduler.instance) //主线程监听并处理序列结果
    
    return newValue
}

