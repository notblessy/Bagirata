//
//  FriendView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 27/06/24.
//

import SwiftUI
import SwiftData

struct FriendView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Friend.createdAt) private var friends: [Friend]
    
    @State private var selection: String = ""
    @State private var search: String = ""
    @State private var showSheet: Bool = false
    @State private var showUpdateSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(friends) { friend in
                    HStack {
                        BagirataAvatar(name: friend.name, width: 32, height: 32, fontSize: 16, background: Color(hex: friend.accentColor))
                            .padding(.vertical, 2.3)
                        Text(friend.name)
                        Spacer()
                        Text(friend.formatCreatedAt())
                            .font(.system(size: 12))
                            .foregroundStyle(Color.gray)
                    }
                    .onTapGesture {
                        selection = friend.id.uuidString
                        showUpdateSheet.toggle()
                    }
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        let friend = friends[index]
                        context.delete(friend)
                    }
                })
            }
            .listStyle(.plain)
            .searchable(text: $search,placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Friends")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
                }
            }
            .navigationTitle("Friends")
            .sheet(isPresented: $showSheet, content: {
                AddFriend()
                    .presentationDetents([.medium])
            })
            .sheet(isPresented: $showUpdateSheet, content: {
                let friend = friends.first(where: {$0.id.uuidString == selection})
                UpdateFriend(friend: friend!)
                    .padding()
            })
        }
    }
}

#Preview {
    FriendView()
}
