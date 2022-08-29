//
//  TPSQLiteTable.swift
//  templates
//
//  Created by Nicklas Düringer on 05.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Represents the structure of a SQLite Table and is used to create the specified table in the database
- Parameter name: Name of the Table
- Parameter columns: Array of objects of TPSQLiteColumn, which defines the columns in the current table
- Parameter check: Optional object of TPSQLiteCheck, which represents a SQLite check constraint
- Parameter foreignKeys: Optional Array of objects of TPSQLiteForeignKey, which represents SQLite foreign keys
# Reference TPSQLiteColumn
# Reference TPSQLiteCheck
# Reference TPSQLiteForeignKey
*/
class TPSQLiteTable {
    
    var name: String
    var columns: [TPSQLiteColumn]
    var check: TPSQLiteCheck?
    var foreignKeys: [TPSQLiteForeignKey]?
    
    
    init(name: String, columns: [TPSQLiteColumn], check: TPSQLiteCheck? = nil, foreignKeys: [TPSQLiteForeignKey]? = nil) {
        self.name = name
        self.columns = columns
        self.check = check
        self.foreignKeys = foreignKeys
    }
    
    func createStatement() -> String {
        var result = ""
        var tableColumns = ""
        for (index, column) in columns.enumerated() {
            if index == columns.endIndex - 1 {
                tableColumns.append(column.getColumnString())
            } else {
                tableColumns.append(column.getColumnString())
                tableColumns.append(",")
            }
        }
        let checkString = check?.getCheckString()
        var foreignKeysString = ""
        
        foreignKeys?.forEach {
            foreignKeysString += $0.getForeignKeyString()
        }
        
        result += "CREATE TABLE IF NOT EXISTS \(name)(\(tableColumns)"
        if let checkString = checkString {
            if !checkString.isEmpty {
                result += ",\(checkString)"
            }
            
            
        }
        if !foreignKeysString.isEmpty {result += ",\(foreignKeysString)"}
        result += ");"
        
        return result
    }
}
