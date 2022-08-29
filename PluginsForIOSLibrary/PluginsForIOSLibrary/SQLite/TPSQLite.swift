//
//  SqlitePlugin.swift
//  PluginsForIOSLibrary
//
//  Created by FMA1 on 24.05.21.
//  Copyright © 2021 FMA1. All rights reserved.
//

import Foundation
import SQLite3

/**
 This class keeps the connection to the local SQLite database
*/
public class TPSQLite {
    
    private let dbPointer: OpaquePointer?
    var comfort = TPSQLiteComfort()
    
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
        comfort.parent = self
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    /**
    Creates a connection to a local SQLite database
    - Parameter dbName: Name of the database
    */
    static func open(dbName: String) throws -> TPSQLite {
        var db: OpaquePointer?
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbName + ".sqlite")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print(fileURL.path)
            print("Successfully opened connection to database \(dbName).")
            return TPSQLite(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw TPSQLiteError.OpenDatabase(message: message)
            } else {
                throw TPSQLiteError
                .OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    internal func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil)
                == SQLITE_OK else {
            throw TPSQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
    
    /**
    Removes one or more tables in the local SQLite database
    - Parameter tableName: One or more table names
    - Parameter callback: Callback function via which an error message can be returned
    */
    func dropTable(tableName: String..., callback: @escaping (_ error: String?) -> Void) {
        for object in tableName {
            do {
                let dropTableStatement = try prepareStatement(sql: "DROP TABLE IF EXISTS \(object)")
                defer { sqlite3_finalize(dropTableStatement) }
                if sqlite3_step(dropTableStatement) == SQLITE_DONE {
                    callback(nil)
                }
            } catch {
                callback(errorMessage)
            }
        }
    }
    
    /**
    Removes one or more rows from a table in the local SQLite database
    - Parameter tableName: Name of the table
    - Parameter condition: Optional condition, which specifies the rows to be removed from the table
    - Parameter selectionArgs: Optional array of strings, which contains the binding arguments for the condition (note the order!)
    - Parameter callback: Callback function via which an error message can be returned
    # Reference TPSQLiteCondition
    */
    func delete(tableName: String, condition: String? = nil, selectionArgs: [String]? = nil, callback: @escaping (_ error: String?) -> Void) {
        do {
            var deleteSQL = ""
            if let condition = condition {
                deleteSQL = "DELETE FROM \(tableName) WHERE \(condition)"
                let deleteStatement = try prepareStatement(sql: deleteSQL)
                defer { sqlite3_finalize(deleteStatement) }
                if let selectionArgs = selectionArgs {
                    for (index, arg) in selectionArgs.enumerated() {
                        sqlite3_bind_text(deleteStatement, Int32(index + 1), (arg as NSString).utf8String, -1, nil)
                    }
                }
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    callback(nil)
                }
            } else {
                deleteSQL = "DELETE FROM \(tableName)"
                let deleteStatement = try prepareStatement(sql: deleteSQL)
                defer { sqlite3_finalize(deleteStatement) }
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    callback(nil)
                }
            }
        } catch {
            callback(errorMessage)
        }
    }
    
    /**
    Inserts one or more objects of a specified model into the table in the local SQLite database
    - Parameter tableName: Name of the table
    - Parameter data: One or more objects of a specified model
    - Parameter callback: Callback function via which an error message can be returned
    # Reference TPSQLiteEntity
    */
    func insert<T:TPSQLiteEntity>(tableName: String, data: T..., callback: @escaping (_ error: String?) -> Void) {
        do {
            for object in data {
                var columns = [String]()
                let columnsMirror = Mirror(reflecting: object)
                for child in columnsMirror.children {
                    if !String(describing: type(of: child.value)).starts(with: "Optional") {
                        columns.append(child.label!)
                    }
                }
                var preparedColumns = ""
                var preparedValues = ""
                for (index, column) in columns.enumerated() {
                    if index == columns.endIndex - 1 {
                        preparedColumns.append(column)
                        preparedValues.append("?")
                    } else {
                        preparedColumns.append(column + ",")
                        preparedValues.append("?,")
                    }
                }
                let insertSql = "INSERT OR REPLACE INTO \(tableName) (\(preparedColumns)) VALUES (\(preparedValues));"
                let insertStatement = try prepareStatement(sql: insertSql)
                defer { sqlite3_finalize(insertStatement) }
                let mirror = Mirror(reflecting: object)
                for case let (label?, value) in mirror.children {
                    if let columnIndex = columns.firstIndex(of: label) {
                        switch type(of: value) {
                        case is String.Type:
                            sqlite3_bind_text(insertStatement, Int32(columnIndex + 1), (value as? NSString)!.utf8String, -1, nil)
                        case is Double.Type:
                            sqlite3_bind_double(insertStatement, Int32(columnIndex + 1), value as! Double)
                        case is Int.Type:
                            sqlite3_bind_int(insertStatement, Int32(columnIndex + 1), Int32(value as! Int))
                        case is Bool.Type:
                            let castValue = value as! Bool
                            sqlite3_bind_int(insertStatement, Int32(columnIndex + 1), Int32(castValue ? 1 : 0))
                        default:
                            sqlite3_bind_text(insertStatement, Int32(columnIndex + 1), (value as? NSString)!.utf8String, -1, nil)
                        }
                    }
                }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else {
                    throw TPSQLiteError.Step(message: errorMessage)
                }
            }
            callback(nil)
        }
        catch {
            callback(errorMessage)
        }
    }
    
    /**
    Updates one or more rows from a table in the local SQLite database
    - Parameter tableName: Name of the table
    - Parameter data: Object of a specified model, that contains the new values of data to be changed
    - Parameter condition: Condition, which specifies the rows to be updated from the table
    - Parameter selectionArgs: Optional array of strings, which contains the binding arguments for the condition (note the order!)
    - Parameter callback: Callback function via which an error message can be returned
    # Reference TPSQLiteEntity
    # Reference TPSQLiteCondition
    */
    func update<T:TPSQLiteEntity>(tableName: String, data: T, condition: String, selectionArgs: [String]? = nil, callback: @escaping (_ error: String?) -> Void) {
        do {
            var preparedColumns = ""
            let columnsMirror = Mirror(reflecting: data)
            for child in columnsMirror.children {
                if !String(describing: type(of: child.value)).starts(with: "Optional") {
                    var value = child.value
                    if type(of: value) is Bool.Type {
                        let castValue = value as! Bool
                        value = castValue ? 1 : 0
                    }
                    if type(of: value) is String.Type {
                        value = "\"\(value)\""
                    }
                    let column = "\(child.label!) = \(value),"
                    preparedColumns.append(column)
                }
            }
            if preparedColumns != "" {
                preparedColumns.removeLast()
            }
            let updateSql = "UPDATE \(tableName) SET \(preparedColumns) WHERE \(condition);"
            print(updateSql)
            let updateStatement = try prepareStatement(sql: updateSql)
            defer { sqlite3_finalize(updateStatement) }
            if let selectionArgs = selectionArgs {
                for (index, arg) in selectionArgs.enumerated() {
                    sqlite3_bind_text(updateStatement, Int32(index + 1), (arg as NSString).utf8String, -1, nil)
                }
            }
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                callback(nil)
            }
        }
        catch {
            callback(errorMessage)
        }
    }
    
    /**
    Queries a result set from the local SQLite database
    - Parameter data: Specified model for the result set
    - Parameter query: String that contains the SQL query
    - Parameter selectionArgs: Optional array of strings, which contains the binding arguments for the condition (note the order!)
    - Parameter callback: Callback function via which an error message and an optional result set of the specified model can be returned
    # Reference TPSQLiteEntity
    */
    func query<T:TPSQLiteEntity>(data: T.Type, query: String, selectionArgs: [String]? = nil, callback: @escaping (_ result: [T]?,_ error: String?) -> Void){
        do {
            var result = [T]()
            print(query)
            let queryStatement = try prepareStatement(sql: query)
            defer { sqlite3_finalize(queryStatement) }
            if let selectionArgs = selectionArgs {
                for (index, arg) in selectionArgs.enumerated() {
                    sqlite3_bind_text(queryStatement, Int32(index + 1), (arg as NSString).utf8String, -1, nil)
                }
            }
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let object = TPSQLiteEntity.createInstance(type: T.self)
                let columnCount = sqlite3_column_count(queryStatement)
                for column in 0..<columnCount {
                    let columnName = String(describing: String(cString: sqlite3_column_name(queryStatement, column)))
                    switch sqlite3_column_type(queryStatement, column) {
                    case SQLITE3_TEXT:
                        let value = String(describing: String(cString: sqlite3_column_text(queryStatement, column)))
                        object.setValue(value, forKey: columnName)
                    case SQLITE_INTEGER:
                        let value = Int(sqlite3_column_int(queryStatement, column))
                        object.setValue(value, forKey: columnName)
                    case SQLITE_FLOAT:
                        let value = Double(sqlite3_column_double(queryStatement, column))
                        object.setValue(value, forKey: columnName)
                    case SQLITE_BLOB:
                        if let dataBlob = sqlite3_column_blob(queryStatement, column){
                            let dataBlobLength = sqlite3_column_bytes(queryStatement, column)
                            let value = Data(bytes: dataBlob, count: Int(dataBlobLength))
                            object.setValue(value, forKey: columnName)
                        }
                    case SQLITE_NULL:
                        let value: String? = nil
                        object.setValue(value, forKey: columnName)
                    default:
                        print("No SQLite data type")
                    }
                }
                result.append(object)
            }
            callback(result, nil)
        }
        catch {
            callback(nil, errorMessage)
        }
    }
    
    /**
     Execute a single SQL statement that is NOT a SELECT/INSERT/UPDATE/DELETE
    - Parameter sql: String which contains the SQL statement
    - Parameter selectionArgs: Optional array of strings, which contains the binding arguments for the condition (note the order!)
    - Parameter callback: Callback function via which an error message can be returned
    */
    func execSQL(sql: String, selectionArgs: [String]? = nil, callback: @escaping (_ error: String?) -> Void){
        do {
            let statement = try prepareStatement(sql: sql)
            defer { sqlite3_finalize(statement) }
            if let selectionArgs = selectionArgs {
                for (index, arg) in selectionArgs.enumerated() {
                    sqlite3_bind_text(statement, Int32(index + 1), (arg as NSString).utf8String, -1, nil)
                }
            }
            if sqlite3_step(statement) == SQLITE_DONE {
                callback(nil)
            }
        } catch {
            callback(errorMessage)
        }
    }
    
    /**
     The class contains additional non-platform-specific comfort functionality
    */
    class TPSQLiteComfort {
        
        weak var parent: TPSQLite! = nil
        
        /**
         [Comfort function]
        Creates one or more tables in the local SQLite database
        - Parameter table: One or more objects of type TPSQLiteTable
        - Parameter callback: Callback function via which an error message can be returned
        # Reference TPSQLiteTable
        */
        func createTable(table: TPSQLiteTable..., callback: @escaping (_ error: String?) -> Void) {
            for object in table {
                do {
                    print(object.createStatement())
                    let createTableStatement = try parent.prepareStatement(sql: object.createStatement())
                    defer{ sqlite3_finalize(createTableStatement) }
                    if sqlite3_step(createTableStatement) == SQLITE_DONE {
                        callback(nil)
                    }
                } catch {
                    callback(parent.errorMessage)
                }
            }
        }
        
        /**
         [Comfort function]
        Removes one or more rows from a table in the local SQLite database
        - Parameter tableName: Name of the table
        - Parameter condition: Optional object of type TPSQLiteCondition, which specifies the rows to be removed from the table
        - Parameter selectionArgs: Optional array of strings, which contains the binding arguments for the condition (note the order!)
        - Parameter callback: Callback function via which an error message can be returned
        # Reference TPSQLiteCondition
        */
        func delete(tableName: String, condition: TPSQLiteCondition? = nil, selectionArgs: [String]? = nil, callback: @escaping (_ error: String?) -> Void) {
            do {
                var deleteSQL = ""
                if let condition = condition {
                    deleteSQL = "DELETE FROM \(tableName) WHERE \(condition.toString())"
                    let deleteStatement = try parent.prepareStatement(sql: deleteSQL)
                    defer { sqlite3_finalize(deleteStatement) }
                    if let selectionArgs = selectionArgs {
                        for (index, arg) in selectionArgs.enumerated() {
                            sqlite3_bind_text(deleteStatement, Int32(index + 1), (arg as NSString).utf8String, -1, nil)
                        }
                    }
                    if sqlite3_step(deleteStatement) == SQLITE_DONE {
                        callback(nil)
                    }
                } else {
                    deleteSQL = "DELETE FROM \(tableName)"
                    let deleteStatement = try parent.prepareStatement(sql: deleteSQL)
                    defer { sqlite3_finalize(deleteStatement) }
                    if sqlite3_step(deleteStatement) == SQLITE_DONE {
                        callback(nil)
                    }
                }
            } catch {
                callback(parent.errorMessage)
            }
        }
        
        /**
         [Comfort function]
        Updates one or more rows from a table in the local SQLite database
        - Parameter tableName: Name of the table
        - Parameter data: Object of a specified model, that contains the new values of data to be changed
        - Parameter condition: Object of type TPSQLiteCondition, which specifies the rows to be updated from the table
        - Parameter selectionArgs: Optional array of strings, which contains the binding arguments for the condition (note the order!)
        - Parameter callback: Callback function via which an error message can be returned
        # Reference TPSQLiteEntity
        # Reference TPSQLiteCondition
        */
        func update<T:TPSQLiteEntity>(tableName: String, data: T, condition: TPSQLiteCondition, selectionArgs: [String]? = nil, callback: @escaping (_ error: String?) -> Void) {
            do {
                var preparedColumns = ""
                let columnsMirror = Mirror(reflecting: data)
                for child in columnsMirror.children {
                    if !String(describing: type(of: child.value)).starts(with: "Optional") {
                        var value = child.value
                        if type(of: value) is Bool.Type {
                            let castValue = value as! Bool
                            value = castValue ? 1 : 0
                        }
                        if type(of: value) is String.Type {
                            value = "\"\(value)\""
                        }
                        let column = "\(child.label!) = \(value),"
                        preparedColumns.append(column)
                    }
                }
                if preparedColumns != "" {
                    preparedColumns.removeLast()
                }
                let updateSql = "UPDATE \(tableName) SET \(preparedColumns) WHERE \(condition.toString());"
                print(updateSql)
                let updateStatement = try parent.prepareStatement(sql: updateSql)
                defer { sqlite3_finalize(updateStatement) }
                if let selectionArgs = selectionArgs {
                    for (index, arg) in selectionArgs.enumerated() {
                        sqlite3_bind_text(updateStatement, Int32(index + 1), (arg as NSString).utf8String, -1, nil)
                    }
                }
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    callback(nil)
                }
            }
            catch {
                callback(parent.errorMessage)
            }
        }
        
        /**
         [Comfort function]
        Queries a result set from the local SQLite database
        - Parameter data: Specified model for the result set
        - Parameter query: Object of type TPSQLiteQuery, that contains the SQL query
        - Parameter selectionArgs: Optional array of strings, which contains the binding arguments for the condition (note the order!)
        - Parameter callback: Callback function via which an error message and an optional result set of the specified model can be returned
        # Reference TPSQLiteEntity
        # Reference TPSQLiteQuery
        */
        func query<T:TPSQLiteEntity>(data: T.Type, query: TPSQLiteQuery, selectionArgs: [String]? = nil, callback: @escaping (_ result: [T]?,_ error: String?) -> Void){
            do {
                var result = [T]()
                print(query)
                let queryStatement = try parent.prepareStatement(sql: query.toSQL())
                defer { sqlite3_finalize(queryStatement) }
                if let selectionArgs = selectionArgs {
                    for (index, arg) in selectionArgs.enumerated() {
                        sqlite3_bind_text(queryStatement, Int32(index + 1), (arg as NSString).utf8String, -1, nil)
                    }
                }
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let object = TPSQLiteEntity.createInstance(type: T.self)
                    let columnCount = sqlite3_column_count(queryStatement)
                    for column in 0..<columnCount {
                        let columnName = String(describing: String(cString: sqlite3_column_name(queryStatement, column)))
                        switch sqlite3_column_type(queryStatement, column) {
                        case SQLITE3_TEXT:
                            let value = String(describing: String(cString: sqlite3_column_text(queryStatement, column)))
                            object.setValue(value, forKey: columnName)
                        case SQLITE_INTEGER:
                            let value = Int(sqlite3_column_int(queryStatement, column))
                            object.setValue(value, forKey: columnName)
                        case SQLITE_FLOAT:
                            let value = Double(sqlite3_column_double(queryStatement, column))
                            object.setValue(value, forKey: columnName)
                        case SQLITE_BLOB:
                            if let dataBlob = sqlite3_column_blob(queryStatement, column){
                                let dataBlobLength = sqlite3_column_bytes(queryStatement, column)
                                let value = Data(bytes: dataBlob, count: Int(dataBlobLength))
                                object.setValue(value, forKey: columnName)
                            }
                        case SQLITE_NULL:
                            let value: String? = nil
                            object.setValue(value, forKey: columnName)
                        default:
                            print("No SQLite data type")
                        }
                    }
                    result.append(object)
                }
                callback(result, nil)
            }
            catch {
                callback(nil, parent.errorMessage)
            }
        }
    }
}



