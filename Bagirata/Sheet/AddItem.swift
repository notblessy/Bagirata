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
    @State var discount: String = ""
    @State var discountIsPercentage: Bool = false
    
    private var disabledButton: Bool {
        name.isEmpty || qty.isEmpty || price.isEmpty || Int(qty) == 0 || Int(price) == 0
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
                            ZStack(alignment: .leading) {
                                Text("IDR")
                                    .foregroundStyle(.gray)
                                TextField("Price", text: $price)
                                    .keyboardType(.numberPad)
                                    .padding(.leading, 35)
                            }
                        }
                        
                        // Discount section
                        Section("Discount (Optional)") {
                            HStack {
                                Toggle(isOn: $discountIsPercentage) {
                                    Text("Use Percentage")
                                        .foregroundStyle(.gray)
                                }
                            }
                            
                            if !discountIsPercentage {
                                ZStack(alignment: .leading) {
                                    Text("IDR")
                                        .foregroundStyle(.gray)
                                    TextField("Discount Amount", text: $discount)
                                        .keyboardType(.numberPad)
                                        .padding(.leading, 35)
                                }
                            } else {
                                ZStack(alignment: .trailing) {
                                    TextField("Discount Percentage", text: $discount)
                                        .keyboardType(.numberPad)
                                        .padding(.trailing, 25)
                                    Text("%")
                                        .foregroundStyle(.gray)
                                }
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
                                var sp = AssignedItem(name: name, qty: qtyInt, price: priceInt)
                                
                                // Apply discount if provided
                                if let discountValue = Double(discount), discountValue > 0 {
                                    sp.discount = discountValue
                                    sp.discountIsPercentage = discountIsPercentage
                                }
                                
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
