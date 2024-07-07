//
//  BagirataApp.swift
//  Bagirata
//
//  Created by Frederich Blessy on 26/06/24.
//

import SwiftUI
import SwiftData

@main
struct BagirataApp: App {
    let modelContainer: ModelContainer
        
    init() {
        do {
            modelContainer = try ModelContainer(for: Bank.self, Friend.self, Splitted.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
