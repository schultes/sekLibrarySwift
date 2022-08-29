//
//  TPSQLiteForeignKeyConstraintAction.swift
//  templates
//
//  Created by Nicklas Düringer on 21.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

/**
 Enum that represents a SQLite foreign key constraint action

 Can be one of the following:
 - SetNull, SetDefault, Restrict, NoAction, Cascade
*/
enum TPSQLiteForeignKeyConstraintAction: String {
    case SetNull = "SET NULL"
    case SetDefault = "SET DEFAULT"
    case Restrict = "RESTRICT"
    case NoAction = "NO ACTION"
    case Cascade = "CASCADE"

}
