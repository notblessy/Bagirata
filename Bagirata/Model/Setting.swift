//
//  Setting.swift
//  Bagirata
//
//  Created by Frederich Blessy on 07/07/24.
//

import Foundation
import SwiftData

@Model
class Bank {
    @Attribute(.unique) var id: UUID
    var name: String
    var number: Int
    var accountName: String
    let createdAt: Date
    
    init(id: UUID, name: String, number: Int, accountName: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.number = number
        self.accountName = accountName
        self.createdAt = createdAt
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
    
    static func example() -> Bank {
        return Bank(id: UUID(), name: "BCA", number: 4350280184, accountName: "I Komang Frederich Bless", createdAt: Date())
    }
}
