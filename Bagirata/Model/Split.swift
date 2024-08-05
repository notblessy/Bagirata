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
    var friendId: UUID
    let name: String
    let me: Bool
    let accentColor: String
    var qty: Double
    var subTotal: Double
    let createdAt: Date
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.friendId = try container.decode(UUID.self, forKey: .friendId)
        self.name = try container.decode(String.self, forKey: .name)
        self.me = try container.decodeIfPresent(Bool.self, forKey: .me) ?? false
        self.accentColor = try container.decode(String.self, forKey: .accentColor)
        self.qty = try container.decode(Double.self, forKey: .qty)
        self.subTotal = try container.decode(Double.self, forKey: .subTotal)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    init(friendId: UUID, name: String, me: Bool, accentColor: String, qty: Double, subTotal: Double) {
        self.id = UUID()
        self.friendId = friendId
        self.name = name
        self.me = me
        self.accentColor = accentColor
        self.qty = qty
        self.subTotal = subTotal
        self.createdAt = Date()
    }
    
    func toData() -> Friend {
        return Friend(id: friendId, name: name, me: me, accentColor: accentColor, createdAt: createdAt)
    }
    
    static func examples() -> [AssignedFriend] {
        let f1 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, name: "John Doe", me: true, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f2 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!, name: "Jeanny Ruslan", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f3 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!, name: "Samsul Riandi", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f4 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440003")!, name: "Michael Backdoor", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f5 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440004")!, name: "Valentino Simanjutak", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f6 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440005")!, name: "Sisilia Morgan", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f7 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440006")!, name: "Revi Coki", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f8 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440007")!, name: "Faeshal", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)

        
        return [f1, f2, f3, f4, f5, f6, f7, f8]
    }
    
    static func assignedExamples() -> [AssignedFriend] {
        let f1 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, name: "John Doe", me: true, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f2 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!, name: "Jeanny Ruslan", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
        let f3 = AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!, name: "Samsul Riandi", me: false, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)

        
        return [f1, f2, f3]
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
    
    static func example() -> AssignedFriend {
        return AssignedFriend(friendId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440000")!, name: "John Doe", me: true, accentColor: colorGen().toHex(), qty: 0, subTotal: 0)
    }
}

struct AssignedItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let qty: Double
    let price: Double
    var equal: Bool
    var friends: [AssignedFriend] = []
    var createdAt = Date()
    
    init(name: String, qty: Double, price: Double) {
        self.name = name
        self.qty = qty
        self.price = price
        self.equal = false
    }
    
    init(id: UUID, name: String, qty: Double, equal: Bool = false, price: Double, createdAt: Date) {
        self.id = id
        self.name = name
        self.qty = qty
        self.equal = equal
        self.price = price
        self.createdAt = createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.qty = try container.decode(Double.self, forKey: .qty)
        self.equal = try container.decodeIfPresent(Bool.self, forKey: .equal) ?? false
        self.price = try container.decode(Double.self, forKey: .price)
    }
    
    func subTotal() -> Double {
        return qty * price
    }
    
    func getTakenQty() -> Double {
        return friends.reduce(0) { $0 + $1.qty }
    }
    
    func getTakenQty(by friendId: String) -> Double {
        let results = friends.filter({ $0.friendId.uuidString == friendId })
        
        return results.reduce(0) { $0 + $1.qty }
    }
    
    func getTakenQtyString(by friendId: String) -> String {
        let takenQty = getTakenQty(by: friendId)
        return String(takenQty)
    }
    
    mutating func assignFriend(friend: AssignedFriend, newQty: Double) {
        if let index = friends.firstIndex(where: { $0.friendId == friend.friendId }) {
            friends[index].qty += newQty
            friends[index].subTotal = price * friends[index].qty
            
            if friends[index].qty == 0 {
                friends.remove(at: index)
            }
        } else {
            let subTotal = price + newQty

            let newFriend = AssignedFriend(friendId: friend.friendId, name: friend.name, me: friend.me, accentColor: friend.accentColor, qty: newQty, subTotal: subTotal)
            friends.append(newFriend)
        }
    }
    
    mutating func unEqualAssign() {
        if equal {
            friends = []
            equal = false
        }
    }
    
    mutating func equalAssign(assignedFriends: [AssignedFriend]) {
        let totalPrice = price * qty
        let eachPrice = totalPrice / Double(assignedFriends.count)
        
        for friend in assignedFriends {
            if let index = friends.firstIndex(where: { $0.friendId == friend.friendId }) {
                friends[index].qty = qty
                friends[index].subTotal = eachPrice
            } else {
                let newFriend = AssignedFriend(friendId: friend.friendId, name: friend.name, me: friend.me, accentColor: friend.accentColor, qty: qty, subTotal: eachPrice)
                friends.append(newFriend)
            }
        }
        
        equal = true
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
    var usePercentage: Bool
    let amount: Double
    var createdAt = Date()
    
    init(name: String, type: String, usePercentage: Bool, amount: Double) {
        self.name = name
        self.type = type
        self.usePercentage = usePercentage
        self.amount = amount
    }
    
    init(id: UUID, name: String, type: String, usePercentage: Bool,  amount: Double, createdAt: Date) {
        self.id = id
        self.name = name
        self.type = type
        self.usePercentage = usePercentage
        self.amount = amount
        self.createdAt = createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.usePercentage = try container.decode(Bool.self, forKey: .usePercentage)
        self.amount = try container.decode(Double.self, forKey: .amount)
    }
    
    func subTotal() -> Double {
        return isDeduction() ? -amount : amount
    }
    
    func isDeduction() -> Bool {
        return type == "deduction" && !usePercentage
    }
    
    func isTax() -> Bool {
        return type == "tax"
    }
    
    func isDiscount() -> Bool {
        return type == "deduction" && usePercentage
    }
    
    func isServiceCharge() -> Bool {
        let lowercasedName = name.lowercased()
        return lowercasedName == "sc" || lowercasedName.contains("service") || lowercasedName.contains("service cost")
    }
    
    static func examples() -> [OtherItem] {
        return [
            OtherItem(name: "Discount", type: "discount", usePercentage: true, amount: 22),
            OtherItem(name: "Tax", type: "tax", usePercentage: true, amount: 12),
        ]
    }
    
    static func example() -> OtherItem {
        return OtherItem(id: UUID(uuidString: "B2391D93-80E4-444E-8B4F-81B09D8FA4AD") ?? UUID(), name: "Tax", type: "addition", usePercentage: false, amount: 15000,  createdAt: Date())
    }
}

struct SplitItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var status: String
    var friends: [AssignedFriend]
    var items: [AssignedItem]
    var otherPayments: [OtherItem]
    let createdAt: Date
    
    init() {
        self.id = UUID()
        self.status = ""
        self.name = ""
        self.status = ""
        self.friends = []
        self.items = []
        self.otherPayments = []
        self.createdAt = Date()
    }
    
    init(id: UUID = UUID(), name: String, status: String, friends: [AssignedFriend] = [], items: [AssignedItem] = [], otherPayments: [OtherItem] = [], createdAt: Date) {
        self.id = id
        self.name = name
        self.status = status
        self.friends = friends
        self.items = items
        self.otherPayments = otherPayments
        self.createdAt = createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? "draft"
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
    
    mutating func updateOtherItem(_ updatedItem: OtherItem) {
        if let index = otherPayments.firstIndex(where: { $0.id == updatedItem.id }) {
            otherPayments[index] = updatedItem
        }
    }
    
    mutating func toggleFriend(_ friend: AssignedFriend) {
        if let index = friends.firstIndex(where: { $0.friendId == friend.friendId }) {
            friends.remove(at: index)
        } else {
            friends.append(friend)
        }
    }
    
    func hasFriend(with friendId: UUID) -> Bool {
        return friends.contains(where: { $0.friendId == friendId })
    }
    
    func subTotal() -> Double {
        let itemsTotal = items.reduce(Double(0)) { $0 + $1.subTotal() }
        
        let otherPaymentsTotal = otherPayments.reduce(Double(0)) {
            if $1.isTax() || $1.isDiscount() || $1.isServiceCharge(){
                return $0
            }
            
            if $1.usePercentage {
                return $0
            }
            
            if $1.isDeduction() {
                return $0 - $1.subTotal()
            }
            
            return $0 + $1.subTotal()
        }
        
        var total = itemsTotal + otherPaymentsTotal
        
        for payment in otherPayments {
            if !payment.isDiscount() && !payment.isTax() && !payment.isServiceCharge() && payment.usePercentage {
                let amountTotal = payment.amount / 100 * total
                if !payment.isDeduction() {
                    total += amountTotal
                }
            }
        }
        
        return total
    }
    
    func grandTotal() -> Double {
        let itemsTotal = items.reduce(0) { $0 + $1.subTotal() }
        let otherPaymentsTotal = otherPayments.reduce(0) {
            if $1.isTax() || $1.isDiscount() || $1.isServiceCharge() {
                return $0
            }
            
            if $1.usePercentage {
                return $0
            }
            
            return $0 + $1.subTotal()
        }
        
        var total = itemsTotal + otherPaymentsTotal
        
        for payment in otherPayments {
            if !payment.isDiscount() && !payment.isTax() && !payment.isServiceCharge() && payment.usePercentage {
                var amountTotal = (payment.amount / 100) * total
                if payment.isDeduction() {
                    amountTotal = -amountTotal
                }
                
                total += amountTotal
            }
        }

        for payment in otherPayments {
            if payment.isDiscount() {
                var disc = payment.amount
                if payment.usePercentage {
                    disc = (payment.amount / 100) * total
                }
                
                total -= disc
            }
        }
        
        for payment in otherPayments {
            if payment.isTax() {
                var tax = payment.amount
                if payment.usePercentage {
                    tax = (payment.amount / 100) * total
                }
                
                total += tax
            }
        }
        
        for payment in otherPayments {
            if payment.isServiceCharge() {
                var sc = payment.amount
                if payment.usePercentage {
                    sc = payment.amount / 100 * total
                }
                
                total += sc
            }
        }
        
        return total
    }
    
    func itemTotal() -> Double {
        return items.reduce(0) { $0 + $1.subTotal() }
    }
    
    func otherTotal() -> Double {
        return otherPayments.reduce(0) { $0 + $1.subTotal() }
    }
    
    func toData() -> Split {
        return Split(id: self.id, name: self.name, status: self.status, items: self.items, otherPayments: self.otherPayments, createdAt: self.createdAt)
    }
    
    func hasUnassignedItem() -> Bool {
        for item in items {
            if item.friends.isEmpty {
                return true
            }
        }
        
        return false
    }
    
    func friendNames() -> [String] {
        var nameSet = Set<String>()
        
        for item in items {
            for friend in item.friends {
                nameSet.insert(friend.name)
            }
        }
        
        return Array(nameSet)
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
    
    static func example() -> SplitItem {
        let items = AssignedItem.examples()
        let otherPayments = OtherItem.examples()
        let friends = AssignedFriend.assignedExamples()
        
        return SplitItem(name: "Lawson Time", status: "draft", friends: friends, items: items, otherPayments: otherPayments, createdAt: Date())
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

struct SaveSplitResponse: Codable {
    let message: String
    let success: Bool
    let data: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.data = try container.decode(String.self, forKey: .data)
    }
}

enum PaymentType: String, CaseIterable, Identifiable {
    case addition, deduction, tax, discount
    var id: Self { self }
    
    var value: String {
        return self.rawValue.capitalized
    }
}

@Model
class Split {
    @Attribute(.unique) var id: UUID
    var name: String
    var status: String
    var items: [AssignedItem]
    var otherPayments: [OtherItem]
    let createdAt: Date
    
    init(id: UUID, name: String, status: String, items: [AssignedItem], otherPayments: [OtherItem], createdAt: Date) {
        self.id = id
        self.name = name
        self.status = status
        self.items = items
        self.otherPayments = otherPayments
        self.createdAt = createdAt
    }
    
    func toItemSplit() -> SplitItem {
        return SplitItem(id: self.id, name: self.name, status: self.status, items: self.items, otherPayments: self.otherPayments, createdAt: self.createdAt)
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
}
