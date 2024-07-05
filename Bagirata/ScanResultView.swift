//
//  ScanResultView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

struct ScanResultView: View {
    @Environment(\.modelContext) private var context
    
    @Binding var currentSubTab: SubTabs
    @Binding var selectedTab: Tabs
    
    @State var splitItem: SplitItem
    @State private var selectedItem: AssignedItem?
    @State private var selectedOther: OtherItem?
    
    @State private var showSheet: Bool = false
    @State private var showOtherSheet: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var showAddConfirmation: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                VStack(alignment: .leading) {
                    TextField("Split Title", text: $splitItem.name)
                        .textFieldStyle(.plain)
                        .font(.title)
                        .bold()
                    Text(splitItem.formatCreatedAt())
                        .font(.system(size: 16))
                        .foregroundStyle(.gray)
                }
                .listRowSeparator(.hidden)
                .padding(.top, 10)
                .padding(.bottom, 5)
                Section("Items") {
                    ForEach(splitItem.items.sorted(by: { $0.createdAt < $1.createdAt })) { item in
                        Button(action: {
                            selectedItem = item
                        }, label: {
                            HStack(alignment: .center, spacing: 10) {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.system(size: 18))
                                        .foregroundStyle(.black)
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
                                        .foregroundStyle(.black)
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
                }
            }
            .listStyle(.plain)
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
                        showAddConfirmation.toggle()
                    }, label: {
                        Label("New", systemImage: "plus")
                        
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
                    .presentationDetents([.height(250)])
            })
            .sheet(item: $selectedItem) { item in
                EditItem(splitItem: $splitItem, item: item)
                    .presentationDetents([.height(250)])
            }
            .sheet(isPresented: $showOtherSheet, content: {
                AddOtherItem(splitItem: $splitItem)
                    .presentationDetents([.height(250)])
            })
            .sheet(item: $selectedOther) { item in
                EditOtherItem(splitItem: $splitItem, item: item)
                    .presentationDetents([.height(250)])
            }
            .confirmationDialog("Are you sure want to cancel?", isPresented: $showConfirmation, titleVisibility: .visible) {
                Button(action: {
                    let split = Split(id: UUID(), name: splitItem.name, status: splitItem.status, items: splitItem.items, otherPayments: splitItem.otherPayments, createdAt: Date())
                    
                    context.insert(split)
                }, label: {
                    Text("Save Draft")
                })
                Button(role: .destructive, action: {
                    selectedTab = .history
                    splitItem = SplitItem()
                }, label: {
                    Text("Discard")
                })
            }
            .confirmationDialog("What do you want to add?", isPresented: $showAddConfirmation, titleVisibility: .visible) {
                Button(action: {
                    showSheet.toggle()
                }, label: {
                    Text("New Item")
                })
                Button(action: {
                    showOtherSheet.toggle()
                }, label: {
                    Text("Other")
                })
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
    ScanResultView(currentSubTab: .constant(.assign), selectedTab: .constant(.result), splitItem: SplitItem.example())
}
