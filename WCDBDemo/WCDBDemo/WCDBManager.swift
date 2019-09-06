//
//  WCDBManager.swift
//  WCDBDemo
//
//  Created by izsm on 2019/7/12.
//  Copyright © 2019 izsm. All rights reserved.
//

import WCDBSwift

class WCDBManager: NSObject {
    
    static let share = WCDBManager()
    
    let dataBasePath = NSHomeDirectory() + "/Documents/WCDB.db"
    
    private lazy var database: Database = {
        debugPrint(dataBasePath)
        return Database(withPath: dataBasePath)
    }()
    
    ///创建表
    private func createTable<T: TableCodable>(type: T.Type, table: String) {
        do {
            try database.create(table: table, of: type)
        } catch {
            debugPrint("create table error \(error.localizedDescription)")
        }
    }
    
    /// 保存 只保存一条数据，如果表存在就更新数据
    func save<T: TableCodable>(object: T, table: String) {
        do {
            if try database.isTableExists(table) {
                update(object: object, table: table)
            } else {
                createTable(type: T.self, table: table)
                try database.insert(objects: object, intoTable: table)
            }
        } catch {
            debugPrint("insert object error \(error.localizedDescription)")
        }
    }
    
    func insertOrReplaceObject<T: TableCodable>(object: T, table: String) {
        do {
            createTable(type: T.self, table: table)
            try database.insertOrReplace(objects: object, intoTable: table)
        } catch {
            debugPrint("insert object error \(error.localizedDescription)")
        }
    }
    
    func update<T: TableCodable>(object: T, table: String) {
        do {
            try database.update(table: table, on: T.Properties.all, with: object)
        } catch {
            delete(table: "update object error \(error.localizedDescription)")
        }
    }
    
    func object<T: TableCodable>(type: T.Type, table: String) -> T? {
        do {
            return try database.getObject(on: T.Properties.all, fromTable: table)
        } catch {
            debugPrint("get object error \(error.localizedDescription)")
            return nil
        }
    }
    
    func delete(table: String) {
        do {
            try database.drop(table: table)
        } catch {
            debugPrint("delete table error \(error.localizedDescription)")
        }
    }
    
    func saveData<T: Codable>(object: T, table: String) {
        let transformer = ZMTransformerFactory.forCodable(ofType: T.self)
        do {
            let data = try transformer.toData(object)
            var dataModel = WCDBDataModel()
            dataModel.data = data
            do {
                if try database.isTableExists(table) {
                    update(object: dataModel, table: table)
                } else {
                    createTable(type: WCDBDataModel.self, table: table)
                    try database.insert(objects: dataModel, intoTable: table)
                }
            } catch {
                debugPrint("insert object error \(error.localizedDescription)")
            }
        } catch {
            
        }
    }
    
    func objectData<T: Codable>(type: T.Type, table: String) -> T? {
        guard let dataModel = object(type: WCDBDataModel.self, table: table) else { return nil }
        do {
            let data = dataModel.data
            let transformer = ZMTransformerFactory.forCodable(ofType: T.self)
            return try transformer.fromData(data)
        } catch {
            return nil
        }
    }
}

struct WCDBDataModel: TableCodable {
    var data: Data = Data()
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = WCDBDataModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case data
    }
}

public class ZMTransformer<T> {
    let toData: (T) throws -> Data
    let fromData: (Data) throws -> T
    
    public init(toData: @escaping (T) throws -> Data, fromData: @escaping (Data) throws -> T) {
        self.toData = toData
        self.fromData = fromData
    }
}

public class ZMTransformerFactory {
    
    public static func forCodable<U: Codable>(ofType: U.Type) -> ZMTransformer<U> {
        let toData: (U) throws -> Data = { object in
            let wrapper = ZMTypeWrapper<U>(object: object)
            let encoder = JSONEncoder()
            return try encoder.encode(wrapper)
        }
        
        let fromData: (Data) throws -> U = { data in
            let decoder = JSONDecoder()
            return try decoder.decode(ZMTypeWrapper<U>.self, from: data).object
        }
        
        return ZMTransformer<U>(toData: toData, fromData: fromData)
    }
}

public struct ZMTypeWrapper<T: Codable>: Codable {
    enum CodingKeys: String, CodingKey {
        case object
    }
    
    public let object: T
    
    public init(object: T) {
        self.object = object
    }
}
