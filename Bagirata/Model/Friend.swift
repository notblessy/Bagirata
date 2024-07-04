//
//  Friend.swift
//  Bagirata
//
//  Created by Frederich Blessy on 26/06/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Friend {
    @Attribute(.unique) var id: UUID
    var name: String
    var me: Bool
    var accentColor: String
    let createdAt: Date
    
    init(id: UUID, name: String, me: Bool, accentColor: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.me = me
        self.accentColor = accentColor
        self.createdAt = createdAt
    }
    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
}
