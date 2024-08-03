//
//  AddBank.swift
//  Bagirata
//
//  Created by Frederich Blessy on 03/08/24.
//

import SwiftUI

struct AddBank: View {
    @Environment(\.dismiss) var dismiss
    
    var edit: Bool
    var userBank: Bank?
    
    @Binding var bank: Bank
    
    @State var name: String = ""
    @State var number: String = ""
    @State var account: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text(edit ? "Edit Bank" : "Add Bank")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.top, 20)
                    
                    HStack {
                        Button(role: .destructive, action: {
                            account = ""
                            name = ""
                            number = ""
                        }, label: {
                            Text("Clear Form")
                        })
                        .buttonStyle(.bordered)
                        .padding(.top, 20)
                        .disabled(name.isEmpty && account.isEmpty && number.isEmpty)
                        
                        Spacer()
                        
                        Button(action: {
                            if let userBank {
                                account = userBank.accountName
                                name = userBank.name
                                number = userBank.number
                            }
                        }, label: {
                            Text("Use Profile")
                        })
                        .buttonStyle(.bordered)
                        .padding(.top, 20)
                        .disabled(userBank?.isEmpty() ?? false)
                    }
                    .padding(.horizontal, 20)
                    
                    Form {
                        TextField("Bank Name", text: $name)
                        TextField("Account Name", text: $account)
                        TextField("Bank Number", text: $number)
                            .keyboardType(.numberPad)
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
                            bank.accountName = account
                            bank.name = name
                            bank.number = number
                            
                            dismiss()
                        }, label: {
                            Text("Save")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(5)
                        })
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .onAppear {
                if edit && !bank.isEmpty() {
                    name = bank.name
                    account = bank.accountName
                    number = bank.number
                }
            }
        }
    }
}

#Preview {
    AddBank(edit: false, userBank: Bank(),  bank: .constant(Bank()))
}
