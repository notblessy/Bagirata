//
//  Me.swift
//  Bagirata
//
//  Created by Frederich Blessy on 07/07/24.
//

import SwiftUI

struct Me: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var bankName: String = ""
    @State private var bankNumber: String = ""
    @State private var bankAccount: String = ""
    
    private var disabledButton: Bool {
        name.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("Add Your Information")
                            .font(.title2)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Form {
                        Section(header: Text("What is your name? *")) {
                            TextField("Name", text: $name)
                        }
                        
                        Section(header: Text("Bank Information")) {
                            TextField("Bank Name (optional)", text: $bankName)
                            TextField("Account Name (optional)", text: $bankAccount)
                            TextField("Account Number (optional)", text: $bankNumber)
                                .keyboardType(.numberPad)
                        }
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    
                    Button(action: {
                        if !bankName.isEmpty && !bankAccount.isEmpty && !bankNumber.isEmpty {
                            let bankInfo = Bank(id: UUID(), name: bankName, number: bankNumber, accountName: bankAccount, createdAt: Date())
                            
                            context.insert(bankInfo)
                        }
                        
                        let me = Friend(id: UUID(), name: name, me: true, accentColor: colorGen().toHex(), createdAt: Date())
                        
                        context.insert(me)
                        
                        dismiss()
                        
                        UserDefaults.standard.set(false, forKey: "isFirstView")
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding(5)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(disabledButton)
                    .padding()
                }
            }
        }
    }
}

#Preview {
    Me()
}
