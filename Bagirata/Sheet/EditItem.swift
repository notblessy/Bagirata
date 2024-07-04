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
            VStack {
                Text("Edit Item")
                    .font(.title2)
                    .fontWeight(.medium)
                
                InputText(label: "Name", showLabel: false, borderStyle: "", value: $name)
                    .padding(.top)
                HStack {
                    InputText(label: "Qty", showLabel: false, borderStyle: "number", value: $qty)
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                    InputText(label: "Price", showLabel: false, borderStyle: "", value: $price)
                        .keyboardType(.numberPad)
                }
                .padding(.top, 5)

                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Dismiss")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        if let qtyInt = Int(qty), let priceInt = Int(price) {
                            let sp = AssignedItem(id: id, name: name, qty: qtyInt, price: priceInt, createdAt: createdAt)
                            
                            splitItem.updateItem(sp)
                        }
                        
                        dismiss()
                    }, label: {
                        Text("Save")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .disabled(disabledButton)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .onAppear {
                id = item.id
                name = item.name
                qty = String(item.qty)
                price = String(item.price)
                createdAt = item.createdAt
            }
        }
    }
}

#Preview {
    EditItem(splitItem: .constant(SplitItem.example()), item: AssignedItem.example())
}
