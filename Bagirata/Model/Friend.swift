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
    
//   static func example() -> Friend {
//       return Friend(name: "John Doe", me: false, createdAt: Date(), accentColor: colorGen())
//   }
//    
//   static func examples() -> [Friend] {
//       return [
//        Friend(name: "John Doe", me: false, createdAt: Date(), accentColor: colorGen()),
//           Friend(name: "Jane Smith", me: false , createdAt: Date().addingTimeInterval(-86400), accentColor: colorGen()),
//           Friend(name: "Alice Johnson", me: false , createdAt: Date().addingTimeInterval(-172800), accentColor: colorGen())
//       ]
//   }
//    
    func formatCreatedAt() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter.string(from: createdAt)
    }
}

//struct Friend: Identifiable, Hashable, Equatable {
//    let id = UUID()
//    var name: String
//    var me: Bool
//    var accentColor: Color
//    var createdAt: Date
//    
//    init(name: String, me: Bool, createdAt: Date, accentColor: Color) {
//        self.name = name
//        self.me = me
//        self.accentColor = accentColor
//        self.createdAt = createdAt
//    }
//    
//   static func example() -> Friend {
//       return Friend(name: "John Doe", me: false, createdAt: Date(), accentColor: colorGen())
//   }
//    
//   static func examples() -> [Friend] {
//       return [
//        Friend(name: "John Doe", me: false, createdAt: Date(), accentColor: colorGen()),
//           Friend(name: "Jane Smith", me: false , createdAt: Date().addingTimeInterval(-86400), accentColor: colorGen()),
//           Friend(name: "Alice Johnson", me: false , createdAt: Date().addingTimeInterval(-172800), accentColor: colorGen())
//       ]
//   }
//    
//    func formatCreatedAt() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d MMMM yyyy"
//        
//        return formatter.string(from: createdAt)
//    }
//}
