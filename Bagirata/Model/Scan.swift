//
//  Scan.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import Foundation

struct Scan: Identifiable {
    var id = UUID()
    let name: String
    let items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
}
