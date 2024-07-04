//
//  AddItemView.swift
//  Bagirata
//
//  Created by Frederich Blessy on 03/07/24.
//

import SwiftUI

struct AddItem: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var splitItem: SplitItem
    
    @State var name: String = ""
    @State var qty: String = ""
    @State var price: String = ""
    
    private var disabledButton: Bool {
            name.isEmpty || Int(qty) == 0 || Int(price) == 0
        }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Item")
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
                            let sp = AssignedItem(name: name, qty: qtyInt, price: priceInt)
                            splitItem.items.append(sp)
                        }
                        
                        dismiss()
                    }, label: {
                        Text("Add Item")
                            .frame(maxWidth: .infinity, alignment: .center)
                    })
                    .disabled(disabledButton)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    AddItem(splitItem: .constant(SplitItem()))
}
