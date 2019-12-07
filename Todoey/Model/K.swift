//
//  K.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/5/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct K {
    static let itemsPlistFileName = "Items.plist"
    static let goToItemsSegueIdentifier = "goToItems"
    struct TableView {
        static let defaultArrayKey = "TodoListArray"
        static let CategoryCellIdentifier = "CategoryCell"
        static let cellReuseIdentifier = "ToDoItemCell"
    }
    struct CoreData {
        static let modelName = "DataModel"
        static let entityName = "Item"
    }
}
