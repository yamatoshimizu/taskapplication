//
//  Task.swift
//  taskApp
//
//  Created by 清水大和 on 2020/07/09.
//  Copyright © 2020 Yamato Shimizu. All rights reserved.
//

import RealmSwift
class Task: Object{
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var date = Date()
    override static func primaryKey() -> String? {
        return "id"
    }
}
