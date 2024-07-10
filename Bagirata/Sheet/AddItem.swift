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
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Add Item")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                    
                    Form {
                        TextField("Name", text: $name)
                        HStack {
                            TextField("Qty", text: $qty)
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                            TextField("Price", text: $price)
                                .keyboardType(.numberPad)
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
                            if let qtyInt = Int(qty), let priceInt = Int(price) {
                                let sp = AssignedItem(name: name, qty: qtyInt, price: priceInt)
                                splitItem.items.append(sp)
                            }
                            
                            dismiss()
                        }, label: {
                            Text("Add Item")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(5)
                        })
                        .disabled(disabledButton)
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}

#Preview {
    AddItem(splitItem: .constant(SplitItem()))
}
