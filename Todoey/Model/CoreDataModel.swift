//
//  CoreDataModel.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/8/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import CoreData

struct CDModel {
    //need funcction to load items to be used in both view controllers
    static func loadCoreDataItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), withPredicate predicate: NSPredicate? = nil, forCategory category: Category, forContext context: NSManagedObjectContext) -> [Item] {
        //setting up category predicate
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        do {
            let itemArray = try context.fetch(request)
            return itemArray
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
