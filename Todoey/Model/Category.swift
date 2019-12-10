//
//  Category.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/10/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}