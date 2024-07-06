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
    @Query private var splits: [Splitted]
    
    var search: String
    
    init(search: String) {
        self.search = search
        
        _splits = Query(
            filter: #Predicate<Splitted> { splitted in
                splitted.name.localizedStandardContains(search) || search.isEmpty
            },
            sort: \Splitted.createdAt,
            order: .reverse
        )
    }
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(splits) { split in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(split.name)
                                .font(.system(size: 20))
                            BagirataAvatarGroup(imageNames: split.friendNames(), width: 26, height: 26, overlapOffset: 15, fontSize: 12)
                        }
                    
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text(split.formatCreatedAt())
                                .font(.system(size: 12))
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
//            .searchable(text: $search,placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Splits")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Manual Split")
                        }
                    })
                }
            }
            .navigationTitle("History")
            .sheet(isPresented: $showSheet, content: {
                AddFriend()
                    .presentationDetents([.medium])
            })
            .listStyle(.plain)
        }
        .overlay {
            if splits.isEmpty {
                Text("No Data")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    HistoryView(search: "")
}
