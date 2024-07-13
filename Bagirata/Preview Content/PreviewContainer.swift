//
//  PreviewContainer.swift
//  Bagirata
//
//  Created by Frederich Blessy on 12/07/24.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Bank.self, Friend.self, Split.self, Splitted.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let splits: [Splitted] = Splitted.examples()
            
        for split in splits {
            container.mainContext.insert(split)
        }
        
        return container
    } catch {
        fatalError("Could not initialize ModelContainer")
    }
}()
