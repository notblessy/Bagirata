//
//  Item.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import Foundation

struct Item: Codable, Identifiable {
    var id = UUID()
    var qty: Int
    var price: Int
    var name: String
    
    init(id: UUID = UUID(), qty: Int, price: Int, name: String) {
        self.id = id
        self.qty = qty
        self.price = price
        self.name = name
    }
    
    static func examples() -> [Item] {
        let exampleItems = [
            Item(qty: 2, price: 100000, name: "Product A"),
            Item(qty: 1, price: 250000, name: "Product B"),
            Item(qty: 5, price: 40000, name: "Product C")
        ]
        return exampleItems
    }
}
