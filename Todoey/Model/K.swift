//
//  K.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/5/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

struct K {
    static let itemsPlistFileName = "Items.plist"
    static let goToItemsSegueIdentifier = "goToItems"
    static let realm: Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    struct TableView {
        static let defaultArrayKey = "TodoListArray"
        static let CategoryCellIdentifier = "CategoryCell"
        static let cellReuseIdentifier = "ToDoItemCell"
    }
}
