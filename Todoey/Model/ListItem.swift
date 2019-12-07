//
//  ToDoItem.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/5/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct ListItem: Codable {
    let title: String
    var done: Bool
    var data: Data? {
        do {
            let data = try JSONEncoder().encode(self)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    init(_ itemText: String, checked: Bool) {
        title = itemText
        done = checked
    }
    init(data: Data?) {
        guard let safeData = data else {
            print("Unable to extract data.")
            fatalError()
        }
        do {
            let decoded = try JSONDecoder().decode(ListItem.self, from: safeData)
            self = decoded
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
    }
}
