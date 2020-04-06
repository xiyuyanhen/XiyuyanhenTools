//
//  XYSort_Protocol.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/4/25.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

protocol XYSort_Protocol {
    
    var firstLetter : String { get }
}

extension XYSort_Protocol {
    
    fileprivate static func SortByFirstLetter(sortArr: [Self]) -> [[Self]] {
        
        var resultsArr = [[Self]]()
        
        var willSortArr = [Self]()
        willSortArr.append(contentsOf: sortArr)
        
        var sameFirstLetterArr = [Self]()
        var notSameFirstLetterArr = [Self]()
        
        for index in 65 ... 90 {
            
            guard willSortArr.isNotEmpty else { break }
            
            guard let unicode = UnicodeScalar(index) else { continue }
            
            let unicodeString = String(unicode)
            
            for model in willSortArr {
                
                if model.firstLetter == unicodeString {
                    
                    sameFirstLetterArr.append(model)
                    
                }else {
                    
                    notSameFirstLetterArr.append(model)
                }
            }
            
            if sameFirstLetterArr.isNotEmpty {
                
                resultsArr.append(sameFirstLetterArr)
            }
            
            willSortArr = notSameFirstLetterArr
            
            sameFirstLetterArr.removeAll()
            notSameFirstLetterArr.removeAll()
        }
        
        return resultsArr
    }
}

extension Array where Element: XYSort_Protocol {

    var xySortByFirstLetter: [[Element]] {
        
        return Element.SortByFirstLetter(sortArr: self)
    }
}

//extension Array: XYNameSpaceWrappable {}
//
//extension XYNameSpace where Base == Array<XYSort_Protocol> {
//
//    var sortByFirstLetter: [[XYSort_Protocol]] {
//
//        return self.nsBase.xySortByFirstLetter
//    }
//
//}
