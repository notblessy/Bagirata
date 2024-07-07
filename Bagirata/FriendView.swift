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
    @Query private var friends: [Friend]
    
    var search: String
    
    init(search: String) {
        self.search = search
        
        _friends = Query(
            filter: #Predicate<Friend> { friend in
                friend.name.localizedStandardContains(search) || search.isEmpty
                
//                    (friend.name.localizedStandardContains(search) || search.isEmpty) && !friend.me
            },
            sort: \Friend.createdAt,
            order: .reverse
        )
    }
    
    @State private var showSheet: Bool = false
    @State private var showUpdateSheet: Bool = false
    @State private var selected: Friend?
    
    var body: some View {
        List {
            ForEach(friends) { friend in
                Button(action: {
                    selected = friend
                    showUpdateSheet.toggle()
                }, label: {
                    HStack {
                        BagirataAvatar(name: friend.name, width: 32, height: 32, fontSize: 16, background: Color(hex: friend.accentColor), style: .plain)
                            .padding(.vertical, 2.3)
                        Text(friend.name)
                        Spacer()
                        Text(friend.formatCreatedAt())
                            .font(.system(size: 12))
                            .foregroundStyle(Color.gray)
                    }
                })
            }
            .onDelete(perform: { indexSet in
                indexSet.forEach { index in
                    let friend = friends[index]
                    context.delete(friend)
                }
            })
        }
        .listStyle(.plain)
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
                .presentationDetents([.height(250)])
        })
        .sheet(item: $selected) { friend in
            EditFriend(friend: friend)
                .presentationDetents([.height(250)])
        }
        .overlay {
            if friends.isEmpty {
                Text("No Data")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    FriendView(search: "")
}
