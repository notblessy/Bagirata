//
//  AddOtherItem.swift
//  Bagirata
//
//  Created by Frederich Blessy on 05/07/24.
//

import SwiftUI

struct AddOtherItem: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var type: PaymentType = .addition
    
    @Binding var splitItem: SplitItem
    
    @State var name: String = ""
    @State var amount: String = ""
    
    private var disabledButton: Bool {
        name.isEmpty || type.rawValue.isEmpty || Int(amount) == 0
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Other")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Picker("Type", selection: $type) {
                    Text("Addition").tag(PaymentType.addition)
                    Text("Deduction").tag(PaymentType.deduction)
                }
                .pickerStyle(.palette)
                
                InputText(label: "Name", showLabel: false, borderStyle: "", value: $name)
                    .padding(.top)
                InputText(label: "Amount", showLabel: false, borderStyle: "", value: $amount)
                    .keyboardType(.numberPad)
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
                        if let amountInt = Int(amount) {
                            let other = OtherItem(name: name, type: type.rawValue, amount: amountInt)
                            splitItem.otherPayments.append(other)
                        }
                        
                        
                        dismiss()
                    }, label: {
                        Text("Add Other")
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
    AddOtherItem(splitItem: .constant(SplitItem.example()))
}
