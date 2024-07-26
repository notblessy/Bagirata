//
//  EditOtherItem.swift
//  Bagirata
//
//  Created by Frederich Blessy on 05/07/24.
//

import SwiftUI

struct EditOtherItem: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var splitItem: SplitItem
    
    @State var id: UUID = UUID()
    @State var name: String = ""
    @State var type: PaymentType = .addition
    @State var amount: String = ""
    @State var createdAt: Date = Date()
    
    let item: OtherItem
    
    private var disabledButton: Bool {
        name.isEmpty || type.rawValue.isEmpty || amount.isEmpty || Int(amount) == 0
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Edit Other")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                    
                    Picker("Type", selection: $type) {
                        Text("Addition").tag(PaymentType.addition)
                        Text("Deduction").tag(PaymentType.deduction)
                        Text("Tax").tag(PaymentType.tax)
                        Text("Discount").tag(PaymentType.discount)
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)
                    .buttonStyle(.bordered)
                    
                    Form {
                        TextField("Name", text: $name)
                        switch type {
                        case .addition, .deduction:
                            ZStack(alignment: .leading) {
                                Text("IDR")
                                    .foregroundStyle(.gray)
                                TextField("Price", text: $amount)
                                    .keyboardType(.numberPad)
                                    .padding(.leading, 35)
                            }
                        default:
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
                                let other = OtherItem(id: id, name: name, type: type.rawValue, amount: amountInt, createdAt: createdAt)
                                splitItem.updateOtherItem(other)
                            }
                            
                            
                            dismiss()
                        }, label: {
                            Text("Edit Other")
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
                    type = PaymentType.ID(rawValue: item.type)!
                    amount = String(Int(item.amount))
                    createdAt = item.createdAt
                }
            }
        }
    }
}

#Preview {
    EditOtherItem(splitItem: .constant(SplitItem.example()), item: OtherItem.example())
}
