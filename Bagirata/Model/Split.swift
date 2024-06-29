//
//  Split.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import Foundation
import SwiftUI

struct AssignedFriend: Identifiable {
    var id = UUID()
    var friendId = UUID()
    let name: String
    let accentColor: Color
    let qty: Int
    let subTotal: Int
    let createdAt: Date
    
    init(friendId: UUID = UUID(), name: String, accentColor: Color, qty: Int, subTotal: Int, createdAt: Date) {
        self.friendId = friendId
        self.name = name
        self.accentColor = accentColor
        self.qty = qty
        self.subTotal = subTotal
        self.createdAt = createdAt
    }
}

struct ItemSplit: Identifiable {
    let id: UUID
    let qty: Int
    let price: Int
    let name: String
    let friends: [AssignedFriend]
    let createdAt: Date
    
    init(id: UUID, qty: Int, price: Int, name: String, friends: [AssignedFriend], createdAt: Date) {
        self.id = id
        self.qty = qty
        self.price = price
        self.name = name
        self.friends = friends
        self.createdAt = createdAt
    }
    
    static func createExamples() -> [ItemSplit] {
        let friend1 = AssignedFriend(name: "Alice", accentColor: colorGen(), qty: 2, subTotal: 20, createdAt: Date())
        let friend2 = AssignedFriend(name: "Bob", accentColor: colorGen(), qty: 1, subTotal: 10, createdAt: Date())
        let friend3 = AssignedFriend(name: "Charlie", accentColor: colorGen(), qty: 3, subTotal: 30, createdAt: Date())
        
        let itemSplit1 = ItemSplit(id: UUID(), qty: 2, price: 15, name: "Indomaret", friends: [friend1, friend2], createdAt: Date())
        let itemSplit2 = ItemSplit(id: UUID(), qty: 1, price: 20, name: "WFC Bareng", friends: [friend3], createdAt: Date())
        let itemSplit3 = ItemSplit(id: UUID(), qty: 3, price: 10, name: "WFC jco", friends: [friend1, friend3], createdAt: Date())
        let itemSplit4 = ItemSplit(id: UUID(), qty: 4, price: 25, name: "Nongki", friends: [friend2], createdAt: Date())
        let itemSplit5 = ItemSplit(id: UUID(), qty: 2, price: 30, name: "Nongki jco", friends: [friend1, friend2, friend3], createdAt: Date())
        let itemSplit6 = ItemSplit(id: UUID(), qty: 5, price: 5, name: "Fun times", friends: [], createdAt: Date())
        
        return [itemSplit1, itemSplit2, itemSplit3, itemSplit4, itemSplit5, itemSplit6]
    }
    
    func friendNames() -> [String] {
        return friends.map { $0.name }
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
}
