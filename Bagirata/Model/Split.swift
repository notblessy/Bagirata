//
//  Split.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import Foundation
import SwiftUI

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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.qty = try container.decode(Int.self, forKey: .qty)
        self.price = try container.decode(Int.self, forKey: .price)
    }
}

struct OtherItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.amount = try container.decode(Int.self, forKey: .amount)
    }
}

struct ItemSplit: Identifiable, Codable {
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
    
    func friendNames() -> [String] {
        return friends.map { $0.name }
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
}

struct ItemResponse: Codable {
    let message: String
    let success: Bool
    let data: ItemSplit
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.data = try container.decode(ItemSplit.self, forKey: .data)
    }
}
