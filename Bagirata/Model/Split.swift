//
//  Split.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import Foundation
import SwiftUI
import SwiftData

struct AssignedFriend: Identifiable, Codable {
    var id = UUID()
    var friendId = UUID()
    let name: String
    let accentColor: String
    let qty: Int
    let subTotal: Int
    let createdAt: Date
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.friendId = try container.decode(UUID.self, forKey: .friendId)
        self.name = try container.decode(String.self, forKey: .name)
        self.accentColor = try container.decode(String.self, forKey: .accentColor)
        self.qty = try container.decode(Int.self, forKey: .qty)
        self.subTotal = try container.decode(Int.self, forKey: .subTotal)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}

struct AssignedItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let qty: Int
    let price: Int
    var createdAt = Date()
    
    init(name: String, qty: Int, price: Int) {
        self.name = name
        self.qty = qty
        self.price = price
    }
    
    init(id: UUID, name: String, qty: Int, price: Int, createdAt: Date) {
        self.id = id
        self.name = name
        self.qty = qty
        self.price = price
        self.createdAt = createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.qty = try container.decode(Int.self, forKey: .qty)
        self.price = try container.decode(Int.self, forKey: .price)
    }
    
    static func examples() -> [AssignedItem] {
        return [
            AssignedItem(id: UUID(uuidString: "B2391D93-80B3-444E-8B4F-81B09D8BF6AD") ?? UUID(),name: "Onigiri Tuna Mayo", qty: 2, price: 15000, createdAt: Date()),
            AssignedItem(name: "UC1000 Lemon", qty: 2, price: 10000),
            AssignedItem(name: "Double Tape Strong", qty: 3, price: 45000)
        ]
    }
    
    static func example() -> AssignedItem {
        return AssignedItem(id: UUID(uuidString: "B2391D93-80B3-444E-8B4F-81B09D8BF6AD") ?? UUID(), name: "Onigiri Tuna Mayo", qty: 2, price: 15000,  createdAt: Date())
    }
}

struct OtherItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
    
    init(name: String, type: String, amount: Int) {
        self.name = name
        self.type = type
        self.amount = amount
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.amount = try container.decode(Int.self, forKey: .amount)
    }
    
    static func examples() -> [OtherItem] {
        return [
            OtherItem(name: "Discount", type: "deduction", amount: 40000),
            OtherItem(name: "Tax", type: "addition", amount: 13000),
        ]
    }
}

struct SplitItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var friends: [AssignedFriend]
    var items: [AssignedItem]
    var otherPayments: [OtherItem]
    let createdAt: Date
    
    init() {
        self.id = UUID()
        self.name = ""
        self.friends = []
        self.items = []
        self.otherPayments = []
        self.createdAt = Date()
    }
    
    init(id: UUID = UUID(), name: String, friends: [AssignedFriend] = [], items: [AssignedItem] = [], otherPayments: [OtherItem] = [], createdAt: Date) {
        self.id = id
        self.name = name
        self.friends = friends
        self.items = items
        self.otherPayments = otherPayments
        self.createdAt = createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.friends = try container.decodeIfPresent([AssignedFriend].self, forKey: .friends) ?? []
        self.items = try container.decodeIfPresent([AssignedItem].self, forKey: .items) ?? []
        self.otherPayments = try container.decodeIfPresent([OtherItem].self, forKey: .otherPayments) ?? []
        
        let dateString = try container.decode(String.self, forKey: .createdAt)
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        
        self.createdAt = date
    }
    
    mutating func updateItem(_ updatedItem: AssignedItem) {
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem
        }
    }
    
    func toData() -> Split {
        return Split(id: self.id, name: self.name, friends: self.friends, items: self.items, otherPayments: self.otherPayments, createdAt: self.createdAt)
    }
    
    func friendNames() -> [String] {
        return friends.map { $0.name }
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
    
    static func example() -> SplitItem {
        let items = AssignedItem.examples()
        let otherPayments = OtherItem.examples()
        
        return SplitItem(name: "Lawson Time", friends: [], items: items, otherPayments: otherPayments, createdAt: Date())
    }
}

struct ItemResponse: Codable {
    let message: String
    let success: Bool
    let data: SplitItem
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.data = try container.decode(SplitItem.self, forKey: .data)
    }
}

@Model
class Split {
    @Attribute(.unique) var id: UUID
    var name: String
    var friends: [AssignedFriend]
    var items: [AssignedItem]
    var otherPayments: [OtherItem]
    let createdAt: Date
    
    init(id: UUID, name: String, friends: [AssignedFriend], items: [AssignedItem], otherPayments: [OtherItem], createdAt: Date) {
        self.id = id
        self.name = name
        self.friends = friends
        self.items = items
        self.otherPayments = otherPayments
        self.createdAt = createdAt
    }
    
    func toItemSplit() -> SplitItem {
        return SplitItem(id: self.id, name: self.name, friends: self.friends, items: self.items, otherPayments: self.otherPayments, createdAt: self.createdAt)
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
}
