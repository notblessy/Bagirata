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
    
    @State private var selectedItem: AssignedItem?
    @State private var selectedOther: OtherItem?
    @State private var showBankSheet: Bool = false
    @State private var showAssignItemSheet: Bool = false
    
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
                    
                    Divider()
                    
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
                    
                    Section("Items") {
                        ForEach(splitItem.items.sorted(by: { $0.createdAt < $1.createdAt })) { item in
                            Button(action: {
                                // Update the item's friends in splitItem.items directly
                                if let idx = splitItem.items.firstIndex(where: { $0.id == item.id }) {
                                    splitItem.items[idx].friends = splitItem.friends.map { friend in
                                        if let assigned = item.friends.first(where: { $0.friendId == friend.friendId }) {
                                            return assigned
                                        } else {
                                            return AssignedFriend(
                                                friendId: friend.friendId,
                                                name: friend.name,
                                                me: friend.me,
                                                accentColor: friend.accentColor,
                                                qty: 0,
                                                subTotal: 0
                                            )
                                        }
                                    }
                                    selectedItem = splitItem.items[idx]
                                } else {
                                    selectedItem = item
                                }
                                showAssignItemSheet = true
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(item.name)
                                                .font(.system(size: 18))
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            // Assignment status indicator
                                            if item.friends.isEmpty {
                                                Image(systemName: "exclamationmark.circle.fill")
                                                    .foregroundColor(.red)
                                                    .font(.system(size: 16))
                                            } else if item.getTakenQty() == item.qty {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 16))
                                            } else {
                                                Image(systemName: "clock.circle.fill")
                                                    .foregroundColor(.orange)
                                                    .font(.system(size: 16))
                                            }
                                        }
                                        
                                        HStack {
                                            Text(qty(item.qty))
                                                .font(.system(size: 16))
                                                .foregroundStyle(.gray)
                                            Text(IDR(item.price))
                                                .font(.system(size: 16))
                                                .foregroundStyle(.gray)
                                            
                                            Spacer()
                                            
                                            Text(IDR(item.price * item.qty))
                                                .foregroundStyle(.gray)
                                        }
                                        
                                        if !item.friends.isEmpty {
                                            HStack {
                                                FriendAvatarGroup(friends: item.friends, width: 26, height: 26, overlapOffset: 15, fontSize: 12)
                                                
                                                Spacer()
                                                
                                                if item.equal {
                                                    Text("Equal Split")
                                                        .font(.system(size: 12))
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 2)
                                                        .background(Color.blue.opacity(0.2))
                                                        .foregroundColor(.blue)
                                                        .cornerRadius(8)
                                                } else {
                                                    Text("Assigned: \(formatQuantity(item.getTakenQty()))/\(formatQuantity(item.qty))")
                                                        .font(.system(size: 12))
                                                        .foregroundStyle(.gray)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    if !splitItem.otherPayments.isEmpty {
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
                .sheet(isPresented: $showBankSheet, content: {
                    AddBank(edit: !bankForm.isEmpty(), userBank: bank, bank: $bankForm)
                        .presentationDetents([.height(400)])
                })
                .sheet(isPresented: $showAssignItemSheet, content: {
                    if let selectedItem = selectedItem {
                        AssignItem(
                            splitItem: $splitItem,
                            item: .constant(selectedItem)
                        )
                        .presentationDetents([.height(600)])
                    }
                })
            }
            .onAppear {
                interstisialAdManager.loadInterstisialAd()
            }
            .disabled(!interstisialAdManager.interstisialAdLoaded)
        }
    }
    
    private func formatQuantity(_ quantity: Double) -> String {
        if quantity.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(quantity))
        } else {
            return String(format: "%.1f", quantity)
        }
    }
}

#Preview {
    AssignView(currentSubTab: .constant(.assign), splitItem: .constant(SplitItem.example()), splittedData: .constant(Splitted.example()))
}
