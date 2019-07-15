//
//  WCDBModel.swift
//  WCDBDemo
//
//  Created by zsm on 2019/7/12.
//  Copyright © 2019 izsm. All rights reserved.
//

import WCDBSwift

struct WCDBModel: TableCodable {
    
    var name: String = ""
    var age: Int = 0
    var sex: String = ""
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WCDBModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case name
        case age
        case sex
    }
}
