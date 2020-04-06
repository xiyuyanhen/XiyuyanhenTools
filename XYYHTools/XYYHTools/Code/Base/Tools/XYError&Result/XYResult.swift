//
//  XYResult.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2018/11/10.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

typealias XYResultHandleBlock = (_ result: XYResult< Any?, XYError>) -> Void

typealias XYResultAny = XYResult< Any?, XYError>

public enum XYResult<Value, Error: Swift.Error> {
    
    case Success(Value)
    case Failure(Value)
    case Error(Error)
}

public enum XYNormalResult<Value, Error: Swift.Error> {
    
    case Complete(Value)
    case Failure(Error)
}
