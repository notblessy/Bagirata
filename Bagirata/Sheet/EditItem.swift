//
//  EditItem.swift
//  Bagirata
//
//  Created by Frederich Blessy on 04/07/24.
//

import SwiftUI

struct EditItem: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var splitItem: SplitItem
    
    @State var id: UUID = UUID()
    @State var name: String = ""
    @State var qty: String = ""
    @State var price: String = ""
    @State var createdAt: Date = Date()
    
    let item: AssignedItem
    
    private var disabledButton: Bool {
        name.isEmpty || Int(qty) == 0 || Int(price) == 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Edit Item")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                    
                    Form {
                        TextField("Name", text: $name)
                        HStack {
                            TextField("Qty", text: $qty)
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                            ZStack(alignment: .leading) {
                                Text("IDR")
                                    .foregroundStyle(.gray)
                                TextField("Price", text: $price)
                                    .keyboardType(.numberPad)
                                    .padding(.leading, 35)
                            }
                        }
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)

                    HStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Dismiss")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(5)
                        })
                        .buttonStyle(.bordered)
                        
                        Button(action: {
                            if let qtyInt = Double(qty), let priceInt = Double(price) {
                                let sp = AssignedItem(id: id, name: name, qty: qtyInt, price: priceInt, createdAt: createdAt)
                                
                                splitItem.updateItem(sp)
                            }
                            
                            dismiss()
                        }, label: {
                            Text("Save")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(5)
                        })
                        .disabled(disabledButton)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .onAppear {
                    id = item.id
                    name = item.name
                    qty = String(Int(item.qty))
                    price = String(Int(item.price))
                    createdAt = item.createdAt
                }
            }
        }
    }
}

#Preview {
    EditItem(splitItem: .constant(SplitItem.example()), item: AssignedItem.example())
}
