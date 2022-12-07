//
//  Category.swift
//  ToDoListDemo
//
//  Created by Macbook on 07/12/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
   
}
