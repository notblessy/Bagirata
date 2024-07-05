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
    @State var isLoading: Bool = false
    @State var showAlertRecognizer: Bool = false
    @State var scannerResultActive: Bool = false
    @State var errMessage: String = ""
    
    @State private var selectedTab: Tabs = .history
    @State private var currentSubTab: SubTabs = .review
    @State private var showScanner: Bool = false
    @State private var search: String = ""
    
    @State private var texts: [Scan] = []
    
    @State private var split: SplitItem = SplitItem()
    
    var body: some View {
        NavigationStack {
            switch selectedTab {
            case .history:
                HistoryView()
                    .alert(isPresented: $showAlertRecognizer) {
                        Alert(title: Text("Scan Error"), message: Text(errMessage), dismissButton: .default(Text("OK")))
                    }
            case .friend:
                NavigationStack {
                    FriendView(search: search)
                        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Friends")
                }
            case .result:
                if isLoading {
                    ProgressView("Scanning Text...")
                        .progressViewStyle(.automatic)
                } else {
                    switch currentSubTab {
                    case .review:
                        ScanResultView(currentSubTab: $currentSubTab, selectedTab: $selectedTab, splitItem: split)
                    case .assign:
                        AssignView(currentSubTab: $currentSubTab, splitItem: split)
                    }
                }
            }
        }
        .navigationTitle("Scan Result")
        .sheet(isPresented: $showScanner, content: {
            makeScannerView()
        })

        BagiraTab(selectedTab: $selectedTab, showScanner: $showScanner, scannerResultActive: $scannerResultActive)
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completionHandler: { result in
            if result == nil {
                showScanner = false
                return
            }
            
            selectedTab = .result
            isLoading = true
            
            recognize(model: result ?? "") { res in
                switch res {
                case .success(let response):
                    split = response.data
                    scannerResultActive = true
                    
                    isLoading = false
                case .failure(let error):
                    errMessage = error.localizedDescription
                    isLoading = false
                    showAlertRecognizer = true
                    
                    selectedTab = .history
                }
            }
            
            showScanner = false
        })
    }
}

#Preview {
    ContentView()
}
