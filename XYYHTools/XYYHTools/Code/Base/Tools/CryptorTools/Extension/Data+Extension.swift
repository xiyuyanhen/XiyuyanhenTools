//
//  Data+Extension.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/11/22.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/40276322/hex-binary-string-conversion-in-swift/40278391#40278391

//extension Data {
//
//    init?(hexEncodedString string: String) {
//
//        let strip = CharacterSet(charactersIn: " <>\n\t")
//        let input = string.unicodeScalars.filter { !strip.contains($0) }.map { $0.utf16 }.joined()
//
//        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
//        // return nil for all other input characters
//        func decodeNibble(u: UInt16) -> UInt8? {
//            switch(u) {
//            case 0x30 ... 0x39:
//                return UInt8(u - 0x30)
//            case 0x41 ... 0x46:
//                return UInt8(u - 0x41 + 10)
//            case 0x61 ... 0x66:
//                return UInt8(u - 0x61 + 10)
//            default:
//                return nil
//            }
//        }
//
//        self.init(capacity: input.count/2)
//        var even = true
//        var byte: UInt8 = 0
//        for c in input {
//            guard let val = decodeNibble(u: c) else { return nil }
//            if even {
//                byte = val << 4
//            } else {
//                byte += val
//                self.append(byte)
//            }
//            even = !even
//        }
//        guard even else { return nil }
//    }
//}
//
//internal extension String {
//
//    var dataFromHexEncoding: Data? {
//
//        return Data(hexEncodedString: self)
//    }
//}

extension Data {
    
    public init(hex: String) {
        
        self.init(bytes: Array<UInt8>(hex: hex))
    }
    
    public var bytes: Array<UInt8> {
        
        return Array(self)
    }
    
    public func toHexString() -> String {
        
        return bytes.toHexString()
    }
}

extension Array {
    
    public init(reserveCapacity: Int) {
        
        self = Array<Element>()
        self.reserveCapacity(reserveCapacity)
    }
    
    var slice: ArraySlice<Element> {
        return self[self.startIndex ..< self.endIndex]
    }
}

extension Array where Element == UInt8 {
    
    public init(hex: String) {
        
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                removeAll()
                return
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }
            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            append(b)
        }
    }
    
    public func toHexString() -> String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}
