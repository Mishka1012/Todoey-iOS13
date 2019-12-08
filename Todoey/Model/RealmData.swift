//
//  Data.swift
//  Todoey
//
//  Created by Mikhail Amshei on 12/8/19.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class RealmData: Object {
    //realm properties have to be dynamic
    dynamic var name: String = ""
    dynamic var age: Int = 0
}
