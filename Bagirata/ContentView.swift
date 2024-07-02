//
//  ContentView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 26/06/24.
//

import SwiftUI
import SwiftData
import Vision

struct ContentView: View {
    @State private var selectedTab: Tabs = .history
    @State private var showScanner: Bool = false
    @State private var search: String = ""
    
    @State private var texts: [Scan] = []
    
    @State private var split: ItemSplit = ItemSplit()
    
    var body: some View {
        NavigationStack {
            switch selectedTab {
            case .history:
                HistoryView()
            case .friend:
                NavigationStack {
                    FriendView(search: search)
                        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Friends")
                }
            case .result:
                ScanResultView(splitItem: $split)
            }
        }
        .navigationTitle("Scan Result")
        .sheet(isPresented: $showScanner, content: {
            makeScannerView()
        })

        BagiraTab(selectedTab: $selectedTab, showScanner: $showScanner)
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completionHandler: { it in
            if it == nil {
                showScanner = false
                return
            }
            
            split = it ?? ItemSplit()
            
            selectedTab = .result
            showScanner = false
        })
    }
}

#Preview {
    ContentView()
}
