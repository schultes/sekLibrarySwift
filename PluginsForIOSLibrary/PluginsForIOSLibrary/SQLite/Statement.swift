//
//  Statement.swift
//  templates
//
//  Created by Nicklas Düringer on 18.06.21.
//  Copyright © 2021 THM. All rights reserved.
//

import Foundation

internal class Statement {
    private var logic: String = ""
    init(logic: String) {
        self.logic = logic
    }
    
    func getStatement() -> String {logic}
    
    func getOperator() -> String {""}
}
