//
//  ScanResultView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI
import SwiftData

struct ScanResultView: View {
    @Environment(\.modelContext) private var context
    @Query(
        filter: #Predicate<Friend> { friend in
            friend.me
        }
    ) var me: [Friend]
    
    var profile: Friend? { me.first }
    
    @Binding var currentSubTab: SubTabs
    @Binding var selectedTab: Tabs
    @Binding var splitItem: SplitItem
    @Binding var isActive: Bool
    
    @State private var selectedItem: AssignedItem?
    @State private var selectedOther: OtherItem?
    
    @State private var hasMe: Bool = false
    
    @State private var showSheet: Bool = false
    @State private var showOtherSheet: Bool = false
    @State private var showFriendSheet: Bool = false
    @State private var showConfirmation: Bool = false
    
    @State private var search: String = ""
    @State private var searchFriend: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        TextField("Split Title", text: $splitItem.name)
                            .textFieldStyle(.plain)
                            .font(.title)
                            .bold()
                        Text(splitItem.formatCreatedAt())
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                    }
                    
                    Text(IDR(splitItem.grandTotal()))
                        .font(.system(size: 20))
                        .foregroundStyle(.gray)
                }
                .padding(.top, 10)
                .padding(.bottom, 5)
                .listRowSeparator(.hidden)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(splitItem.friends) { friend in
                            VStack {
                                BagirataAvatar(
                                    name: friend.name,
                                    width: 55,
                                    height: 55,
                                    fontSize: 30,
                                    background: Color(hex: friend.accentColor),
                                    style: .plain
                                )
                                .padding(1)
                                
                                Text(friend.name.truncate(length: 10))
                                    .font(.system(size: 10))
                                    .foregroundStyle(.gray)
                            }
                        }
                            Button(action: {
                                showFriendSheet.toggle()
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 55, height: 55)
                                    VStack {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                    }
                                    .frame(width: 50)
                                }
                            })
                            .tint(Color.blue)
                            .padding(.top, -12)
                    }
                }
                .listRowSeparator(.hidden)
                
                Section("Items") {
                    ForEach(splitItem.items.sorted(by: { $0.createdAt < $1.createdAt })) { item in
                        Button(action: {
                            selectedItem = item
                        }, label: {
                            HStack(alignment: .center, spacing: 10) {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.system(size: 18))
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
                        })
                        .padding(.vertical, 10)
                    }
                    .onDelete(perform: deleteItem)
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            showSheet.toggle()
                        }, label: {
                            Text("Add Item")
                                .padding(5)
                                .frame(maxWidth: .infinity)
                        })
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
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
                    .onDelete(perform: deleteOther)
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            showOtherSheet.toggle()
                        }, label: {
                            Text("Add Other Payment")
                                .padding(5)
                                .frame(maxWidth: .infinity)
                        })
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .destructive,action: {
                        showConfirmation.toggle()
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                }
                
                ToolbarItem {
                    Button(action: {
                        currentSubTab = .assign
                    }, label: {
                        Text("Continue")
                    })
                    
                }
            }
            .sheet(isPresented: $showSheet, content: {
                AddItem(splitItem: $splitItem)
                    .presentationDetents([.height(300)])
            })
            .sheet(item: $selectedItem) { item in
                EditItem(splitItem: $splitItem, item: item)
                    .presentationDetents([.height(300)])
            }
            .sheet(isPresented: $showOtherSheet, content: {
                AddOtherItem(splitItem: $splitItem)
                    .presentationDetents([.height(300)])
            })
            .sheet(item: $selectedOther) { item in
                EditOtherItem(splitItem: $splitItem, item: item)
                    .presentationDetents([.height(300)])
            }
            .sheet(isPresented: $showFriendSheet, content: {
                VStack {
                    Text("Friends")
                        .font(.title2)
                        .padding(.top, 15)
                    ZStack(alignment: .trailing) {
                        TextField("Search", text: $searchFriend)
                            .padding(.horizontal, 11)
                            .padding(.vertical, 11)
                            .padding(.trailing, 30)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.2), radius: 0.2, x: 0.0, y: 1)
                            .accentColor(Color.blue)
                            .padding(.horizontal)
                        
                        if !searchFriend.isEmpty {
                            Button(action: {
                                searchFriend = ""
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                            })
                            .offset(x: -30)
                            .tint(.gray)
                        }
                    }
                    FriendSheet(search: searchFriend, splitItem: $splitItem)
                        .presentationDetents([.medium])
                }
            })
            .confirmationDialog("Are you sure want to discard?", isPresented: $showConfirmation, titleVisibility: .visible) {
                Button(role: .destructive, action: {
                    selectedTab = .history
                    isActive = false
                    splitItem = SplitItem()
                }, label: {
                    Text("Discard")
                })
            }
        }
        .onAppear {
            if splitItem.friends.count == 0 {
                if let pf = profile {
                    hasMe = pf.me
                    splitItem.toggleFriend(pf.toAssignedFriend())
                }
            }
        }
    }
    
    private func deleteItem(at offsets: IndexSet) {
        splitItem.items.remove(atOffsets: offsets)
    }
    
    private func deleteOther(at offsets: IndexSet) {
        splitItem.otherPayments.remove(atOffsets: offsets)
    }
}

#Preview {
    ScanResultView(currentSubTab: .constant(.assign), selectedTab: .constant(.result), splitItem: .constant(SplitItem.example()), isActive: .constant(true))
}
