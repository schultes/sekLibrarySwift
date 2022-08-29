//
//  Sort.swift
//  templates
//
//  Created by Nicklas Düringer on 18.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Holds the column for the ORDER BY clause
*/
class TPSQLiteSort {
    var col: String
    var direction: String
    
    private init(col: String, direction: String = "ASC") {
        self.col = col
        self.direction = direction
    }
    
    /**
     Holds the column for the ORDER BY clause in ascending order
    - Parameter col: Name of the column
    - Returns: TPSQLiteSort
    */
    static func asc(col: String) -> TPSQLiteSort {
        return TPSQLiteSort(col: col)
    }
    
    /**
     Holds the column for the ORDER BY clause in descending order
    - Parameter col: Name of the column
    - Returns: TPSQLiteSort
    */
    static func desc(col: String) -> TPSQLiteSort {
        return TPSQLiteSort(col: col, direction: "DESC")
    }
}
