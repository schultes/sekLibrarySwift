//
//  TPSQLiteEntity.swift
//  templates
//
//  Created by Nicklas Düringer on 06.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

public protocol Initializable {
    init()
}

/**
 Class that represents a SQLite Entity. Your indivdual models must inherit from this class.
*/
public class TPSQLiteEntity: NSObject, Initializable {
    override required public init() {}
    
    static func createInstance<T>(type:T.Type) -> T where T:Initializable {
        return type.init()
    }
}
