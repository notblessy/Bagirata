//
//  EditMe.swift
//  Bagirata
//
//  Created by Frederich Blessy on 09/07/24.
//

import SwiftUI
import SwiftData

struct EditMe: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Query() var banks: [Bank]
    @Query(
        filter: #Predicate<Friend> { friend in
            friend.me
        }
    ) var friend: [Friend]
    
    var bank: Bank? { banks.first }
    var me: Friend? { friend.first }

    @State private var name: String = ""
    @State private var bankName: String = ""
    @State private var bankNumber: String = ""
    @State private var bankAccount: String = ""

    private var disabledButton: Bool {
        name.isEmpty || bankNumber.isEmpty || bankName.isEmpty || bankAccount.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        Text("Edit Your Information")
                            .font(.title2)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Form {
                        Section(header: Text("What is your name?")) {
                            TextField("Name", text: $name)
                        }
                        
                        Section(header: Text("Bank Information")) {
                            TextField("Bank Name", text: $bankName)
                            TextField("Account Name", text: $bankAccount)
                            TextField("Account Number", text: $bankNumber)
                                .keyboardType(.numberPad)
                        }
                    }
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    
                    Button(action: {
                        bank?.name = bankName
                        bank?.number = bankNumber
                        bank?.accountName = bankAccount
                        
                        me?.name = name
                        
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
                    .onAppear {
                        if let meData = me {
                            name = meData.name
                        }
                        
                        if let bankData = bank {
                            bankName = bankData.name
                            bankNumber = String(bankData.number)
                            bankAccount = bankData.accountName
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EditMe()
}
