//
//  AssignView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 05/07/24.
//

import SwiftUI

struct AssignView: View {
    @Environment(\.modelContext) private var context
    
    @Binding var currentSubTab: SubTabs
    @Binding var splitItem: SplitItem
    @Binding var splittedData: Splitted
    
    @State private var selectedFriend: AssignedFriend?
    @State private var selectedItem: AssignedItem?
    @State private var selectedOther: OtherItem?
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(splitItem.name)
                                .font(.title)
                                .bold()
                            Text(splitItem.formatCreatedAt())
                                .font(.system(size: 16))
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        Text(IDR(splitItem.grandTotal()))
                            .font(.system(size: 20))
                            .foregroundStyle(.gray)
                    }
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(splitItem.friends) { friend in
                                VStack {
                                    Button(action: {
                                        selectedFriend = friend
                                    }, label: {
                                        BagirataAvatar(
                                            name: friend.name,
                                            width: 55,
                                            height: 55,
                                            fontSize: 30,
                                            background: Color(hex: friend.accentColor),
                                            style: selectedFriend?.id == friend.id ? .active : .plain
                                        )
                                    })
                                    .padding(1)
                                    
                                    Text(friend.name.truncate(length: 10))
                                        .font(.system(size: 10))
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    if selectedFriend != nil {
                        Section("Item") {
                            ForEach(splitItem.items.sorted(by: { $0.createdAt < $1.createdAt })) { item in
                                
                                HStack {
                                    HStack(alignment: .center, spacing: 10) {
                                        VStack(alignment: .leading) {
                                            ZStack(alignment: .topTrailing) {
                                                Text(item.name)
                                                    .font(.system(size: 18))
                                                
                                                if item.getTakenQty(by: selectedFriend?.friendId.uuidString ?? "") > 0 {
                                                    Text(String(item.getTakenQty(by: selectedFriend?.friendId.uuidString ?? "")))
                                                        .font(.system(size: 10))
                                                        .fontWeight(.bold)
                                                        .padding(7)
                                                        .background(Color.red)
                                                        .foregroundColor(.white)
                                                        .clipShape(Circle())
                                                        .offset(x: 30, y: -10)
                                                }
                                                
                                            }
                                            HStack {
                                                Text(qty(item.qty))
                                                    .font(.system(size: 16))
                                                    .foregroundStyle(.gray)
                                                Text(IDR(item.price))
                                                    .font(.system(size: 16))
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                        Spacer()
                                        Text(IDR(item.price * item.qty))
                                            .foregroundStyle(.gray)
                                    }
                                }
                                .padding(.vertical, 10)
                                .swipeActions(edge: .leading) {
                                    Button() {
                                        var it = item
                                        if let fr = selectedFriend {
                                            it.assignFriend(friend: fr, newQty: -1)
                                            
                                            splitItem.updateItem(it)
                                        }
                                    } label: {
                                        Label("Sub", systemImage: "minus")
                                    }
                                    .tint(
                                        (item.getTakenQty(by: selectedFriend?.friendId.uuidString ?? "") == 0 && item.getTakenQty() > 0) || item.getTakenQty() == 0 ? .bagirataDimmed : .teal)
                                    .disabled(
                                        (item.getTakenQty(by: selectedFriend?.friendId.uuidString ?? "") == 0 && item.getTakenQty() > 0) || item.getTakenQty() == 0)
                                }
                                .swipeActions() {
                                    Button {
                                        var it = item
                                        if let fr = selectedFriend {
                                            it.assignFriend(friend: fr, newQty: 1)
                                            splitItem.updateItem(it)
                                        }
                                    } label: {
                                        Label("Add", systemImage: "plus")
                                    }
                                    .tint(item.getTakenQty() >= item.qty ? .bagirataDimmed : .indigo)
                                    .disabled(item.getTakenQty() >= item.qty)
                                }
                            }
                        }
                        
                        Section("Other") {
                            ForEach(splitItem.otherPayments.sorted(by: { $0.createdAt < $1.createdAt })) { item in
                                Button(action: {
                                    selectedOther = item
                                }, label: {
                                    HStack(alignment: .center, spacing: 10) {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                                .font(.system(size: 18))
                                            Text(item.type.capitalized)
                                                .font(.system(size: 16))
                                                .foregroundStyle(.gray)
                                        }
                                        Spacer()
                                        Text(IDR(item.amount))
                                            .foregroundStyle(.gray)
                                    }
                                })
                                .padding(.vertical, 10)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            currentSubTab = .review
                        }, label: {
                            Label("Back", systemImage: "chevron.left")
                        })
                    }
                    
                    ToolbarItem {
                        Button(action: {
                            let transformedSplit = splitted(splitItem: splitItem)
                            
                            context.insert(transformedSplit)
                            
                            splittedData = transformedSplit
                            currentSubTab = .split
                        }, label: {
                            Text("Continue")
                        })
                        
                    }
                }
                .overlay {
                    if selectedFriend == nil {
                        VStack {
                            Text("No Data")
                                .font(.title2)
                                .foregroundStyle(.gray)
                            Text("Please select friend")
                                .font(.system(size: 16))
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AssignView(currentSubTab: .constant(.assign), splitItem: .constant(SplitItem.example()), splittedData: .constant(Splitted.example()))
}
