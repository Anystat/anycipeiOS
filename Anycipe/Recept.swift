//
//  Recept.swift
//  Anycipe
//
//  Created by Vitaly on 10.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import Foundation

class Recept {
    var recept: String = ""
    var isType = false
    init(recept: String, isType: Bool) {
        self.recept = recept
        self.isType = isType
    }
}
