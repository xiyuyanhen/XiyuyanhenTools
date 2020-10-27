//
//  XYObjectWithId.swift
//  FangKeBang
//
//  Created by 细雨湮痕 on 2018/10/30.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

import Foundation

class XYObjectWithId: XYObject, NSCopying, XYObjectWithIdProtocol {

    let objId: String

    required init(objId: String) {

        self.objId = objId

        super.init()
    }

    func isValidate() -> Bool {

        return true
    }

    func copy(with zone: NSZone? = nil) -> Any {

        let newObj = XYObjectWithId(objId: self.objId)


        return newObj
    }

    override func isEqual(_ object: Any?) -> Bool {

        guard let otherObj = object as? XYObjectWithId,
            self.objId == otherObj.objId else { return false }

        return true
    }

    override var hash: Int {

        let hash: Int = self.objId.hash

        return hash
    }

    //XYObjectWithIdProtocol
    static func CreateWithAutoId() -> Self {

        let objID = self.CreateIdByClassAndTime()

        let newObj = self.init(objId: objID)

        return newObj
    }
}

protocol XYObjectWithIdProtocol {

    static func CreateWithAutoId() -> Self
}

extension XYObjectWithIdProtocol where Self : XYObject {

    static func CreateIdByClassAndTime() -> String {
        
        return String.CreateIdByTime(className: self.XYClassName)
    }
}
