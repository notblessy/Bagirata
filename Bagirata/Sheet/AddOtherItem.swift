//
//  AddOtherItem.swift
//  Bagirata
//
//  Created by Frederich Blessy on 05/07/24.
//

import SwiftUI

struct AddOtherItem: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var type: PaymentType = .tax
    
    @Binding var splitItem: SplitItem
    
    @State var name: String = ""
    @State var amount: String = ""
    @State var usePercentage: Bool = false
    
    private var disabledButton: Bool {
        name.isEmpty || type.rawValue.isEmpty || amount.isEmpty || Int(amount) == 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Add Other")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                    
                    HStack {
                        Picker("Type", selection: $type) {
                            Text("Tax").tag(PaymentType.tax)
                            Text("Addition").tag(PaymentType.addition)
                            Text("Deduction").tag(PaymentType.deduction)
                        }
                        .pickerStyle(.menu)
                        .buttonStyle(.bordered)

                        Toggle(isOn: $usePercentage) {
                            Text("Use Percentage")
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Form {
                        TextField("Name", text: $name)
                        if !usePercentage {
                            ZStack(alignment: .leading) {
                                Text("IDR")
                                    .foregroundStyle(.gray)
                                TextField("Price", text: $amount)
                                    .keyboardType(.numberPad)
                                    .padding(.leading, 35)
                            }
                        } else {
                            ZStack(alignment: .trailing) {
                                TextField("Amount", text: $amount)
                                    .keyboardType(.numberPad)
                                    .padding(.trailing, 25)
                                Text("%")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .padding(.top, -15)
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
                            if let amountInt = Double(amount) {
                                let other = OtherItem(name: name, type: type.rawValue, usePercentage: usePercentage, amount: amountInt)
                                splitItem.otherPayments.append(other)
                            }
                            
                            
                            dismiss()
                        }, label: {
                            Text("Add Other")
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
    AddOtherItem(splitItem: .constant(SplitItem.example()))
}
