//
//  Category.swift
//  taskapp
//
//  Created by 張翔 on 2017/09/30.
//  Copyright © 2017年 sho. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    dynamic var id = 0
    
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
