//
//  Splitted.swift
//  Bagirata
//
//  Created by Frederich Blessy on 06/07/24.
//

import Foundation
import SwiftData

class FriendOther: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Int

    init(id: UUID, name: String, price: Int) {
        self.id = id
        self.name = name
        self.price = price
    }
}

class SplittedFriend: Identifiable, Codable {
    let id: UUID
    let friendId: UUID
    let name: String
    let accentColor: String
    var total: Int
    let items: [FriendItem]
    var others: [FriendOther]
    let me: Bool
    let createdAt: String

    init(id: UUID, friendId: UUID, name: String, accentColor: String, total: Int, items: [FriendItem], others: [FriendOther], me: Bool, createdAt: String) {
        self.id = id
        self.friendId = friendId
        self.name = name
        self.accentColor = accentColor
        self.total = total
        self.items = items
        self.others = others
        self.me = me
        self.createdAt = createdAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, friendId, name, accentColor, total, items, others, me, createdAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(friendId, forKey: .friendId)
        try container.encode(name, forKey: .name)
        try container.encode(accentColor, forKey: .accentColor)
        try container.encode(total, forKey: .total)
        try container.encode(items, forKey: .items)
        try container.encode(others, forKey: .others)
        try container.encode(me, forKey: .me)
        try container.encode(createdAt, forKey: .createdAt)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        friendId = try container.decode(UUID.self, forKey: .friendId)
        name = try container.decode(String.self, forKey: .name)
        accentColor = try container.decode(String.self, forKey: .accentColor)
        total = try container.decode(Int.self, forKey: .total)
        items = try container.decode([FriendItem].self, forKey: .items)
        others = try container.decode([FriendOther].self, forKey: .others)
        me = try container.decode(Bool.self, forKey: .me)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}

class FriendItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Int
    let qty: Int

    init(id: UUID, name: String, price: Int, qty: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.qty = qty
    }
}

@Model
class Splitted: Identifiable, Codable {
    let id: UUID
    let slug: String
    let name: String
    let createdAt: String
    var grandTotal: Int
    var friends: [SplittedFriend]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, slug, createdAt, grandTotal, friends
    }
    
    init() {
        self.id = UUID()
        self.slug = ""
        self.name = ""
        self.createdAt = ""
        self.grandTotal = 0
        self.friends = []
    }
    
    init(id: UUID, slug: String, name: String, createdAt: Date, grandTotal: Int, friends: [SplittedFriend]) {
        self.id = id
        self.slug = slug
        self.name = name
        self.createdAt = dateToString(d: createdAt)
        self.grandTotal = grandTotal
        self.friends = friends
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(slug, forKey: .slug)
        try container.encode(name, forKey: .name)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(grandTotal, forKey: .grandTotal)
        try container.encode(friends, forKey: .friends)
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        slug = try container.decode(String.self, forKey: .slug)
        name = try container.decode(String.self, forKey: .name)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        grandTotal = try container.decode(Int.self, forKey: .grandTotal)
        friends = try container.decode([SplittedFriend].self, forKey: .friends)
    }
    
    func friendNames() -> [String] {
        var nameSet = Set<String>()
        
        for friend in friends {
            nameSet.insert(friend.name)
        }
        
        return Array(nameSet)
    }
    
    func formatCreatedAt() -> String {
        let parser = DateFormatter()
        parser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        parser.timeZone = TimeZone(secondsFromGMT: 7)

        guard let date = parser.date(from: self.createdAt) else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: date)
    }
    
    static func example() -> Splitted {
        let formatter = ISO8601DateFormatter()
        
        let items1 = [
            FriendItem(
                id: UUID(uuidString: "3FCEA1EE-1033-420B-9024-B875E6D0FA8B")!,
                name: "Iced Thai Tea D Glazy",
                price: 29000,
                qty: 1
            )
        ]
        
        let items2 = [
            FriendItem(
                id: UUID(uuidString: "3FCEA1EE-1033-420B-9024-B875E6D0FA8B")!,
                name: "Iced Thai Tea D Glazy",
                price: 29000,
                qty: 1
            ),
            FriendItem(
                id: UUID(uuidString: "D62F87D3-3445-4C96-96BA-07D3829BE5E6")!,
                name: "Jcoccino",
                price: 32000,
                qty: 1
            )
        ]
        
        let items3 = [
            FriendItem(
                id: UUID(uuidString: "D62F87D3-3445-4C96-96BA-07D3829BE5E6")!,
                name: "Jcoccino",
                price: 32000,
                qty: 1
            )
        ]
        
        let other1 = FriendOther(
            id: UUID(uuidString: "D62F87D3-3445-4C96-96BA-07D3829BE5E6")!,
            name: "Tax",
            price: 12000
        )
        
        let friends = [
            SplittedFriend(
                id: UUID(uuidString: "5C503B3A-6713-45C6-B70E-3CCE2A2E3A36")!,
                friendId: UUID(uuidString: "550E8400-E29B-41D4-A716-446655440000")!,
                name: "John Doe",
                accentColor: "#6662B1",
                total: 29000,
                items: items1,
                others: [other1],
                me: true,
                createdAt: "2024-07-06T06:32:57Z"
            ),
            SplittedFriend(
                id: UUID(uuidString: "7B8E2D55-A8F9-44EB-9DA4-5326BDF42FBD")!,
                friendId: UUID(uuidString: "550E8400-E29B-41D4-A716-446655440002")!,
                name: "Samsul Riandi",
                accentColor: "#6C6CBC",
                total: 61000,
                items: items2,
                others: [other1],
                me: false,
                createdAt: "2024-07-06T06:32:57Z"
            ),
            SplittedFriend(
                id: UUID(uuidString: "EB489A69-1C8A-4551-9BA7-5E1FDAF1E697")!,
                friendId: UUID(uuidString: "550E8400-E29B-41D4-A716-446655440001")!,
                name: "Jeanny Ruslan",
                accentColor: "#A6BB66",
                total: 32000,
                items: items3,
                others: [other1],
                me: false,
                createdAt: "2024-07-06T06:32:57Z"
            )
        ]
        
        return Splitted(
            id: UUID(uuidString: "44D88F40-303C-43C8-BF92-2E4E38CF3817")!,
            slug: generateSlug(length: 5),
            name: "1CO Food Centrum sunter",
            createdAt: formatter.date(from: "2024-07-06T06:32:23Z")!,
            grandTotal: 122000,
            friends: friends
        )
    }
}


func splitted(splitItem: SplitItem) -> Splitted {
    var transformedFriends: [UUID: SplittedFriend] = [:]
    var grandTotal = 0
    
    for item in splitItem.items {
        for friend in item.friends {
            let friendId = friend.friendId
            let friendItem = FriendItem(id: item.id, name: item.name, price: item.price, qty: friend.qty)
            
            if let existingFriend = transformedFriends[friendId] {
                var updatedItems = existingFriend.items
                updatedItems.append(friendItem)
                let updatedTotal = existingFriend.total + (friend.qty * item.price)
                transformedFriends[friendId] = SplittedFriend(
                    id: existingFriend.id,
                    friendId: existingFriend.friendId,
                    name: existingFriend.name,
                    accentColor: existingFriend.accentColor,
                    total: updatedTotal,
                    items: updatedItems,
                    others: [],
                    me: existingFriend.me,
                    createdAt: existingFriend.createdAt
                )
            } else {
                let newFriend = SplittedFriend(
                    id: friend.id,
                    friendId: friend.friendId,
                    name: friend.name,
                    accentColor: friend.accentColor,
                    total: friend.qty * item.price,
                    items: [friendItem],
                    others: [],
                    me: friend.me,
                    createdAt: dateToString(d: friend.createdAt)
                )
                transformedFriends[friendId] = newFriend
            }
            
            grandTotal += friend.qty * item.price
        }
        
        for payment in splitItem.otherPayments {
            if payment.type == "addition" {
                let amountPerFriend = payment.amount / transformedFriends.count
                
                for friendId in transformedFriends.keys {
                    if let friend = transformedFriends[friendId] {
                        friend.total += amountPerFriend
                        let otherItem = FriendOther(id: UUID(), name: payment.name, price: amountPerFriend)
                        friend.others.append(otherItem)
                        transformedFriends[friendId] = friend
                    }
                }
            }
        }
    }
    
    return Splitted(
        id: splitItem.id,
        slug: generateSlug(length: 10),
        name: splitItem.name,
        createdAt: splitItem.createdAt,
        grandTotal: grandTotal,
        friends: Array(transformedFriends.values)
    )
}

func dateToString(d: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 7)

    return dateFormatter.string(from: d)
}
