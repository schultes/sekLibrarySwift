//
//  TPSQLiteError.swift
//  templates
//
//  Created by Nicklas Düringer on 06.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

public enum TPSQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}
