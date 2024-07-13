//
//  ItemView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @State private var splits: [Splitted] = []
    
    @State private var page: Int = 0
    @State private var search: String = ""
    
    @State private var showSheet: Bool = false
    @State private var selectedSplit: Splitted?
    
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
                .onDelete(perform: deleteSplit)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        HStack {
                            Label("Setting", systemImage: "line.horizontal.3.decrease.circle")
                        }
                    })
                }
            }
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
    
    private func deleteSplit(at offsets: IndexSet) {
        splits.remove(atOffsets: offsets)
    }
}

#Preview {
    HistoryView()
        .modelContainer(previewContainer)
}
