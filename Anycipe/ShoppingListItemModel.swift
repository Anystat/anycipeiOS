//
//  ShoppingListItemModel.swift
//  Anycipe
//
//  Created by Vitaly on 14.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import Foundation
import RealmSwift

class ShoppingListItemModel: Object {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var isFavorite = false
    dynamic var isCheck = false
    dynamic var quantity = 0.0
    dynamic var unit = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
}
