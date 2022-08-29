//
//  TPSQLiteDataType.swift
//  templates
//
//  Created by Nicklas Düringer on 05.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Enum that represents a SQLite data type

 Can be one of the following:
 - Null, Integer, Real, Text, Blob
*/
enum TPSQLiteDataType: String {
    case Null = "NULL"
    case Integer = "INTEGER"
    case Real = "REAL"
    case Text = "TEXT"
    case Blob = "BLOB"
}
