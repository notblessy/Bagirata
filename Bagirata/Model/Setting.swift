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
    var number: String
    var accountName: String
    let createdAt: Date
    
    init() {
        self.id = UUID()
        self.name = ""
        self.number = ""
        self.accountName = ""
        self.createdAt = Date()
    }
    
    init(id: UUID, name: String, number: String, accountName: String, createdAt: Date) {
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
    
    func isEmpty() -> Bool {
        return name.isEmpty || accountName.isEmpty || number.isEmpty
    }
    
    static func example() -> Bank {
        return Bank(id: UUID(), name: "BCA", number: "04350280184", accountName: "I Komang Frederich Bless", createdAt: Date())
    }
}
