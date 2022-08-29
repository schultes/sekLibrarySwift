//
//  TPSQLiteCheck.swift
//  templates
//
//  Created by Nicklas Düringer on 21.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Represents the structure of a SQLite check constraint and can be used when creating a table in the database
*/
class TPSQLiteCheck {
    private var checkConditions = [Statement]()
    
    func getCheckString() -> String {
        var result = ""
        
        let check = compileCheck()
        
        if (!check.isEmpty) {result += "CHECK \(check)" }
        return result
    }
    
    /**
     Contains the condition for the SQLite check constraint
    - Parameter condition: Object of TPSQLiteCondition
    # Reference TPSQLiteCondition
    */
    func check(condition: TPSQLiteCondition) -> TPSQLiteCheck {
        checkConditions.append(And(logic: condition.toString()))
        return self
    }
    
    /**
     Contains the conditions for the SQLite check constraint
    - Parameter conditions: Objects of TPSQLiteCondition
    # Reference TPSQLiteCondition
    */
    func check(conditions: TPSQLiteCondition...) -> TPSQLiteCheck {
        conditions.forEach {
            checkConditions.append(And(logic: $0.toString()))
        }
        return self
    }
    
    /**
     Contains the condition for the SQLite check constraint
    - Parameter condition: String that represents the condition
    */
    func check(condition: String) -> TPSQLiteCheck {
        checkConditions.append(And(logic: condition))
        return self
    }
    
    /**
     Contains the conditions for the SQLite check constraint
    - Parameter conditions: Strings that represents the condition
    */
    func check(conditions: String...) -> TPSQLiteCheck {
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
        return result
    }
}
