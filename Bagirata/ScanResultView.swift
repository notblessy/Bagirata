//
//  ScanResultView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

struct ScanResultView: View {
    @State var splitItem: SplitItem
    @State private var selectedItem: AssignedItem?
    
    @State private var showSheet: Bool = false
    @State private var showConfirmation: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                VStack(alignment: .leading) {
                    Text(splitItem.name)
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
                    .onDelete(perform: delete)
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
                        showSheet.toggle()
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                        
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
            .confirmationDialog("Are you sure want to cancel?", isPresented: $showConfirmation, titleVisibility: .visible) {
                Button(action: {
//                    save using swiftdata
                }, label: {
                    Text("Save Draft")
                })
                Button(role: .destructive, action: {
//                    delete itemSplit
                }, label: {
                    Text("Discard")
                })
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        splitItem.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ScanResultView(splitItem: SplitItem.example())
}
