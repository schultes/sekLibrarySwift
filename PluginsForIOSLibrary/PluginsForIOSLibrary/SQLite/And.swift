//
//  And.swift
//  templates
//
//  Created by Nicklas Düringer on 18.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

internal class And: Statement {
    override init(logic: String) {
        super.init(logic: logic)
    }
    
    override func getOperator() -> String {"AND"}
}
