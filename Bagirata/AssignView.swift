//
//  AssignView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 05/07/24.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

struct AssignView: View {
    @Environment(\.modelContext) private var context
    @Query() var banks: [Bank]
    
    var bank: Bank? { banks.first }
    
    @Binding var currentSubTab: SubTabs
    @Binding var splitItem: SplitItem
    @Binding var splittedData: Splitted
    
    @State private var selectedFriend: AssignedFriend?
    @State private var selectedItem: AssignedItem?
    @State private var selectedOther: OtherItem?
    @State private var showBankSheet: Bool = false
    
    @State var bankForm: Bank = Bank()
    
    @StateObject private var interstisialAdManager = InterstisialAdsManager()
    
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
                    
                    Section("Friends") {
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
                                        .padding(2)
                                        .buttonStyle(NoFadeButtonStyle())
                                        
                                        Text(friend.name.truncate(length: 10))
                                            .font(.system(size: 10))
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    
                    if bankForm.isEmpty() {
                        HStack {
                            Text("Transfer")
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                                .font(.system(size: 15))
                            
                            Spacer()
                            
                            Button(action: {
                                showBankSheet.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: "plus")
                                        .font(.system(size: 15))
                                        .foregroundColor(.bagirataOk)
                                    Text("Add Bank")
                                        .font(.system(size: 15))
                                        .foregroundColor(.bagirataOk)
                                }
                            })
                        }
                        .listRowSeparator(.hidden)
                    } else {
                        VStack(alignment: .leading) {
                            Text("Transfer")
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                                .font(.system(size: 15))
                                .padding(.bottom, 3)
                            Button(action: {
                                showBankSheet.toggle()
                            }, label: {
                                VStack(alignment: .leading) {
                                    Text(bankForm.name)
                                        .fontWeight(.bold)
                                    Text(bankForm.number)
                                    Text(bankForm.accountName)
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                }
                            })
                        }
                        .listRowSeparator(.hidden)
                    }
                    
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
                                                    Text(item.equal ? "=" : String(Int(item.getTakenQty(by: selectedFriend?.friendId.uuidString ?? ""))))
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
                                            
                                            if item.friends.count > 0 {
                                                FriendAvatarGroup(friends: item.friends, width: 26, height: 26, overlapOffset: 15, fontSize: 12)
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
                                        Text("Drop")
                                    }
                                    .tint(
                                        (item.getTakenQty(by: selectedFriend?.friendId.uuidString ?? "") == 0 && item.getTakenQty() > 0) || item.getTakenQty() == 0 || item.equal ? .bagirataDimmed : .red)
                                    .disabled(
                                        (item.getTakenQty(by: selectedFriend?.friendId.uuidString ?? "") == 0 && item.getTakenQty() > 0) || item.getTakenQty() == 0 || item.equal)
                                }
                                .swipeActions() {
                                    Button {
                                        var it = item
                                        if let fr = selectedFriend {
                                            it.assignFriend(friend: fr, newQty: 1)
                                            splitItem.updateItem(it)
                                        }
                                    } label: {
                                        Text("Add")
                                    }
                                    .tint(item.getTakenQty() >= item.qty || item.equal ? .bagirataDimmed : .indigo)
                                    .disabled((item.getTakenQty() >= item.qty) || item.equal)
                                }
                                .swipeActions() {
                                    Button() {
                                        var it = item
                                        if it.equal {
                                            it.unEqualAssign()
                                            splitItem.updateItem(it)
                                        } else {
                                            it.equalAssign(assignedFriends: splitItem.friends)
                                            splitItem.updateItem(it)
                                        }
                                    } label: {
                                        Text(!item.equal ? "Equal" : "Unequal")
                                    }
                                    .tint(!item.equal ? .blue : .red)
                                    .disabled(false)
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
                                        
                                        if item.usePercentage {
                                            Text(Percent(item.amount))
                                                .foregroundColor(.gray)
                                        } else {
                                            Text(IDR(item.amount))
                                                .foregroundColor(.gray)
                                        }
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
                            interstisialAdManager.displayInterstisialAd()
                            
                            let transformedSplit = splitted(splitItem: splitItem, bank: bankForm)
                            
                            context.insert(transformedSplit)
                            
                            splittedData = transformedSplit
                            currentSubTab = .split
                            
                            splitItem = SplitItem()
                        }, label: {
                            Text("Continue")
                        })
                        .disabled(splitItem.hasUnassignedItem())
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
                        .padding(.top, 200)
                    }
                }
                .sheet(isPresented: $showBankSheet, content: {
                    AddBank(edit: !bankForm.isEmpty(), userBank: bank, bank: $bankForm)
                    .presentationDetents([.height(400)])
                })
            }
            .onAppear{
                interstisialAdManager.loadInterstisialAd()
            }
            .disabled(!interstisialAdManager.interstisialAdLoaded)
        }
    }
}

#Preview {
    AssignView(currentSubTab: .constant(.assign), splitItem: .constant(SplitItem.example()), splittedData: .constant(Splitted.example()))
}
