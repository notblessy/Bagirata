//
//  ScanResultView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 28/06/24.
//

import SwiftUI

struct ScanResultView: View {
    @Binding var splitItem: ItemSplit
    @State private var showSheet: Bool = false
    
    var body: some View {
        List {
            ForEach(splitItem.items) { item in
                Button(action: {
                    showSheet.toggle()
                }, label: {
                    HStack(alignment: .center, spacing: 10) {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.title2)
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
                            .foregroundStyle(.orange)
                    }
                })
            }
            .onDelete(perform: delete)
            .sheet(isPresented: $showSheet, content: {
                AddFriend()
                    .presentationDetents([.medium])
            })
        }
    }
    
    private func delete(at offsets: IndexSet) {
        splitItem.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ScanResultView(splitItem: .constant(ItemSplit()))
}
