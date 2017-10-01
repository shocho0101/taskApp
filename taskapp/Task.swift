//
//  Task.swift
//  taskapp
//
//  Created by 張翔 on 2017/09/26.
//  Copyright © 2017年 sho. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    //管理用ID、プライマリーキー
    dynamic var id = 0
    
    //タイトル
    dynamic var title = ""
    
    //内容
    dynamic var contents = ""
    
    //日時
    dynamic var date = NSDate()
    
    dynamic var category: Category?
    
    //idをプライマリーキーとして設定
    override static func primaryKey() -> String?{
        return "id"
    }
}
