//
//  FriendSheet.swift
//  Bagirata
//
//  Created by Frederich Blessy on 05/07/24.
//

import SwiftUI
import SwiftData

struct FriendSheet: View {
    @Environment(\.modelContext) private var context
    @Query private var friends: [Friend]
    
    var search: String
    @Binding var splitItem: SplitItem
    
    init(search: String, splitItem: Binding<SplitItem>) {
        self.search = search
        self._splitItem = splitItem
        
        _friends = Query(
            filter: #Predicate<Friend> { friend in
                friend.name.localizedStandardContains(search) || search.isEmpty
            },
            sort: \Friend.createdAt,
            order: .reverse
        )
    }
    
    
    var body: some View {
        List {
            ForEach(friends) { friend in
                Button(action: {
                    splitItem.toggleFriend(friend.toAssignedFriend())
                }, label: {
                    HStack {
                        BagirataAvatar(name: friend.name, width: 32, height: 32, fontSize: 16, background: Color(hex: friend.accentColor), style: .plain)
                            .padding(.vertical, 2.3)
                        Text(friend.name)
                        Spacer()
                        Text(friend.formatCreatedAt())
                            .font(.system(size: 12))
                            .foregroundStyle(Color.gray)
                        Image(systemName: splitItem.hasFriend(with: friend.id) ? "checkmark.circle.fill" : "circle")
                            .padding(.leading)
                            .foregroundColor(splitItem.hasFriend(with: friend.id) ? .blue : .primary)
                    }
                })
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    FriendSheet(search: "", splitItem: .constant(SplitItem.example()))
}
