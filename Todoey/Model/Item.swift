//
//  ToDoItem.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/5/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct Item: Codable {
    let text: String
    var check: Bool
    init(_ itemText: String, checked: Bool) {
        text = itemText
        check = checked
    }
}
