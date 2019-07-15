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
            debugPrint("delete object error \(error.localizedDescription)")
        }
    }
}
