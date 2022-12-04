//
//  Itom.swift
//  ToDoListDemo
//
//  Created by Macbook on 01/12/22.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
}
