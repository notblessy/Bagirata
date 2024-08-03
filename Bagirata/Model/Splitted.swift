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
    let amount: Double
    let price: Double
    let type: String
    let usePercentage: Bool

    init(id: UUID, name: String, amount: Double, price: Double, type: String, usePercentage: Bool) {
        self.id = id
        self.name = name
        self.amount = amount
        self.price = price
        self.type = type
        self.usePercentage = usePercentage
    }
    
    func hasFormula() -> Bool {
        return type == "tax"
    }
    
    func getFormula(_ multiplier: Double) -> String {
        return "\(Int(amount))% * \(IDR(multiplier))"
    }
    
    func getPrice() -> String {
        switch type {
        case "addition", "tax":
            return IDR(price)
        default:
            return "-\(IDR(price))"
        }
    }
}

class SplittedFriend: Identifiable, Codable {
    let id: UUID
    let friendId: UUID
    let name: String
    let accentColor: String
    var total: Double
    var subTotal: Double
    let items: [FriendItem]
    var others: [FriendOther]
    let me: Bool
    let createdAt: String

    init(id: UUID, friendId: UUID, name: String, accentColor: String, total: Double, subTotal: Double, items: [FriendItem], others: [FriendOther], me: Bool, createdAt: String) {
        self.id = id
        self.friendId = friendId
        self.name = name
        self.accentColor = accentColor
        self.total = total
        self.subTotal = subTotal
        self.items = items
        self.others = others
        self.me = me
        self.createdAt = createdAt
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, friendId, name, accentColor, total, subTotal, items, others, me, createdAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(friendId, forKey: .friendId)
        try container.encode(name, forKey: .name)
        try container.encode(accentColor, forKey: .accentColor)
        try container.encode(total, forKey: .total)
        try container.encode(subTotal, forKey: .subTotal)
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
        total = try container.decode(Double.self, forKey: .total)
        subTotal = try container.decode(Double.self, forKey: .subTotal)
        items = try container.decode([FriendItem].self, forKey: .items)
        others = try container.decode([FriendOther].self, forKey: .others)
        me = try container.decode(Bool.self, forKey: .me)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}

class FriendItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let price: Double
    let equal: Bool
    let qty: Double

    init(id: UUID, name: String, price: Double, qty: Double, equal: Bool = false) {
        self.id = id
        self.name = name
        self.price = price
        self.qty = qty
        self.equal = equal
    }
    
    func formattedQuantity(_ totalFriends: Int) -> String {        
        if equal {
            return "x1/\(Int(totalFriends))"
        } else {
            return "x\(Int(qty))"
        }
    }
}

@Model
class Splitted: Identifiable, Codable {
    let id: UUID
    let slug: String
    let name: String
    let bankName: String
    let bankAccount: String
    let bankNumber: String
    let createdAt: String
    var subTotal: Double
    var grandTotal: Double
    var friends: [SplittedFriend]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, slug, createdAt, grandTotal, friends, bankName, bankAccount, bankNumber, subTotal
    }
    
    init() {
        self.id = UUID()
        self.slug = ""
        self.name = ""
        self.createdAt = ""
        self.grandTotal = 0
        self.friends = []
        self.bankName = ""
        self.bankAccount = ""
        self.bankNumber = ""
        self.subTotal = 0
    }
    
    init(id: UUID, slug: String, name: String, createdAt: Date, grandTotal: Double, friends: [SplittedFriend], bankName: String, bankAccount: String, bankNumber: String, subTotal: Double) {
        self.id = id
        self.slug = slug
        self.name = name
        self.createdAt = dateToString(d: createdAt)
        self.grandTotal = grandTotal
        self.friends = friends
        self.bankName = bankName
        self.bankAccount = bankAccount
        self.bankNumber = bankNumber
        self.subTotal = subTotal
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(slug, forKey: .slug)
        try container.encode(name, forKey: .name)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(grandTotal, forKey: .grandTotal)
        try container.encode(friends, forKey: .friends)
        try container.encode(bankName, forKey: .bankName)
        try container.encode(bankAccount, forKey: .bankAccount)
        try container.encode(bankNumber, forKey: .bankNumber)
        try container.encode(subTotal, forKey: .subTotal)
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        slug = try container.decode(String.self, forKey: .slug)
        name = try container.decode(String.self, forKey: .name)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        grandTotal = try container.decode(Double.self, forKey: .grandTotal)
        friends = try container.decode([SplittedFriend].self, forKey: .friends)
        bankName = try container.decodeIfPresent(String.self, forKey: .bankName) ?? ""
        bankAccount = try container.decodeIfPresent(String.self, forKey: .bankAccount) ?? ""
        bankNumber = try container.decodeIfPresent(String.self, forKey: .bankNumber) ?? ""
        subTotal = try container.decode(Double.self, forKey: .subTotal)
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
            amount: 12,
            price: 2000,
            type: "tax",
            usePercentage: true
        )
        
        let friends = [
            SplittedFriend(
                id: UUID(uuidString: "5C503B3A-6713-45C6-B70E-3CCE2A2E3A36")!,
                friendId: UUID(uuidString: "550E8400-E29B-41D4-A716-446655440000")!,
                name: "John Doe",
                accentColor: "#6662B1",
                total: 29000,
                subTotal: 29000,
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
                subTotal: 61000,
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
                subTotal: 32000,
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
            friends: friends,
            bankName: "BCA",
            bankAccount: "John Doe",
            bankNumber: "0284756389993",
            subTotal: 100000
        )
    }
    
    static func examples() -> [Splitted] {
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
            amount: 12,
            price: 2000,
            type: "tax",
            usePercentage: true
        )
        
        let friends = [
            SplittedFriend(
                id: UUID(uuidString: "5C503B3A-6713-45C6-B70E-3CCE2A2E3A36")!,
                friendId: UUID(uuidString: "550E8400-E29B-41D4-A716-446655440000")!,
                name: "John Doe",
                accentColor: "#6662B1",
                total: 29000,
                subTotal: 29000,
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
                subTotal: 61000,
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
                subTotal: 32000,
                items: items3,
                others: [other1],
                me: false,
                createdAt: "2024-07-06T06:32:57Z"
            )
        ]
        
        let splitted1 = Splitted(
            id: UUID(uuidString: "44D88F40-303C-43C8-BF92-2E4E38CF3817")!,
            slug: generateSlug(length: 5),
            name: "1CO Food Centrum sunter",
            createdAt: formatter.date(from: "2024-07-06T06:32:23Z")!,
            grandTotal: 122000,
            friends: friends,
            bankName: "BCA",
            bankAccount: "John Doe",
            bankNumber: "0284756389993",
            subTotal: 1000000
        )
        
        let splitted2 = Splitted(
            id: UUID(uuidString: "44D88F40-303C-43C8-BF92-2E4E38CF3816")!,
            slug: generateSlug(length: 5),
            name: "Coffee beans and tea leaf",
            createdAt: formatter.date(from: "2024-07-06T06:32:23Z")!,
            grandTotal: 550000,
            friends: friends,
            bankName: "BCA",
            bankAccount: "John Doe",
            bankNumber: "0284756389993",
            subTotal: 10000000
        )
        
        return [splitted1, splitted2]
    }
}

func splitted(splitItem: SplitItem, bank: Bank) -> Splitted {
    var transformedFriends: [UUID: SplittedFriend] = [:]
    
    for item in splitItem.items {
        for friend in item.friends {
            let friendId = friend.friendId
            let friendItem = FriendItem(id: item.id, name: item.name, price: item.price, qty: friend.qty, equal: item.equal)
            
            if let existingFriend = transformedFriends[friendId] {
                var updatedItems = existingFriend.items
                
                if let index = updatedItems.firstIndex(where: { $0.id == friendItem.id }) {
                    updatedItems[index] = friendItem
                } else {
                    updatedItems.append(friendItem)
                }
                
                let updatedTotal = item.equal ? existingFriend.total + (item.price / Double(item.friends.count)) : existingFriend.total + (friend.qty * item.price)
                
                transformedFriends[friendId] = SplittedFriend(
                    id: existingFriend.id,
                    friendId: existingFriend.friendId,
                    name: existingFriend.name,
                    accentColor: existingFriend.accentColor,
                    total: updatedTotal,
                    subTotal: updatedTotal,
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
                    total: item.equal ? item.price / Double(item.friends.count) : friend.qty * item.price,
                    subTotal: item.equal ? item.price / Double(item.friends.count) : friend.qty * item.price,
                    items: [friendItem],
                    others: [],
                    me: friend.me,
                    createdAt: dateToString(d: friend.createdAt)
                )
                transformedFriends[friendId] = newFriend
            }
        }
    }
    
    for payment in splitItem.otherPayments {
        if payment.isDiscount() || payment.isTax() || payment.isServiceCharge() {
            continue
        }
        
        var amountSplitted = payment.amount / Double(splitItem.friends.count)
        
        for friendId in transformedFriends.keys {
            if let friend = transformedFriends[friendId] {
                if payment.usePercentage {
                    amountSplitted = ((payment.amount / 100) * splitItem.subTotal()) / Double(splitItem.friends.count)
                    friend.total -= amountSplitted
                    friend.subTotal -= amountSplitted
                }
                
                if payment.isDeduction() {
                    friend.total -= amountSplitted
                    friend.subTotal -= amountSplitted
                } else {
                    friend.total += amountSplitted
                    friend.subTotal += amountSplitted
                }
                
                let otherItem = FriendOther(
                    id: payment.id,
                    name: payment.name,
                    amount: payment.amount,
                    price: amountSplitted,
                    type: payment.type,
                    usePercentage: payment.usePercentage
                )
                
                var updatedOthers = friend.others
                if let index = updatedOthers.firstIndex(where: { $0.id == otherItem.id }) {
                    updatedOthers[index] = otherItem
                } else {
                    updatedOthers.append(otherItem)
                }
                
                friend.others = updatedOthers
                transformedFriends[friendId] = friend
            }
        }
    }
    
    for payment in splitItem.otherPayments {
        if !payment.isDiscount() {
            continue
        }
        
        var amountSplitted = payment.amount / Double(splitItem.friends.count)
        
        for friendId in transformedFriends.keys {
            if let friend = transformedFriends[friendId] {
                if payment.usePercentage {
                    let amountSplitted = ((payment.amount / 100) * splitItem.subTotal()) / Double(splitItem.friends.count)
                }
                
                friend.total -= amountSplitted
                friend.subTotal -= amountSplitted
                
                let otherItem = FriendOther(
                    id: payment.id,
                    name: payment.name,
                    amount: payment.amount,
                    price: amountSplitted,
                    type: payment.type,
                    usePercentage: payment.usePercentage
                )
                
                var updatedOthers = friend.others
                if let index = updatedOthers.firstIndex(where: { $0.id == otherItem.id }) {
                    updatedOthers[index] = otherItem
                } else {
                    updatedOthers.append(otherItem)
                }
                
                friend.others = updatedOthers
                transformedFriends[friendId] = friend
            }
        }
    }
    
    for payment in splitItem.otherPayments {
        if !payment.isTax() {
            continue
        }
        
        var amountSplitted = payment.amount / Double(splitItem.friends.count)
        
        for friendId in transformedFriends.keys {
            if let friend = transformedFriends[friendId] {
                if payment.usePercentage {
                    amountSplitted = (payment.amount / 100) * friend.total
                }
                
                friend.total += amountSplitted
                
                let otherItem = FriendOther(id: payment.id, name: payment.name, amount: payment.amount, price: amountSplitted, type: payment.type, usePercentage: payment.usePercentage)
                
                var updatedOthers = friend.others
                if let index = updatedOthers.firstIndex(where: { $0.id == otherItem.id }) {
                    updatedOthers[index] = otherItem
                } else {
                    updatedOthers.append(otherItem)
                }
                
                friend.others = updatedOthers
                transformedFriends[friendId] = friend
            }
        }
    }
    
    for payment in splitItem.otherPayments {
        if !payment.isServiceCharge() {
            continue
        }
        
        var amountSplitted = payment.amount / Double(splitItem.friends.count)
        
        for friendId in transformedFriends.keys {
            if let friend = transformedFriends[friendId] {
                if payment.usePercentage {
                    amountSplitted = (payment.amount / 100) * friend.total
                }
                
                friend.total += amountSplitted
                
                let otherItem = FriendOther(id: payment.id, name: payment.name, amount: payment.amount, price: amountSplitted, type: payment.type, usePercentage: payment.usePercentage)
                
                var updatedOthers = friend.others
                if let index = updatedOthers.firstIndex(where: { $0.id == otherItem.id }) {
                    updatedOthers[index] = otherItem
                } else {
                    updatedOthers.append(otherItem)
                }
                
                friend.others = updatedOthers
                transformedFriends[friendId] = friend
            }
        }
    }
    
    return Splitted(
        id: splitItem.id,
        slug: generateSlug(length: 10),
        name: splitItem.name,
        createdAt: splitItem.createdAt,
        grandTotal: splitItem.grandTotal(),
        friends: Array(transformedFriends.values),
        bankName: bank.name,
        bankAccount: bank.accountName,
        bankNumber: bank.number,
        subTotal: splitItem.subTotal()
    )
}

func dateToString(d: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 7)

    return dateFormatter.string(from: d)
}
