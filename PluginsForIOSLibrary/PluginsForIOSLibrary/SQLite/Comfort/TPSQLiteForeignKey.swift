//
//  TPSQLiteForeignKey.swift
//  templates
//
//  Created by Nicklas Düringer on 21.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Represents the structure of a SQLite foreign key constraint and can be used when creating a table in the database
- Parameter col: String that represents a column in a table
*/
class TPSQLiteForeignKey {
    private var referenceTable = ""
    private var referenceCol = ""
    private var onUpdateAction = ""
    private var onDeleteAction = ""
    private var col: String
    
    init(col: String) {
        self.col = col
    }
    
    func getForeignKeyString() -> String {
        return compileForeignKeys()
    }
    
    /**
     References a table and an associated column
    - Parameter table: Name of the table to be referenced
    - Parameter col: Name of the column of the referenced table
    */
    func reference(table: String, col: String) -> TPSQLiteForeignKey {
        referenceTable = table
        referenceCol = col
        return self
    }
    
    /**
     Specifies how the foreign key constraint behaves whenever the parent key is updated
    - Parameter action: Object of type TPSQLiteForeignKeyConstraintAction, which defines the action that will be performed
    # Reference TPSQLiteForeignKeyConstraintAction
    */
    func onUpdate(action: TPSQLiteForeignKeyConstraintAction) -> TPSQLiteForeignKey {
        onUpdateAction = action.rawValue
        return self
    }
    
    /**
     Specifies how the foreign key constraint behaves whenever the parent key is deleted
     - Parameter action: Object of type TPSQLiteForeignKeyConstraintAction, which defines the action that will be performed
     # Reference TPSQLiteForeignKeyConstraintAction
    */
    func onDelete(action: TPSQLiteForeignKeyConstraintAction) -> TPSQLiteForeignKey {
        onDeleteAction = action.rawValue
        return self
    }
    
    private func compileForeignKeys() -> String {
        var result = "FOREIGN KEY (\(col)) REFERENCES \(referenceTable)(\(referenceCol))"
        if !onUpdateAction.isEmpty {result += " ON UPDATE \(onUpdateAction)"}
        if !onDeleteAction.isEmpty {result += " ON DELETE \(onDeleteAction)"}
        return result
    }
}
