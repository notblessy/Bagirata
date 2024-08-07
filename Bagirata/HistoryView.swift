//
//  ItemView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @State private var splits: [Splitted] = []
    
    @State private var page: Int = 0
    @State private var search: String = ""
    
    @State private var showSheet: Bool = false
    @State private var selectedSplit: Splitted?
    @State private var picker: PhotosPickerItem?
    @State private var showPicker: Bool = false
    
    @Binding var split: SplitItem
    @Binding var selectedTab: Tabs
    @Binding var scannerResultActive: Bool
    @Binding var currentSubTab: SubTabs
    
    @Binding var isLoading: Bool
    @Binding var showAlertRecognizer: Bool
    @Binding var errMessage: String
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(selection: $selectedSplit) {
                ForEach(splits, id: \.id) { split in
                    Button(action: {
                        selectedSplit = split
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(split.name.truncate(length: 20))
                                    .font(.system(size: 18))
                                HStack {
                                    BagirataAvatarGroup(friends: split.friends, width: 26, height: 26, overlapOffset: 15, fontSize: 12)
                                    Text(IDR(split.grandTotal))
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text(split.formatCreatedAt())
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .onAppear {
                            fetchIfNecessary(split: split)
                        }
                    })
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        let split = splits[index]
                        context.delete(split)
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        Button(action: {
                            showPicker.toggle()
                        }, label: {
                            HStack {
                                Image(systemName: "photo.stack")
                                Text("Upload")
                            }
                        })
                        Button(action: {
                            split.name = "untitled"
                            
                            scannerResultActive = true
                            selectedTab = .result
                            currentSubTab = .review
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Create Manual")
                            }
                        })
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("New Split")
                        }
                    })
                    .photosPicker(isPresented: $showPicker, selection: $picker, matching: .images)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        HStack {
                            Label("Setting", systemImage: "line.horizontal.3.decrease.circle")
                        }
                    })
                }
            }
            .tint(Color.bagirataOk)
            .navigationTitle("History")
            .sheet(isPresented: $showSheet, content: {
                EditMe()
                    .presentationDetents([.medium])
            })
            .listStyle(.plain)
        }, detail: {
            if let sp = selectedSplit {
                HistoryDetailView(split: sp)
            }
        })
        .onAppear {
            fetchHistories(search: search)
        }
        .overlay {
            if splits.isEmpty {
                Text("No Data")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
        }
        .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Histories")
        .onChange(of: search) { oldValue, newValue in
            fetchHistories(currentPage: 0, search: newValue)
        }
        .onChange(of: picker) {_, _ in
            Task {
                if let picker, let data = try? await picker.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        recognizerFrom(image, withCompletionHandler: { result in
                            if result.isEmpty {
                                errMessage = "Could not recognize text"
                                showAlertRecognizer = true
                                return
                            }
                            
                            selectedTab = .result
                            isLoading = true
                            
                            recognize(model: result) { res in
                                switch res {
                                case .success(let response):
                                    split = response.data
                                    scannerResultActive = true
                                    currentSubTab = .review
                                    
                                    isLoading = false
                                case .failure(let error):
                                    errMessage = error.localizedDescription
                                    isLoading = false
                                    
                                    showAlertRecognizer = true
                                    
                                    selectedTab = .history
                                }
                            }
                        })
                    }
                }
                
                picker = nil
            }
        }
        .alert(isPresented: $showAlertRecognizer) {
            Alert(title: Text("Scan Error"), message: Text(errMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func fetchHistories(currentPage: Int = 0, search: String = "", loadMore: Bool = false) {
        if !loadMore {
            splits = []
        }
        
        var fetchDescriptor = FetchDescriptor<Splitted>()
        fetchDescriptor.fetchLimit = 10
        fetchDescriptor.fetchOffset = page * 10
        fetchDescriptor.sortBy = [.init(\.createdAt, order: .reverse)]
        
        if !search.isEmpty {
            fetchDescriptor.predicate = #Predicate<Splitted> { splitted in
                splitted.name.localizedStandardContains(search) || search.isEmpty
            }
        }
        
        do {
            splits += try context.fetch(fetchDescriptor)
            page = currentPage
        } catch {
            print(error)
        }
    }
    
    private func fetchIfNecessary(split: Splitted) {
        if let lastSplit = splits.last, lastSplit == split {
            page += 1
            
            fetchHistories(currentPage: page, search: search, loadMore: true)
        }
    }
}

#Preview {
    HistoryView(split: .constant(SplitItem.example()), selectedTab: .constant(.history), scannerResultActive: .constant(false), currentSubTab: .constant(.review), isLoading: .constant(false), showAlertRecognizer: .constant(false), errMessage: .constant(""))
}
