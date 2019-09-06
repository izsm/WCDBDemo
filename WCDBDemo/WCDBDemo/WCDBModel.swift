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
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                name: ColumnConstraintBinding(isPrimary: true),
            ]
        }
    }
}

struct DataModel: Codable {
    var name: String = ""
    var age: Int = 0
    var sex: String = ""
    var we: DataWeightModel = DataWeightModel()
}

struct DataWeightModel: Codable {
    var weight: Int = 0
}
