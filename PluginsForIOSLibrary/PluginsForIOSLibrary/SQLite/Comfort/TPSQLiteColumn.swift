//
//  TPSQLiteColumn.swift
//  templates
//
//  Created by Nicklas Düringer on 05.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Represents the structure of a SQLite column and is used to create the specified table in the database
- Parameter name: Name of the column
- Parameter dataType: Object of TPSQLiteDataType, which represents the data type of the column
# Reference TPSQLiteDataType
*/
class TPSQLiteColumn {
    let name: String
    let dataType: TPSQLiteDataType
    private var _primaryKey = false
    private var _notNull = false
    private var _autoincrement = false
    private var _unique = false
    private var checkConditions = [Statement]()
    
    
    
    func getColumnString() -> String {
        var result = ""
        let check = compileCheck()
        result += "\(name) \(dataType.rawValue)"
        if _primaryKey {result += " PRIMARY KEY"}
        if _notNull {result += " NOT NULL"}
        if _unique {result += " UNIQUE"}
        if _autoincrement {result += " AUTOINCREMENT"}
        if !check.isEmpty {result += " CHECK (\(check))"}
        return result
    }
    
    init(name: String, dataType: TPSQLiteDataType) {
        self.name = name
        self.dataType = dataType
    }
    
    /**
     Marks a column as primary key
    */
    func primaryKey() -> TPSQLiteColumn {
        _primaryKey = true
        return self
    }
    
    /**
     Marks a column to be not null
    */
    func notNull() -> TPSQLiteColumn {
        _notNull = true
        return self
    }
    
    /**
     Marks a column to be auto incremented
    */
    func autoincrement() -> TPSQLiteColumn {
        _autoincrement = true
        return self
    }
    
    /**
     Marks a column to be unique
    */
    func unique() -> TPSQLiteColumn {
        _unique = true
        return self
    }
    
    /**
     Contains the condition for a SQLite check constraint
    - Parameter condition: Object of TPSQLiteCondition
    # Reference TPSQLiteCondition
    */
    func check(condition: TPSQLiteCondition) -> TPSQLiteColumn {
        checkConditions.append(And(logic: condition.toString()))
        return self
    }
    
    /**
     Contains the conditions for a SQLite check constraint
    - Parameter conditions: Objects of TPSQLiteCondition
    # Reference TPSQLiteCondition
    */
    func check(conditions: TPSQLiteCondition...) -> TPSQLiteColumn {
        conditions.forEach {
            checkConditions.append(And(logic: $0.toString()))
        }
        return self
    }
    
    /**
     Contains the condition for a SQLite check constraint
    - Parameter condition: String that represents the condition
    */
    func check(condition: String) -> TPSQLiteColumn {
        checkConditions.append(And(logic: condition))
        return self
    }
    
    /**
     Contains the conditions for a SQLite check constraint
    - Parameter conditions: Strings that represents the condition
    */
    func check(conditions: String...) -> TPSQLiteColumn {
        conditions.forEach {
            checkConditions.append(And(logic: $0))
        }
        return self
    }
    
    private func compileCheck() -> String {
        var result = ""
        checkConditions.forEach {
            result += " \($0.getStatement()) \($0.getOperator())"
        }
        if result != "" {
            let start = result.firstIndex(of: result.first!)
            let end = result.index(result.endIndex, offsetBy: -3)
            let range = start!..<end
            let substring = result[range]
            result = String(substring).trimmingCharacters(in: .whitespaces)
        }
        return  result
    }
}
