//
//  TPSQLiteCondition.swift
//  templates
//
//  Created by Nicklas Düringer on 05.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Represents a condition. It requires 1-3 expressions
- Parameter left: Operand on the left side of the condition
- Parameter center: Operator or entire condition
- Parameter right: Operand on the right side of the condition
*/
class TPSQLiteCondition {
    var left: String = ""
    var center: String = ""
    var right: String = ""
    
    init(left: String, center: String, right: String) {
        self.left = left
        self.center = center
        self.right = right
    }
    
    init(left: String, right: String) {
        self.left = left
        self.right = right
    }
    
    init(center: String) {
        self.center = center
    }
    
    /**
     Returns a string representation of the condition
     - Returns: String
    */
    func toString() -> String {
        return "\(left) \(center) \(right)"
    }
    
    /**
     Links the condition on which the function was executed and the given condition with a logical AND
    - Parameter value: Object of type TPSQLiteCondtion
    - Returns: Object of type TPSQLiteCondtion
    */
    func and(value: TPSQLiteCondition) -> TPSQLiteCondition {
        return TPSQLiteCondition(left: self.toString(), center: " AND ", right: value.toString())
    }
    
    /**
     Links the condition on which the function was executed and the given condition with a logical OR
    - Parameter value: Object of type TPSQLiteCondtion
    - Returns: Object of type TPSQLiteCondtion
    */
    func or(value: TPSQLiteCondition) -> TPSQLiteCondition {
        return TPSQLiteCondition(left: self.toString(), center: " OR ", right: value.toString())
    }
    
    /**
     Checks if the value of the condition on which the function was executed is equal to the given value
    - Parameter value: String to be compared with the value of the given condition (we recommend to set '?' as value)
    - Returns: Object of type TPSQLiteCondtion
    */
    func eq(value: String) -> TPSQLiteCondition {
        return TPSQLiteOperator.eq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is equal to the given value
    - Parameter value: Integer to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func eq(value: Int) -> TPSQLiteCondition {
        return TPSQLiteOperator.eq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is equal to the given value
    - Parameter value: Double to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func eq(value: Double) -> TPSQLiteCondition {
        return TPSQLiteOperator.eq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is not equal to the given value
    - Parameter value: String to be compared with the value of the given condition (we recommend to set '?' as value)
    - Returns: Object of type TPSQLiteCondtion
    */
    func neq(value: String) -> TPSQLiteCondition {
        return TPSQLiteOperator.neq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is not equal to the given value
    - Parameter value: Integer to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func neq(value: Int) -> TPSQLiteCondition {
        return TPSQLiteOperator.neq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is not equal to the given value
    - Parameter value: Double to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func neq(value: Double) -> TPSQLiteCondition {
        return TPSQLiteOperator.neq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is greater than the given value
    - Parameter value: String to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func greater(value: String) -> TPSQLiteCondition {
        return TPSQLiteOperator.greater(col: self.toString(), col2: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is greater than or equal to the given value
    - Parameter value: String to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func greaterEq(value: String) -> TPSQLiteCondition {
        return TPSQLiteOperator.greaterEq(col: self.toString(), col2: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is less than the given value
    - Parameter value: String to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func less(value: String) -> TPSQLiteCondition {
        return TPSQLiteOperator.less(col: self.toString(), col2: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is less than or equal to the given value
    - Parameter value: String to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func lessEq(value: String) -> TPSQLiteCondition {
        return TPSQLiteOperator.lessEq(col: self.toString(), col2: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is greater than the given value
    - Parameter value: Integer to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func greater(value: Int) -> TPSQLiteCondition {
        return TPSQLiteOperator.greater(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is greater than or equal to the given value
    - Parameter value: Integer to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func greaterEq(value: Int) -> TPSQLiteCondition {
        return TPSQLiteOperator.greaterEq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is less than the given value
    - Parameter value: Integer to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func less(value: Int) -> TPSQLiteCondition {
        return TPSQLiteOperator.less(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is less than or equal to the given value
    - Parameter value: Integer to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func lessEq(value: Int) -> TPSQLiteCondition {
        return TPSQLiteOperator.lessEq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is greater than the given value
    - Parameter value: Double to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func greater(value: Double) -> TPSQLiteCondition {
        return TPSQLiteOperator.greater(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is greater than or equal to the given value
    - Parameter value: Double to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func greaterEq(value: Double) -> TPSQLiteCondition {
        return TPSQLiteOperator.greaterEq(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is less than the given value
    - Parameter value: Double to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func less(value: Double) -> TPSQLiteCondition {
        return TPSQLiteOperator.less(col: self.toString(), value: value)
    }
    
    /**
     Checks if the value of the condition on which the function was executed is less than or equal to the given value
    - Parameter value: Double to be compared with the value of the given condition
    - Returns: Object of type TPSQLiteCondtion
    */
    func lessEq(value: Double) -> TPSQLiteCondition {
        return TPSQLiteOperator.lessEq(col: self.toString(), value: value)
    }
}
